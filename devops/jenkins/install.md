
```
.架构
jenkins :8081
gitlab  :8000
tomcat  :80

.....................................

.安装依赖
$ yum install -y net-tools network-tools which vim wget 

......................................

.安装openjdk
$ yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

$ grep -R JAVA_HOME /etc/profile || cat >>/etc/profile <<'EOF'

export JAVA_HOME=/usr/lib/jvm/java-1.8.0
export JRE_HOME=/usr/lib/jvm/java-1.8.0/jre

export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/jre/lib/rt.jar
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
EOF

$ . /etc/profile

$ java -version
openjdk version "1.8.0_282"
OpenJDK Runtime Environment (build 1.8.0_282-b08)
OpenJDK 64-Bit Server VM (build 25.282-b08, mixed mode)

.........................................

.安装tomcat
...................

$ wget https://mirror-hk.koddos.net/apache/tomcat/tomcat-10/v10.0.2/bin/apache-tomcat-10.0.2.tar.gz -O /tmp/tomcat.tar.gz

$ tar -C /data/ -xvf /tmp/tomcat.tar.gz
$ mv /data/apache-tomcat-10.0.2  /data/tomcat

$ cd /data/tomcat/bin/

.修改端口
.....................
$ vim conf/server.xml
      <Connector port="80" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="443" />

.tomcat manager-gui
.....................

1) vim webapps/manager/META-INF/context.xml
     <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|172\.17\.\d+\.\d+" />
2) 
 <role rolename="admin-gui"/>
  <role rolename="manager-gui"/>
  <role rolename="manager-script" />
  <role rolename="manager-jmx" />
  <role rolename="manager-status" />
  <user username="tomcat" password="tomcat" roles="admin-gui,manager-gui,manager-script,manager-jmx,manager-status" />

.启动
.....................
$ ./startup.sh

.访问
.....................
3) http://172.17.0.3
3) http://172.17.0.3/manager/html

.

```
