***.客户端(如k8s-node节点上)***
```
#在客户端(如k8s-node)节点上需要添加glusterfs服务器各节点的hosts (否则报错: Mount failed. Check the log file  for more details.)
10.133.30.25 prod-glusterfs-01
10.133.30.26 prod-glusterfs-02
10.133.30.27 prod-glusterfs-03
```

***.在glusterfs服务器上创建volume***
```bash
vol=nsmysql-deploymysql-podmysql01

path=/data/gfs/$vol

nodes=( prod-glusterfs-01 prod-glusterfs-02 prod-glusterfs-03 )  

cmd="gluster volume create $vol replica 3 "
for node in ${nodes[@]}
do
   ssh root@$node mkdir $path
   cmd="$cmd $node:$path "
done

$cmd force

gluster volume start $vol
gluster volume list
gluster volume status   (可以看到新创建volume的端口49154)

***挂载测试 (格式: /volumeName)***
mount -t glusterfs 10.133.30.26:/nsmysql-deploymysql-podmysql01 /tmp/ttt
```

***.k8s endponits***
```yaml
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
  - ip: 10.133.30.25
  - ip: 10.133.30.26
  - ip: 10.133.30.27
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
      volumes:
      - name: gfs-pvc-var-lib-mysql
        glusterfs:
          endpoints: ep-gfs-nsmysql-deploymysql-podmysql01
          path: /nsmysql-deploymysql-podmysql01
          readOnly: false
```
