
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


.安装jenkins
..............................
$ wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
$ rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
$ yum provides '*/applydeltarpm'
$ yum install deltarpm -y

$ yum install -y jenkins

$ vim /etc/sysconfig/jenkins
   JENKINS_PORT="8081"
   JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Xms256m -Xmx256m -XX:MaxNewSize=256m -XX:MaxPermSize=256m"

$ yum -y install initscripts
$ chkconfig jenkins on
$ service jenkins start
$ service jenkins status
$ netstat -tnlp
$ cat /var/lib/jenkins/secrets/initialAdminPassword

$ http://127.0.0.1:8081/


.安装gitlab
..........................
$ curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
$ yum update
$ yum install giblab-ce

$ /opt/gitlab/embedded/bin/runsvdir-start &
$ sed  -i 's/^external_url .*$/external_url "http:\/\/172.17.0.3:8000"/g' /etc/gitlab/gitlab.rb
$ sed -i "s/# nginx\['listen_port'\] = nil/  nginx\['listen_port'\] = 8000/g" /etc/gitlab/gitlab.rb

$ gitlab-ctl reconfigure
$ gitlab-ctl status
#gitlab-ctl restart

.安装maven
...............................
.maven
$ wget https://mirrors.bfsu.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
$ tar xvf apache-maven-3.6.3-bin.tar.gz
$ mv apache-maven-3.6.3 /data/softs/maven

$ grep MAVEN_HOME /etc/profile || cat >> /etc/profile <<EOF

export MAVEN_HOME=/data/softs/maven
export PATH=$PATH:$MAVEN_HOME/bin
EOF

.创建tom.schat.niu项目
........................
$ export http_proxy=172.17.0.1:8889
$ export https_proxy=172.17.0.1:8889
$ mvn archetype:generate -DgroupId=top.schat.niu -DartifactId=niu -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false

[INFO] Parameter: basedir, Value: /tmp/niu
[INFO] Parameter: package, Value: top.schat.niu
[INFO] Parameter: groupId, Value: top.schat.niu
[INFO] Parameter: artifactId, Value: niu
[INFO] Parameter: packageName, Value: top.schat.niu
[INFO] Parameter: version, Value: 1.0-SNAPSHOT
[INFO] project created from Old (1.x) Archetype in dir: /tmp/niu/niu
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  03:53 min
[INFO] Finished at: 2021-02-19T00:24:10Z
[INFO] -------------------------------------------------------------


[root@jenkins2 niu]# tree .
.
├── pom.xml
└── src
    └── main
        ├── resources
        └── webapp
            ├── index.jsp
            └── WEB-INF
                └── web.xml

$ mvn compile
$ mvn install
#maven web app打包成app.war。
$mvn  clean package '-Dmaven.test.skip=true'

```
