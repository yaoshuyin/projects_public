### 环境:

```
k8s-ingress-nginx(192.168.20.39) -->
    k8s-master-01~03 (192.168.20.41~43) --->
	  k8s-node-01~02 (192.168.20.44~45)

  glusterfs-01~03 (192.168.30.25~27)
```

### 访问路线
```
  ingress 192.168.20.39:3306 --> mysql service: 3306 --> mysql pod: 3306
```

### 创建glusterfs volume gfs-uat-mysql

```
[root@prod-glusterfs-01 ~]
$ cat volume.create.sh
#!/bin/bash
path=/gfs/uat/mysql
vol=gfs-uat-mysql

for i in 1 2 3
do
   ssh -Tq root@prod-glusterfs-0${i} mkdir -p $path
done

gluster volume create $vol replica 3 prod-glusterfs-01:$path prod-glusterfs-02:$path prod-glusterfs-03:$path force

gluster volume info $vol
gluster volume start $vol

$ chmod +x volume.create.sh
$ ./volume.create.sh
```

### 创建etc子目录 (不能直接写目录，一定要先mount)
```bash
$ mkdir /tmp/mysql
$ mount -t glusterfs prod-glusterfs-01:/gfs-uat-mysql /tmp/mysql/
$ mkdir /tmp/mysql/etc

$ cat > /tmp/mysql/etc/my.cnf <<'EOF'
[root@prod-glusterfs-01 etc]# cat my.cnf
[client]
default-character-set = utf8mb4
socket=/var/run/mysqld/mysqld.sock

[mysql]
default-character-set = utf8mb4
socket=/var/run/mysqld/mysqld.sock

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
log-error       = /var/log/mysql/error.log
bind-address    = 0.0.0.0
symbolic-links  = 0

character-set-client-handshake = false
character-set-server           = utf8mb4
collation-server               = utf8mb4_general_ci
init_connect                   = 'SET NAMES utf8mb4'
join_buffer_size               = 64M


lower_case_table_names         = 1
sql_mode                       = NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
skip-name-resolve

default-storage-engine         = InnoDB
innodb_file_per_table          = 1
innodb_buffer_pool_size        = 2G
max_connections                = 1000

slow_query_log = true
slow_query_log_file = /var/lib/mysql/slowlogs/slow_query_log.log
long_query_time = 1
log-slow-admin-statements
log-queries-not-using-indexes

max_allowed_packet = 512M
EOF

$ ls -l /tmp/mysql/etc/
-rw-r--r-- 1 root root my.cnf

$ ls -l /gfs/uat/mysql/etc/
-rw-r--r-- 1 root root my.cnf
```

### k8s yaml
$ cat mysql.yaml
apiVersion: v1
kind: Namespace
metadata:
   name: ns-mysql
   labels:
     name: ns-mysql

---
apiVersion: v1
kind: Endpoints
metadata:
  name: ep-gfs-nsmysql-deploymysql-podmysql01
  namespace: ns-mysql
subsets:
- addresses:
  - ip: 192.168.30.28
  ports:
  - port: 49154
    protocol: TCP

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: ns-mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - image: mysql:5.7
        imagePullPolicy: IfNotPresent
        name: mysql
        env:
          - name: MYSQL_ROOT_PASSWORD
            value: "123456"
        ports:
          - containerPort: 3306
            name: "port3306"
        volumeMounts:
        - mountPath: /var/lib/mysql
          name: gfs-pvc-var-lib-mysql
          subPath: data
        - mountPath: /etc/mysql
          name: gfs-pvc-var-lib-mysql
          subPath: etc
      volumes:
      - name: gfs-pvc-var-lib-mysql
        glusterfs:
          endpoints: ep-gfs-nsmysql-deploymysql-podmysql01
          path: /gfs-uat-mysql
          readOnly: false

---
apiVersion: v1
kind: Service
metadata:
  name: uat-mysql-svc
  namespace: ns-mysql
spec:
  ports:
    - port: 3306
      targetPort: 3306
  selector:
    app: mysql

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: tcp-services
  namespace: ingress-nginx
data:
  3306: "ns-mysql/uat-mysql-svc:3306"
```

### apply yaml
```bash
$ kubectl apply -f mysql.yaml
```

### 修改ingress配置，添加tcp3306转发
```bash
#!!!注意  $(POD_NAMESPACE) 保持这个原样，不要变化

$ kubectl edit deployment ingress-nginx-controller -n ingress-nginx
    spec:
      containers:
      - args:
        ...
        - --tcp-services-configmap=$(POD_NAMESPACE)/tcp-services

$ kubectl edit service ingress-nginx-controller -n ingress-nginx
        
  ports:
  - name: proxied-tcp-3306
    port: 3306
    protocol: TCP
    targetPort: 3306
```

### 访问ingress的33006进行测试
```mysql
$ mysql -h 192.168.20.39 -uroot -p123456 -P 3306

mysql> status;
--------------
Server version:       5.7.35-log MySQL Community Server (GPL)
Connection:           192.168.20.39 via TCP/IP
Server characterset:  utf8mb4
Db     characterset:  utf8mb4
Client characterset:  utf8mb4
Conn.  characterset:  utf8mb4
TCP            port:  3306
```
