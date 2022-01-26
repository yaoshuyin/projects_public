## apply yaml
```bash
$ kubectl apply -f gfs.yaml
$ kubectl apply -f rbac.yaml 
$ kubectl apply -f config.yaml 
$ kubectl apply -f exporter.yaml 
$ kubectl apply -f prometheus.yaml 
$ kubectl apply -f grafana.yaml 

$ kubectl -n kube-system get pods
$ kubectl -n kube-system get services

$ cat >> /etc/hosts <<EOF
10.133.10.29 test-prom.a.com.cn
10.133.10.29 test-grafana.a.com.cn
EOF
```

## grafana
```
http://test-grafana.a.com.cn
.默认用户密码: admin  / admin
.添加prometheus源
  Add data source:
    Name: prometheus
    Type: Prometheus
    URL:  http://prometheus:9090
    Access: proxy
  Save&Test

.+
  import
    Grafana.com Dashboard
       315
    Load
```

## node_exporter
```bash
$ wget -c https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
$ tar xvf node_exporter-1.3.1.linux-amd64.tar.gz 
$ cd node_exporter-1.3.1.linux-amd64
$ mv node_exporter /usr/bin/
$ nohup node_exporter &
```

## alertmanager
```bash
$ wget -c https://github.com/prometheus/alertmanager/releases/download/v0.23.0/alertmanager-0.23.0.linux-amd64.tar.gz
$ wget -c https://hub.fastgit.org/prometheus/alertmanager/releases/download/v0.23.0/alertmanager-0.23.0.linux-amd64.tar.gz 
$ tar xvf alertmanager-0.23.0.linux-amd64.tar.gz 
$ mv alertmanager-0.23.0.linux-amd64 /usr/local/alertmanager
$ cat  > /usr/local/alertmanager/alertmanager.yml <<'EOF'
global:
  smtp_smarthost: '192.168.1.10:25'
  smtp_from: 'promalert@a.com.cn'
  smtp_auth_username: 'promalert'
  smtp_auth_password: '123456'
  smtp_require_tls: false
route:
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 1h
  #receiver: 'web.hook'
  receiver: 'mail'
receivers:
- name: 'mail'
  email_configs:
  - to: 'admin@a.com.cn'
- name: 'web.hook'
  webhook_configs:
  - url: 'http://127.0.0.1:5001/'
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']
EOF

$ nohup /usr/local/alertmanager/alertmanager --config.file=/usr/local/alertmanager/alertmanager.yml &
```
