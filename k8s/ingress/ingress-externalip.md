***安装ingress-nginx***
```bash
.给ingress添加external ip, 供外部访问
..................................................
#!/bin/bash

#install ingress
#curl -s -x $http_proxy https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/cloud/deploy.yaml > ingress.controller.yaml
#
#/usr/local/k8s/bin/kubectl apply -f ingress.controller.yaml
#
#/usr/local/k8s/bin/kubectl -n ingress-nginx get deploy
#~install ingress
```

***ingress pod 操作***


***添加externalip***
```bash
#给ingress添加external ip, 供外部访问

fINC=/tmp/ingress-nginx-controller.yaml
kubectl get svc ingress-nginx-controller --namespace=ingress-nginx -o yaml > $fINC

if grep 'name: ingress-nginx-controller' $fINC  &> /dev/null
then
   if grep '  externalIPs:$' $fINC
   then
     echo externalIPs is ok ...
   else
     #ExternalIP 经测试,一个IP时 一直可以访问, 多IP只有一个可以访问
     read -p 'Input externalIPs for ingress (like: 192.168.0.100 192.168.0.101) : ' ips
     for ip in ${ips[@]}
     do
       if [ -z $ipstr ]
       then
         ipstr="\"$ip\""
         else
       ipstr="$ipstr, \"$ip\""
       fi
     done
     sed -i "/externalTrafficPolicy: Local/i\  externalIPs: [ $ipstr ]" $fINC
     kubectl apply -f $fINC
   fi
fi
```

***查看externalip***
```
$ kubectl get svc ingress-nginx-controller --namespace=ingress-nginx -o yaml > $fINC
```

***外部访问测试***
```
./etc/hosts
192.168.101.19 nginx-test.a.com

.curl
curl -k https://nginx-test.a.com
```

***ingress 访问路线***
```
client ---> svc:ingress-nginx-controller:(port(externalip:80/clusterip:32689|external:443/clusterip:32530)) --> app service (port 18000) --> deployment (containerip: 80):
```

***ingress service deployment摘要***
```bash
.ingress-nginx-controller (80|443)
#(ExternalIP 经过测试,一个IP时 一直可以访问, 多IP只有一个可以访问)

$ kubectl get svc ingress-nginx-controller --namespace=ingress-nginx
NAME                       TYPE           CLUSTER-IP       EXTERNAL-IP                     PORT(S)                      AGE
ingress-nginx-controller   LoadBalancer   10.254.209.118   192.168.101.19   80:32689/TCP,443:32534/TCP   31h.

.ingress-nginx 
................
(此处指定的是service的18000端口, 但ingress靠nginx-controller(kube-proxy)监听80/443)
(https证书配置在ingress-nginx上)
spec:
  tls:
    - hosts:
        - nginx-test.a.com      #域名
      secretName: nginx-tls     #证书名
  rules:
    - host: nginx-test.a.com
      http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: nginx-ingress-test-service
              port:
                number: 18000


.service (18000)
................
spec:
  ports:
    - port: 18000      #cluster port
      protocol: TCP
      targetPort: 80   #containers port


.deployment (80)
................
spec:
  containers:
    - name: nginx-test-container
      image: nginx
      ports:
        - name: http
          containerPort: 80
```
...................................................


***ingress service deployment完整配置***
```yaml
.Ingress
.............................................
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-nginx-test
  namespace: default
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
    - hosts:
        - nginx-test.a.com
      secretName: nginx-tls
  rules:
    - host: nginx-test.a.com
      http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: nginx-ingress-test-service
              port:
                number: 18000


.service
...................................
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress-test-service
  namespace: default
  labels:
      project: test
      service: nginx-test
      version: "0.1.1"
spec:
  selector:
      project: test
      service: nginx-test
      version: "0.1.1"
  ports:
    - port: 18000
      protocol: TCP
      targetPort: 80


.deployment
................................................
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-test-service
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      project: test
      service: nginx-test
      version: "0.1.1"
  template:
      metadata:
        name: nginx-test-pod
        labels:
          project: test
          service: nginx-test
          version: "0.1.1"
      spec:
        containers:
          - name: nginx-test-container
            image: nginx
            ports:
              - name: http
                containerPort: 80
```

***给ingress添加https证书***
```
1)生成证书
openssl genrsa -out tls.key 2048
openssl req -new -x509 -key tls.key -out tls.crt -subj /C=CN/ST=Guangdong/L=Guangzhou/O=devops/CN=nginx-test.a.com

2)给nginx添加证书,并命名为nginx-tls
kubectl create secret tls nginx-tls --cert=tls.crt --key=tls.key
```

***ingress pod 操作***
```bash
.nginx ingress pods
............................................
$ kubectl get pods -n ingress-nginx

$ kubectl exec -n ingress-nginx -it nginx-ingress-controller-c4f944d4d-sf9mn -- cat /etc/nginx/nginx.conf

$ kubectl exec -n ingress-nginx -it  ingress-nginx-controller-c4f944d4d-sf9mn  -- /bin/bash
```
