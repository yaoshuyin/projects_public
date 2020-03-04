#!/bin/bash
#功能: nginx平滑升级
#Author: trump
#Date: 2020/03/04

#下载编译新版本
newVerNginx=nginx-1.16.1.tar.gz
newVerNginxPath=/tmp/${newVerNginx/.tar.gz}

nginxPath=/opt/nginx
nginxBinPath=$nginxPath/sbin
nginxPidPath=/$nginxPath/logs
nginxConfPath=$nginxPath/conf/nginx.conf
nginxUser=$( ps -f -p $(cat /opt/nginx/logs/nginx.pid) |grep -v 'STIME'|awk '{ print $1; }' )
nginxGroup=$(id $nginxUser | awk '{print $2}' | awk -F '(' '{print $2}' | sed 's/)//')

if id $nginxUser && grep -e "^${nginxGroup}:" /etc/group
then
   echo 获取用户和组 .. ok
else
   echo 获取用户和组 .. 失败 
   exit
fi

cd /tmp/

wget http://nginx.org/download/$newVerNginx && \
tar xvf $newVerNginx  && \
cd $newVerNginxPath && \
./configure --prefix=$nginxPath --with-http_ssl_module --with-http_realip_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_stub_status_module --with-threads --with-stream --with-http_v2_module && \
make

if [ ! -f $newVerNginxPath/objs/nginx ]
then
   echo "新版本编译失败"
   exit
fi

#备份配置
cp -pfr $nginxPath ${nginxPath}.bak.$(date +"%Y%m%dT%H:%M:%S")

#修改配置
#....
# sed -i 's/443 ssl spdy/443 ssl http2/' /opt/nginx/conf/sites/a.com.conf
#....

$nginxPath/sbin/nginx -t -c $nginxConfPath
if [ $? -ne 0 ]
then
   echo $nginxConfPath 配置错误
   exit
fi

#nginx可执行程序替换
nginxTmpFile=/tmp/nginx.tmp.$$
touch $nginxTmpFile
chown --reference=$nginxBinPath/nginx $nginxTmpFile
cp -f $newVerNginxPath/objs/nginx $nginxBinPath/nginx
chown --reference=$nginxTmpFile $nginxBinPath/nginx
rm -f $nginxTmpFile

#修改权限
setcap cap_net_bind_service=+eip $nginxBinPath/nginx

#切换属主
su - $nginxUser

#获取旧的master进程号
oldpid=$( cat $nginxPidPath/nginx.pid )
newpid=""

echo "old nginx pid: $oldpid"

#如果正确获取到了旧master pid
if [[ $oldpid =~ [0-9]+ ]]
then
  #进行升级，启动新master进程
  kill -USR2 $oldpid
  
  sleep 1

  while true
  do 
      #获取新master进程
      if [ -f $nginxPidPath/nginx.pid.oldbin ]
      then
          sleep 1
          newpid=$( cat $nginxPidPath/nginx.pid )

          if [[ $newpid =~ [0-9]+ ]]
          then
             echo newpid is $newpid
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
     kill -WINCH $oldpid

     #旧进程无子进程后退出
     while true
     do
        ps -f --ppid $oldpid | grep -v 'STIME'
        if [ $? -ne 0 ]
        then
           #无工作进程后，让旧master退出
           kill -QUIT $oldpid
           echo " update finished ..."
           exit
        fi

        echo .
        sleep 2
     done
   fi
fi