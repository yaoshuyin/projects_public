```
$ https://www.zabbix.com/download?zabbix=5.0&os_distribution=centos&os_version=7&db=mysql&ws=nginx

$ yum -y install epel-release


centos8-zabbix5.2-nginx
$ rpm -Uvh https://repo.zabbix.com/zabbix/5.2/rhel/8/x86_64/zabbix-release-5.2-1.el8.noarch.rpm
$ dnf clean all 
dnf install zabbix-server-mysql zabbix-web-mysql zabbix-nginx-conf zabbix-agent 

...............................

centos7-zabbix5.0-nginx
$ rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
$ yum clean all

$ yum install zabbix-server-mysql zabbix-agent
$ yum install centos-release-scl
 
$ vim /etc/yum.repos.d/zabbix.repo
[zabbix-frontend]
...
enabled=1


$ yum install zabbix-web-mysql-scl zabbix-nginx-conf-scl 
 
install mysql
$ rpm -ivh https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
$  yum -y install mysql-community-server  yum -y install mysql-community-client
$ systemctl enable mysqld
$ systemctl start mysqld
$ grep "password" /var/log/mysqld.log
  ... A temporary password .. root@localhost: hR;S+g8q#A1/

$ mysql -uroot -p
mysql> set global validate_password_policy=LOW;
mysql> set global validate_password_length=6;
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
mysql> grant all privileges on *.* to 'root'@'192.168.0.1' identified by 'password' with grant option;
mysql> flush privileges;

$ wget -c https://cdn.zabbix.com/zabbix/sources/stable/5.0/zabbix-5.0.9.tar.gz
$ tar xvf zabbix-5.0.9.tar.gz
$ cd zabbix-5.0.9/database/mysql/
$ cat scheme.sql images.sql data.sql double.sql | mysql -uzabbix -p123456 zabbix

$ yum install nginx
$ vim /etc/nginx/nginx.conf
    server {
        listen 80 default_server;
        server_name  _;

        index index.html index.php zabbix.html zabbix.php;
        root /usr/share/zabbix/;

        location ~ .*\.php$ {
        include fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME
        $document_root$fastcgi_script_name;
    }

sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /etc/php.ini

sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php.ini

sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/php.ini

sed -i 's/;date.timezone =/date.timezone = "Asia\/Shanghai"/g' /etc/php.ini

yum install php-mysql

http://172.18.0.8/setup.php

http://172.18.0.8
默认用户名: Admin
默认密码:   zabbix


.
#firewall-cmd --permanent --add-port=10050/tcp
#firewall-cmd --permanent --add-port=10051/tcp
#firewall-cmd --permanent --add-port=80/tcp
#firewall-cmd --reload


systemctl enable zabbix-agent
systemctl start zabbix-agent

中文手册: https://www.zabbix.com/documentation/4.0/zh/manual/installation/install_from_packages/rhel_centos


.邮件告警
 Configuration
   Actions(启用或添加自己的action)
      从Report problems to Zabbix administrators    ... Enabled
   
 Adminstration
   Media types
      Email
         Name: Email
         Type: Email
         SMTP server: smtp.qq.com
         SMTP server port: 465
         SMTP helo: qq.com
         SMTP email: 21430000@qq.com
         Connection security: SSL/TLS
         Authentication: Username and password
         Username: 21430000
         Password: xxxxxxx
         Enabled: ☑
  
 Users:
    Admin
       Media
          Type: Email
          Send to:   21430000@qq.com
                     cxxxx@163.com
          Enabled: ☑      
         
 #如果不发邮件，则重启服务        
 systemctl restart zabbix-server
 
 
 .飞书
 
 1）使用飞书APP扫马登陆开发者后台
 https://open.feishu.cn/app
 
 2）创建企业应用
       注意修改 图标
 
 3）应用功能
       机器人       启用
 4) 权限管理
       点击 各权限
 5) 版本管理与发布
       
 6) 执行脚本测试
    yum install python3-pip
    ./feishu.py 18550022185,18550022185 test "testxxxx mmmm kkkk"
   
 
 7) Zabbix
       Administration
          Media types
             Create media type
    Media type:            
      Name: feishu
      Type: Script
      Script name: feishu.py
      Script parameters:
         {ALERT.SENDTO}
         {ALERT.SUBJECT}
         {ALERT.MESSAGE}
      Description:
         {ALERT.SENDTO}:   185xxxxxxxx,131xxxxxx
         {ALERT.SUBJECT}:  Memory Too High
         {ALERT.MESSAGE}:  xxxxx,xxxx ccc vv 
    
    Message templates(点Add): 依次添加 Problem、Problem Recovery、Problem update、Discovery、Autoregistration
     编辑 Problem Recovery, 添加: Problem Recovery History: {EVENT.ACK.HISTORY}， 这样当手工关闭时会发送 手动关闭时填写的内容
```     
      
