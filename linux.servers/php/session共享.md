**Memcached存放Session**
```
1)修改php.ini：

session.save_handler = memcache

session.save_path = "tcp://192.168.56.11:11211"

2)PHP安装memcache插件

```

**使用Redis存储Session**
```
1)修改php.ini：
session.save_handler = redis
session.save_path ="tcp://localhost:6379"

2)PHP安装Redis插件
```
