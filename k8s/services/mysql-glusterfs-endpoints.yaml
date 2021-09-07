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
  - ip: 10.133.30.28
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
