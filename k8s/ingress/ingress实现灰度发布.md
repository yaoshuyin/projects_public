> ***简介***
>* 使用Kubernetes想实现应用的蓝绿部署用来迭代应用版本(用lstio太重太复杂，而且它本身定位于流控和网格治理)
>* Ingress-Nginx轻松实现蓝绿发布和金丝雀发布
>* 灰度发布可保证系统的稳定,可对新版本进行测试、发现和调整问题
>* Ingress-Nginx在0.21版本引入了Canary( [kəˈneəri]金丝雀)功能，可为网关入口配置多个版本的应用程序,使用annotation来控制多个后端服务的流量分配

# 启用Canary功能
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/canary: "true"
    
    #header的key, 适用于灰度发布或者A/B测试
    nginx.ingress.kubernetes.io/canary-by-header: "v2" 
    
    #header之key的value(always/never/其它值:: always:流量一直分配到Canary入口 / never: 流量不会分配到Canary入口 / 其他hearder值: 值将被忽略,而后视weight优先级进行流量分配)
    nginx.ingress.kubernetes.io/canary-by-header-value: "xx"
    
    #流量百分比,决定百分之多少的流量会分配到Canary Ingress的后端服务
    nginx.ingress.kubernetes.io/canary-weight: "50" 
    
    #基于cookie的流量切分，当cookie值设置为always时，请求流量将被路由到Canary Ingress入口
    #当cookie值设置为never时，请求流量将不会路由到Canary入口
    #对于其他值，将忽略，并通过weight优先级将请求流量分配到其他规则
    #nginx.ingress.kubernetes.io/canary-by-cookie: "mycookie"


    优先顺序：canary-by-header > canary-by-cookie > canary-weight
```

# canary-weight

## v1版本

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
   name: test
   labels:     name: test
   
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  labels:
    app: v1
  name: v1
  namespace: test
spec:
  rules:
  - host: a.com
    http:
      paths:
       - path: /
         pathType: Prefix
         backend:
           service:
             name: v1
             port:
               number: 80
---
kind: Service
apiVersion: v1
metadata:
  name:  v1
  namespace: test
spec:
  selector:
    name:  v1
  type:  ClusterIP
  ports:
  - name:  v1
    port:  80
    targetPort:  80
	
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name:  v1
  namespace: test
  labels:
    name:  v1
spec:
  selector:
    matchLabels:
      name: v1
  template:
    metadata:
      labels:
        name:  v1
    spec:
      containers:
      - image:  nginx:1.20
        name:  v1
        ports:
        - containerPort:  80
          name:  v1
        lifecycle:
          postStart:
            exec:
              command: [ "/bin/sh", "-c", "echo v1 > /usr/share/nginx/html/index.html" ]
```	  


## v2版本的服务

***将v2版本的权重设置为50%***
```yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "30"

  labels:
    app: v2
  name: v2
  namespace: test
spec:
  rules:
  - host: a.com
    http:
      paths:
       - path: /
         pathType: Prefix
         backend:
           service:
             name: v2
             port:
               number: 80

---
kind: Service
apiVersion: v1
metadata:
  name:  v2
  namespace: test
spec:
  selector:
    name:  v2
  type:  ClusterIP
  ports:
  - name:  v2
    port:  80
    targetPort:  80
	
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name:  v2
  namespace: test
  labels:
    name:  v2
spec:
  selector:
    matchLabels:
      name: v2
  template:
    metadata:
      labels:
        name:  v2
    spec:
      containers:
      - image:  nginx:1.21
        name:  v2
        ports:
        - containerPort:  80
          name:  v2
        lifecycle:
          postStart:
            exec:
              command: [ "/bin/sh", "-c", "echo v2 > /usr/share/nginx/html/index.html" ]
```		  
  
***访问测试***

```bash
$ for i in {1..20}; do curl -s --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v1
v2
v2
v1
v1
v2
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v2
v2
v2
v2

v1:13 v2:7(35%)

```

# 基于header的A/B测试

## 更改v2版本的编排文件

```yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "30"
	nginx.ingress.kubernetes.io/canary-by-header: "v2"   #！！！添加这一行
  labels:
    app: v2
  name: v2
  namespace: test
spec:
  rules:
  - host: a.com
    http:
      paths:
       - path: /
         pathType: Prefix
         backend:
           service:
             name: v2
             port:
               number: 80

---
kind: Service
apiVersion: v1
metadata:
  name:  v2
  namespace: test
spec:
  selector:
    name:  v2
  type:  ClusterIP
  ports:
  - name:  v2
    port:  80
    targetPort:  80
	
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name:  v2
  namespace: test
  labels:
    name:  v2
spec:
  selector:
    matchLabels:
      name: v2
  template:
    metadata:
      labels:
        name:  v2
    spec:
      containers:
      - image:  nginx:1.21
        name:  v2
        ports:
        - containerPort:  80
          name:  v2
        lifecycle:
          postStart:
            exec:
              command: [ "/bin/sh", "-c", "echo v2 > /usr/share/nginx/html/index.html" ]
```

***访问测试***

