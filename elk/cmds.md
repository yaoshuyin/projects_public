```bash
.单节点需要配置 (否则索引状态为yellow)
PUT /_all/_settings
{ 
  "index" : {
    "number_of_replicas" : 0 
  }
}
```
