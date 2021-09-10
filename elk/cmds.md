```bash
.elasticsearch.yml
network.host: 192.168.100.100
http.port: 9200
discovery.seed_hosts: ["192.168.100.100"]

cluster.name: myelk
#和hostname一致,加hosts
node.name: myelk-node-1
cluster.initial_master_nodes: ["myelk-node-1"]

indices.fielddata.cache.size: 40%

xpack.security.enabled: false
xpack.security.transport.ssl.enabled: true
xpack.license.self_generated.type: basic

.启动
./bin/elasticsearch -d

.###设置密码
./bin/elasticsearch-setup-passwords interactive

.单节点需要配置 (否则索引状态为yellow)
PUT /_all/_settings
{ 
  "index" : {
    "number_of_replicas" : 0 
  }
}

.默认每个Node节点的分片数是1000,满了就写不进日志了 (persistent:永久有效 / transient：临时生效，集群重启就会失效)
PUT /_cluster/settings
{
   "persistent": {
      "cluster": {
         "max_shards_per_node":90000
      }
   }
}
```
