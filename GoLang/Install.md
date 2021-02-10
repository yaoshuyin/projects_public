**install**
```bash
$ wget https://golang.google.cn/dl/go1.15.8.linux-amd64.tar.g 
$ tar -C /usr/local/ -xvf go1.15.8.linux-amd64.tar.gz 
$ grep -R 'GOPATH' /etc/profile || echo -e 'export GOPATH=/root/go\nexport PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /etc/profile
$ . /etc/profile
```