```bash
#不加任何v2头，则默认使用weight 30%来访问v2

$ root@tom:/tmp/ssl# for i in {1..20}; do curl -s --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v2
v2
v1
v1
v2
v1
v1
v1
v1
v2
v1
v1
v1
v1
v2
v2
v2
v1
v1
v1

v1:13 v2:7(35%)

#添加v2:always头，则只访问v2
$ for i in {1..20}; do curl -H "v2:always" -s --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2

v1:0 v2:20(100%)

#添加v2:never头，则永不访问v2
$ for i in {1..20}; do curl -H "v2:never" -s --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1

v1:20 v2:0(0%)

```

## 自定义header-value
```
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "30"
	nginx.ingress.kubernetes.io/canary-by-header: "v2"
	nginx.ingress.kubernetes.io/canary-by-header-value: "xx"
  labels:
    app: v2
  name: v2
  namespace: test
spec:
  rules:
  - host: a.com
    http:
      paths:
       - path: /
         pathType: Prefix
         backend:
           service:
             name: v2
             port:
               number: 80

---
kind: Service
apiVersion: v1
metadata:
  name:  v2
  namespace: test
spec:
  selector:
    name:  v2
  type:  ClusterIP
  ports:
  - name:  v2
    port:  80
    targetPort:  80
	
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name:  v2
  namespace: test
  labels:
    name:  v2
spec:
  selector:
    matchLabels:
      name: v2
  template:
    metadata:
      labels:
        name:  v2
    spec:
      containers:
      - image:  nginx:1.21
        name:  v2
        ports:
        - containerPort:  80
          name:  v2
        lifecycle:
          postStart:
            exec:
              command: [ "/bin/sh", "-c", "echo v2 > /usr/share/nginx/html/index.html" ]
```

***访问测试***
```bash

#头v2:xx时，只访问v2版本
$ for i in {1..20}; do curl -H "v2:xx" -s --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2

v1:0 v2:20(100%)

#不设置v2头，或值非xx时，按weight 30%访问
$ for i in {1..20}; do curl -s --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v1
v1
v1
v1
v1
v2
v1
v1
v1
v1
v2
v2
v1
v2
v2
v1
v1
v1
v1
v1

v1:15 v2:5(25%)

$ for i in {1..20}; do curl -H "v2:never" -s --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v1
v2
v1
v2
v2
v1
v2
v1
v2
v1
v1
v1
v1
v1
v2
v1
v1
v1
v1
v1

v1:14 v2:6(30%)

$ for i in {1..20}; do curl -H "v2:always" -s --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v1
v1
v1
v1
v1
v1
v1
v1
v1
v2
v2
v1
v1
v1
v1
v2
v1
v1
v2
v1

v1:16 v2:4(20%)

$  for i in {1..20}; do curl -H "v2:yy" -s --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v1
v1
v1
v1
v2
v1
v1
v1
v1
v1
v1
v1
v2
v1
v1
v1
v1
v1
v1
v1

v1:18 v2:2(10%)


```


# 基于cookie的流控
```yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "30"
	nginx.ingress.kubernetes.io/canary-by-header: "v2"
	nginx.ingress.kubernetes.io/canary-by-header-value: "xx"
	nginx.ingress.kubernetes.io/canary-by-cookie: "mycookie"
  labels:
    app: v2
  name: v2
  namespace: test
spec:
  rules:
  - host: a.com
    http:
      paths:
       - path: /
         pathType: Prefix
         backend:
           service:
             name: v2
             port:
               number: 80

---
kind: Service
apiVersion: v1
metadata:
  name:  v2
  namespace: test
spec:
  selector:
    name:  v2
  type:  ClusterIP
  ports:
  - name:  v2
    port:  80
    targetPort:  80
	
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name:  v2
  namespace: test
  labels:
    name:  v2
spec:
  selector:
    matchLabels:
      name: v2
  template:
    metadata:
      labels:
        name:  v2
    spec:
      containers:
      - image:  nginx:1.21
        name:  v2
        ports:
        - containerPort:  80
          name:  v2
        lifecycle:
          postStart:
            exec:
              command: [ "/bin/sh", "-c", "echo v2 > /usr/share/nginx/html/index.html" ]
```	  

***访问测试***

```bash
$ for i in {1..20}; do curl -s --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v1
v1
v1
v1
v1
v1
v2
v1
v1
v1
v1
v1
v1
v1
v1
v1
v2
v2
v2
v1

v1:16 v2:4(20%)

$ for i in {1..20}; do curl -s  --cookie "mycookie" --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v2
v1
v2
v1
v1
v1
v1
v1
v1
v1
v2
v1
v2
v1
v1
v1
v2
v2
v1
v1

v1:14 v2:6(30%)

$ for i in {1..20}; do curl -s  --cookie "mycookie=never" --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1
v1

v1:20 v2:0(0%)

$ for i in {1..20}; do curl -s  --cookie "mycookie=always" --resolve 'a.com:80:10.133.10.29' a.com;sleep 1; done|awk 'BEGIN{arr["v1"]=0; arr["v2"]=0;} {print $1;arr[$1]++; } END{print "v1:"arr["v1"],"v2:"arr["v2"]"("arr["v2"]/(arr["v1"]+arr["v2"])*100"%)";}'
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2
v2

v1:0 v2:20(100%)
```
