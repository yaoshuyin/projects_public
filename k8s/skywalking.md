**download image**
```
$ docker search skywalking-oap-server
$ wget -q https://registry.hub.docker.com/v1/repositories/apache/skywalking-oap-server/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}'
    ...
    8.6.0-es7     #使用8.6.0-es7
    8.7.0-es6
    8.7.0-es7     #有500错误，页面无法显示
    ...
```

**docker-compose**
```
$ cat docker-compose.yaml

version: '3'
services:
  oap:
    image: apache/skywalking-oap-server:8.6.0-es7
    container_name: oap
    restart: always
    ports:
      - 11800:11800   # agent 上报数据的端口，这是 gRPC 端口
      - 12800:12800   # ui    读取数据的端口， 这是 http 端口
  skywaling-ui:
    image: apache/skywalking-ui:8.6.0
    container_name: ui
    depends_on:
      - oap
    links:
      - oap
    ports:
      - 8088:8080
    environment:
      - SW_OAP_ADDRESS=oap:12800

$ docker-compose up -d
```

**skywalking-agent**
```
$ cd /data/docker/skywalking
$ wget -c https://archive.apache.org/dist/skywalking/8.7.0/apache-skywalking-apm-es7-8.7.0.tar.gz
$ tar xvf apache-skywalking-apm-es7-8.7.0.tar.gz
$ ls apache-skywalking-apm-bin-es7/agent/skywalking-agent.jar
```

**集成springboot**
```
$ agent=" -javaagent:/data/docker/skywalking/apache-skywalking-apm-bin-es7/agent/skywalking-agent.jar -Dskywalking.agent.service_name=srv-idc -Dskywalking.collector.backend_service=127.0.0.1:11800 "

$ java -Duser.timezone=GMT+8 -Dfile.encoding=utf-8 -Xms128m -Xmx256m $agent -jar target/springmvc-0.0.1-SNAPSHOT.jar --spring.profiles.active=sit --app.static.path=public --server.port=8080
```

**访问skywalking web界面**
```
$ http://127.0.0.1:8088
```
![图片](https://user-images.githubusercontent.com/16496322/151492213-18b222e3-f190-481a-a9f5-23987963baa0.png)
