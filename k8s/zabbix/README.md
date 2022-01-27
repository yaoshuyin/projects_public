**k8s**
```
.create user
$ kubectl apply -f zabbix-user.yaml

.get token
$ T=$(kubectl get sa/zabbix-user -n kube-system -o jsonpath='{.secrets[0].name}')
$ kubectl -n kube-system get secret $T -o jsonpath='{.data.token}'| base64 --decode

.get api server
$ kubectl cluster-info|grep Kubernetes|awk -F 'at' '{print $2}'
 https://10.133.30.30:4443
```

**k8s-master01 zabbix_agentd**
```
$ chmod +x /etc/zabbix/scripts/k8s-stats.py
$ vim /etc/zabbix/scripts/k8s-stats.py
  添加上面获得的token和api server ip:port
$ ls /etc/zabbix/zabbix_agentd.d/k8s.conf

$ systemctl restart zabbix-agent
```


**zabbix web**
```
 .Configuration --> Templates --> import
    k8s-template.xml
 
 .configuration --> Hosts --> k8s-master-01
   apply template 'kubernetes'
```
