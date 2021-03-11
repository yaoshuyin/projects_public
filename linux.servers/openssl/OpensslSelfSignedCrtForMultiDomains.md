****
```console
#!/bin/bash
#Script: OpensslSelfSignedCrtForMultiDomains.sh 
#Author: cnscn
#Date: 2021-03-11
#Usage: ./OpensslSelfSignedCrtForMultiDomains.sh

#.................config................
domain=a.com
domains=( "a.com" "*.a.com" "*.app.a.com" "*.b.com" )

C=CN
ST=SH
L=PuDong
O=JinJiaGongSi
OU=ITDept
email=a@a.com
ca=MySelfCA
#................~config................

#............ no need change ...........
cat <<EOF >openssl.cnf
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
countryName = $C 
stateOrProvinceName = $ST 
localityName = $L
organizationalUnitName = $OU
commonName = $domain

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
EOF

i=1
for d in ${domains[@]}
do
  echo "DNS.$i = $d" >> openssl.cnf
  ((i++))
done

#..........CA...........
openssl genrsa -out ${domain}-ca.key 4096
openssl req -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$ca/emailAddress=$email" -new -x509 -days 3650 -key ${domain}-ca.key -out ${domain}-ca.crt

#.........CRT............
openssl genrsa -out ${domain}.key 4096


openssl req -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$domain/emailAddress=$email" -new -key ${domain}.key -out ${domain}.csr -config openssl.cnf

#用CA证书给server.csr进行签名
openssl x509 -req -days 3650 -in ${domain}.csr -CA ${domain}-ca.crt -CAkey ${domain}-ca.key -set_serial 01 -out $domain.crt -extensions v3_req -extfile openssl.cnf
#............ ~no need change ...........
```

**查看证书**
```console
$ ls 
  a.com-ca.crt a.com-ca.key a.com.crt a.com.key

$ openssl x509 -in a.com.crt -text -noout
  ...
    DNS:a.com, DNS:*.a.com, DNS:*.app.a.com, DNS:*.b.com
  ...
```

**Nginx配置**
```console
$ vim nginx.conf
http {
  server {
    listen      443 ssl http2 default_server;
    server_name a.com www.a.com b.com www.b.com c.com www.c.com;

    root        /usr/share/nginx/html;

    ssl_certificate "ssl/a.com.crt";
    ssl_certificate_key "ssl/a.com.key";
    ssl_session_cache shared:SSL:1m;
    ssl_session_timeout  10m;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
    }
  }
}

$ systemctl restart nginx
```

**加hosts**
```
172.18.0.8 a.com www.a.com b.com www.b.com
```

**测试**
```console
$ curl  https://a.com
Error: Peer's Certificate issuer is not recognized... specify an alternate file using the --cacert option....

$ curl --cacert a.com-ca.crt https://a.com
  welcome to nginx...

$ curl --cacert a.com-ca.crt https://c.com
curl: (51) Unable to communicate securely with peer: requested domain name does not match the server's certificate.
```

**firefox 导入ca证书**
```
右上角“三” 
 --> 首选项
 --> 隐私与安全
 --> 证书
 --> 查看证书
 --> 证书颁发机构
 --> 导入...
       选择 a.com-ca.crt
       !!! 勾选 ..信任 !!!
```
