#!/bin/bash
#Author: tomyao
#nginx_upstream_check.sh
#Date: 202108040936

# $ /data/scripts/nginx_upstream_check.sh
#     checking server: 10.133.30.18:80 ...
#     info: /etc/nginx/sites-enabled/luchehang.ydfinance.com.cn 10.133.30.18:80 status code:200 ... is up now

#     checking server: 10.133.30.29:80 ...
#     info: /etc/nginx/sites-enabled/model.ydfinance.com.cn 10.133.30.29:80 status code:404 ... is up now
#

source /etc/profile
source /root/.bashrc

fs=$(grep -ER '\s*upstream ' /etc/nginx | awk -F : '{ print $1;}'|sort -u|uniq)

changed=0
for f in ${fs[@]}
do
  servers=$(sed -nr -e 's/;//g' -e '/^\s*upstream /,/^\s*}\s*$/P' $f|grep server|grep -Ev '\s*#' |awk '{print $2}'|sed 's/;//'|sort|uniq)

  for server in ${servers[@]}
  do
    echo "checking server: $server ..."

    #tcp
    if [[ $server =~ ([0-9]+\.){3}[0-9]+:[0-9]+ ]]
    then
      port=${server##*:}
      host=${server%%:*}
    else
      port=80
      host=$server
    fi

    #nc -w 2 -zv $host $port
    #~tcp

    code=$(curl -L -s -m 10 -o /dev/null -w '%{http_code}' http://${host}:${port} )
    if [[ $code =~ 200|301|302|400|403|404|401 ]]
    then
      echo -n "info: $f $host:$port status code:$code ... is up now"
      grep -E "server $server down" $f &>/dev/null && sed -i '/^\s*upstream /,/^\s*}\s*$/ s/server '$server' down/server '$server'/g' $f && changed=1 && echo " (  change upstream to up from down)" && /usr/bin/logger -t nginx_upstream_check "$server change upstream to up from down"
      echo
    else
      echo -n "_WaRn: $f $host:$port status code:$code... is down now"

      grep -E "server $server down" $f &>/dev/null || { sed -i '/^\s*upstream /,/^\s*}\s*$/ s/server '$server'/server '$server' down/g' $f && changed=1 && echo "( change upstream to down from up)" && /usr/bin/logger -t nginx_upstream_check "$server change upstream to down from up" ; }
      echo
    fi
    echo
  done
done

[ $changed -eq 1 ] && /usr/sbin/nginx -s reload && echo "nginx service reloaded" && /usr/bin/logger -t nginx_upstream_check "nginxservice reloaded"
