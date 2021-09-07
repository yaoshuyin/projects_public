```yaml
apiVersion: v1
kind: Namespace
metadata:
   name: sit-store-ui
   labels:
     name: sit-store-ui

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sit-store-ui
  namespace: sit-store-ui
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sit-store-ui
  template:
    metadata:
      labels:
        app: sit-store-ui
    spec:
      nodeSelector:
        esign: "y"
      containers:
      - name: sit-store-ui
        image: x.x.x.x:5000/sit-store-ui:67
        ports:
        - name: http
          containerPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: sit-store-ui
  namespace: sit-store-ui
spec:
  selector:
    app: sit-store-ui
  ports:
  - name: http
    targetPort: 80
    port: 80

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sit-store-ui
  namespace: sit-store-ui
  annotations:
    kubernetes.io/ingess.class: "nginx"
    nginx.ingress.kubernetes.io/rewrite-target: /
    ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - host: sit-store-ui.a.com
    http:
       paths:
       - path: /
         pathType: Prefix
         backend:
           service:
             name: sit-store-ui
             port:
               number: 80
```
