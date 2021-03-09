**方法一**
```bash
rpm -ivh https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
yum -y install mysql-community-server mysql-community-client
systemctl enable mysqld
systemctl start mysqld
grep "password" /var/log/mysqld.log
  ... A temporary password .. root@localhost: hR;S+g8q#A1/
```

**修改密码**
```mysql
$ mysql -uroot -p
mysql> set global validate_password_policy=LOW;
mysql> set global validate_password_length=6;
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
mysql> grant all privileges on *.* to 'root'@'192.168.0.1' identified by 'password' with grant option;
mysql> flush privileges;
```

......................................

**方法二: download repo**
```
# Go to https://dev.mysql.com/downloads/repo/yum/
wget -O /tmp/mysql.noarch.rpm https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
rpm -ivh /tmp/mysql.noarch.rpm

#yum-config-manager 
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community

#Or dnf-enabled platforms:
dnf config-manager --disable mysql80-community
dnf config-manager --enable mysql57-community
```
