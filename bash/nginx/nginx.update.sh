#!/bin/bash
#功能: nginx平滑升级
#Author: trump
#Date: 2020/03/04

#变量配置
newVerNginx=nginx-1.16.1.tar.gz
newVerNginxPath=/tmp/${newVerNginx/.tar.gz}

nginxPath=/opt/nginx
nginxBinPath=$nginxPath/sbin
nginxPidPath=/$nginxPath/logs
nginxConfPath=$nginxPath/conf/nginx.conf
nginxUser=$( ps -f -p $(cat /opt/nginx/logs/nginx.pid) |grep -v 'STIME'|awk '{ print $1; }' )
nginxGroup=$(id $nginxUser | awk '{print $2}' | awk -F '(' '{print $2}' | sed 's/)//')
#~变量配置

function echoln() {
   echo -e "$1 \n"
}

function check() {
  _pid=$1
  echo
  ps -f --pid $_pid  | grep -v 'STIME'|grep -v grep
  ps -f --ppid $_pid  | grep -v 'STIME'|grep -v grep

  #ps -ef |grep nginx | grep -Ev 'grep|nginx.update.sh'
  echo
}

#验证用户和组 ..................
if id $nginxUser && grep -E "^${nginxGroup}:" /etc/group
then
   echoln "1) 获取用户和组 .. ok"
else
   echoln "1) 获取用户和组 .. 失败"
   exit
fi

#下载编译 .....................

echoln "2) 下载$newVerNginx编译"

cd /tmp/
[ -f /tmp/$newVerNginx ] || wget -c http://nginx.org/download/$newVerNginx 
[ -f /tmp/$newVerNginx ] && tar xvf $newVerNginx  && \
cd $newVerNginxPath && \
./configure --prefix=$nginxPath --with-http_ssl_module --with-http_realip_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_stub_status_module --with-threads --with-stream --with-http_v2_module && \
make

echo
if [ ! -f $newVerNginxPath/objs/nginx ]
then
   echoln "新版本编译 .. 失败"
   exit
else
   echoln "新版本编译 .. 成功"
fi

#备份原数据 .......................
echoln "4) 备份配置"
#time cp -pfr $nginxPath ${nginxPath}.bak.$(date +"%Y%m%dT%H:%M:%S")


#新旧可执行程序替换 .................
echo
echoln "5) nginx可执行程序替换"
nginxTmpFile=/tmp/nginx.tmp.$$
touch $nginxTmpFile
chown --reference=$nginxBinPath/nginx $nginxTmpFile
cp -f $newVerNginxPath/objs/nginx $nginxBinPath/nginx
chown --reference=$nginxTmpFile $nginxBinPath/nginx
setcap cap_net_bind_service=+eip $nginxBinPath/nginx
rm -f $nginxTmpFile

echo
$nginxBinPath/nginx -v


#相应配置修改 .....................
echoln "6) 修改配置"

#....
# sed -i 's/443 ssl spdy/443 ssl http2/' /opt/nginx/conf/sites/a.com.conf
#....
sed -i 's/443 ssl spdy/443 ssl http2/' $nginxPath/conf/sites/quickpay.http.conf

echoln "7) 验证配置"
$nginxPath/sbin/nginx -t -c $nginxConfPath
if [ $? -ne 0 ]
then
   echo $nginxConfPath 配置错误
   exit
fi

#正式切换 ......................
#获取旧的master进程号
oldpid=$( cat $nginxPidPath/nginx.pid )
newpid=""

echoln "8) 进行新旧master切换"

echo
echo "old nginx master pid: $oldpid"
check $oldpid

#如果正确获取到了旧master pid
if [[ $oldpid =~ [0-9]+ ]]
then
  #进行升级，启动新master进程
  su - $nginxUser -c "kill -USR2 $oldpid"

  sleep 1

  while true
  do 
      #获取新master进程
      if [ -f $nginxPidPath/nginx.pid.oldbin ]
      then
          sleep 1
          newpid=$( cat $nginxPidPath/nginx.pid )

          if [[ $newpid =~ [0-9]+ ]] && [ $newpid != $oldpid ]
          then
             echo new nginx master pid is $newpid
             check $newpid
             break
          else
             echo invalid new pid $newpid
             exit
          fi
      fi

      echo wating new pid ...
      sleep 1
  done

  #如果正确获取到了新master pid,则关停旧master进程
  if [[ $newpid =~ [0-9]+ ]]
  then
     #旧进程清理worker子进程
     su - $nginxUser -c "kill -WINCH $oldpid"

     sleep 2
     echo

     #旧进程无子进程后退出
      while true
      do
        ps -f --ppid $oldpid | grep -v 'STIME' | grep 'nginx: worker process' > /dev/null
        if [ $? -ne 0 ]
        then
           echo
            sleep 600
           #无工作进程后，让旧master退出
           su - $nginxUser -c "kill -QUIT $oldpid"
           check
           echo "update finished ..."
           exit
        fi

        echo -n .
        sleep 60
     done
   fi
fi