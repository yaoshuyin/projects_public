```shell
yum install -y heketi heketi-client --skip-broken

ips=( 10.133.30.25 10.133.30.26 10.133.30.27 )

cat > /etc/heketi/topology.json <<EOF
{
    "clusters": [
        {
            "nodes": [
                {
                    "node": {
                        "hostnames": {
                            "manage": [
                                "ip01"
                            ],
                            "storage": [
                                "ip01"
                            ]
                        },
                        "zone": 1
                    },
                    "devices": [
                        "/dev/sdb"
                    ]
                },
                {
                    "node": {
                        "hostnames": {
                            "manage": [
                                "ip02"
                            ],
                            "storage": [
                                "ip02"
                            ]
                        },
                        "zone": 2
                    },
                    "devices": [
                        "/dev/sdb"
                    ]
                },
                {
                    "node": {
                        "hostnames": {
                            "manage": [
                                "ip03"
                            ],
                            "storage": [
                                "ip03"
                            ]
                        },
                        "zone": 3
                    },
                    "devices": [
                        "/dev/sdb"
                    ]
                }
            ]
        }
    ]
} 
EOF

sed -i "s/ip01/${ips[0]}}" /etc/heketi/topology.json
sed -i "s/ip02/${ips[1]}}" /etc/heketi/topology.json
sed -i "s/ip03/${ips[2]}}" /etc/heketi/topology.json


cat > /etc/heketi/heketi.json <<EOF
{
  "port": "8080",
  "use_auth": false,
  "jwt": {
    "admin": {
      "key": "admin"
    },
    "user": {
      "key": "user"
    }
  },
  "glusterfs": {
    "executor": "ssh",
    "sshexec": {
      "keyfile": "/etc/heketi/id_rsa",
      "user": "root",
      "port": "22",
      "fstab": "/etc/fstab"
    },
    "db": "/var/lib/heketi/heketi.db",
    "loglevel" : "debug"
  }
}
EOF

cp /root/.ssh/id_rsa /etc/heketi/
chown -R heketi:heketi /etc/heketi/id_rsa

systemctl start heketi

curl http://127.0.0.1:8080/hello

heketi-cli --server http://127.0.0.1:8080  topology load --json=/etc/heketi/topology.json

heketi-cli --server http://127.0.0.1:8080 cluster list

heketi-cli --server http://127.0.0.1:8080 cluster info 676d19ab882cd85b5b1a9e3425f323f7

heketi-cli --server http://127.0.0.1:8080 node list

#size默认为GB
heketi-cli --server http://127.0.0.1:8080 volume create --size=1 --replica=2
heketi-cli --server http://127.0.0.1:8080 volume list
heketi-cli --server http://127.0.0.1:8080 volume info 466d1ed914bb1317a1f57f53da0d8f44
gluster volume info


mkdir /tmp/xxx
mount -t glusterfs 127.0.0.1:/vol_466d1ed914bb1317a1f57f53da0d8f44 /tmp/xxx
```
