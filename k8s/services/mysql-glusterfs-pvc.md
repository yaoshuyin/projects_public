```yaml
apiVersion: v1
kind: Namespace
metadata:
   name: ns-mysql
   labels:
     name: ns-mysql

---
#.storageClass
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gfs-storage-class
provisioner: kubernetes.io/glusterfs
#reclaimPolicy: Retain
volumeBindingMode: Immediate
allowVolumeExpansion: true
parameters:
  resturl: http://10.133.30.27:8080
  clusterid: "676d19ab882cd85b5b1a9e3425f323f7"
  volumetype: replicate:3
  restauthenabled: "false"
  #restuser: "admin"
  #restuserkey: "admin"


---
#pvc
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gfs-pvc-20gb
  namespace: ns-mysql
spec:
  storageClassName: gfs-storage-class
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 20Gi

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gfs-pvc-1gb
  namespace: ns-mysql
spec:
  storageClassName: gfs-storage-class
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi

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
        - mountPath: /etc/mysql
          name: gfs-pvc-etc-mysql
      volumes:
      - name: gfs-pvc-var-lib-mysql
        persistentVolumeClaim:
          claimName: gfs-pvc-20gb
      - name: gfs-pvc-etc-mysql
        persistentVolumeClaim:
          claimName: gfs-pvc-1gb
```
