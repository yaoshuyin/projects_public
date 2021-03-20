***lnmp(docker-compose.yml)***

```
web_server:
    image: docker.io/openresty/openresty:1.11.2.2
    container_name: nginx
    links:
        - php:php
    ports:
        - "80:80"
        - "443:443"
    volumes:
        - /mnt/html:/usr/local/openresty/nginx/html

db_server:
    image: docker.io/mysql:5.7.21
    container_name: mysql
    environment:
        MYSQL_ROOT_PASSWORD: 123456
    ports:
        - "3306:3306"
    volumes:
        - /mnt/mysql:/var/lib/mysql

php:
    image: docker.io/php:7.2.3
    container_name: php
    links:
        - db_server:mysql
    ports:
        - "9000:9000"
    volumes:
        - /mnt/html:/usr/local/openresty/nginx/html
        - /mnt/php:/usr/local/etc/php
```

``
#启动
$ docker-compose up -d

#查看
$ docker-compose ps
```
