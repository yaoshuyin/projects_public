```bash
.单节点需要配置 (否则索引状态为yellow)
PUT /_all/_settings
{ 
  "index" : {
    "number_of_replicas" : 0 
  }
}

.默认每个Node节点的分片数是1000,满了就写不进日志了
PUT /_cluster/settings
{
   "persistent": {
      "cluster": {
         "max_shards_per_node":90000
      }
   }
}
```