**feishu.py**
```python
#!/usr/bin/python3
#conding=utf-8
#Usage: ./feishu.py 131xxxxxxxx,18550xxxxx msgtitle "testxxxx  mmmm  kkkk llll"
import requests,json,sys,time

group="ZabbixAlertGroup"
mobiles=sys.argv[1].replace(',','&mobiles=')    #接收消息的手机号
subject=sys.argv[2]
messages=sys.argv[3] 

app_id="..."
app_secret="...."

def gettenant_access_token():
    tokenurl="https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal/"
    headers={"Content-Type":"application/json"}
    data={
        "app_id": app_id,
        "app_secret": app_secret

    }
    request=requests.post(url=tokenurl,headers=headers,json=data)
    #print(request.content)
    response=json.loads(request.content)['tenant_access_token']
    return response

def getuserids(tenant_access_token):
    userurl="https://open.feishu.cn/open-apis/user/v1/batch_get_id?mobiles=%s"%mobiles
    headers={"Authorization":"Bearer %s"%tenant_access_token}
    request=requests.get(url=userurl,headers=headers)
    #print(request.content)
    response=json.loads(request.content)['data']['mobile_users'] #[0]['user_id']
    ulist=[]
    for k in response:
        #print(response[k])
        ulist.append(response[k][0]['user_id'])
    return ulist

def getopenids(tenant_access_token):
    userurl="https://open.feishu.cn/open-apis/user/v1/batch_get_id?mobiles=%s"%mobiles
    headers={"Authorization":"Bearer %s"%tenant_access_token}
    request=requests.get(url=userurl,headers=headers)
    #print(request.content)
    response=json.loads(request.content)['data']['mobile_users'] #[0]['open_id']
    olist=[]
    for k in response:
        olist.append(response[k][0]['open_id'])
    return olist

def get_group_chatid(tenant_access_token):
    url="https://open.feishu.cn/open-apis/chat/v4/list/"
    headers={"Authorization":"Bearer %s"%tenant_access_token,"Content-Type":"application/json"}
    request=requests.get(url=url,headers=headers)
    #print(request.content)
    response=json.loads(request.content)['data']['groups']
    for g in response:
        if group == g["name"]:
           return g["chat_id"]
    return False

def creategroup(tenant_access_token,ulist,olist):
    url="https://open.feishu.cn/open-apis/chat/v4/create/"
    headers={"Authorization":"Bearer %s"%tenant_access_token,"Content-Type":"application/json"}
    data={"name":group,"user_ids":ulist,"open_ids":olist}
    request=requests.post(url=url,headers=headers,json=data)
    #print(request.content)
    return json.loads(request.content)['data']['chat_id']

def addingroup(tenant_access_token,chat_id,ulist,olist):
    url="https://open.feishu.cn/open-apis/chat/v4/chatter/add/"
    headers={"Authorization":"Bearer %s"%tenant_access_token,"Content-Type":"application/json"}
    data={"chat_id":chat_id,"user_ids":ulist,"open_ids":olist}
    request=requests.post(url=url,headers=headers,json=data)
    print(request.content)

def sendmsg(chat_id,tenant_access_token):
    sendurl="https://open.feishu.cn/open-apis/message/v4/send/"
    headers={"Authorization":"Bearer %s"%tenant_access_token,"Content-Type":"application/json"}
 
    data={  
        "chat_id":chat_id,
        "msg_type":"text",
        "content":{
            #"text":"%s<at user_id=\"%s\">test</at>"%(messages,user_id)
            "text":"%s\n%s"%( time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), messages)
  
        }
    }
    request=requests.post(url=sendurl,headers=headers,json=data)
    #print(request.content)


def run():
    tenant_access_token=gettenant_access_token()
    ulist=getuserids(tenant_access_token)
    olist=getopenids(tenant_access_token)
    chat_id=get_group_chatid(tenant_access_token)
    if chat_id == False:
        chat_id=creategroup(tenant_access_token,ulist,olist)
    addingroup(tenant_access_token,chat_id,ulist,olist)
    sendmsg(chat_id,tenant_access_token)

run()
```
