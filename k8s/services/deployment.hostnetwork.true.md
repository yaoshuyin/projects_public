```yaml
apiVersion: v1
kind: Namespace
metadata:
   name: test-sit
   labels:
     name: test-sit

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-test
  namespace: test-sit
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pod-test
  template:
    metadata:
      labels:
        app: pod-test
    spec:
      hostNetwork: true
      nodeSelector:
        test: "y"
      containers:
      - name: container-test
        image: x.x.x.x:5000/test/sit:17
        ports:
        - name: http
          containerPort: 8008
```
