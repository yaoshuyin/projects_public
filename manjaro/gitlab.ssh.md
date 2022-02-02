```bash
$ git clone ssh://git@192.168.1.1:22/yunwei/idc.git idc
 Unable to negotiate with 192.168.1.1 port 22: no matching host key type found. 
 Their offer: ssh-rsa,ssh-dss
 fatal: 无法读取远程仓库
 
$ vim ~/.ssh/config
Host 192.168.1.1
	 HostKeyAlgorithms +ssh-rsa
	 PubkeyAcceptedAlgorithms +ssh-rsa

$ git clone ssh://git@192.168.1.1/yunwei/idc.git idc
正克隆到 'idc'...
The authenticity of host '192.168.1.1 (192.168.1.1)' can't be established.
RSA key fingerprint is SHA256:f+zN+Nm3qJuBlK+EbA2PdWroyNGpKlOxO9XbjfZTeYk.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.1.1' (RSA) to the list of known hosts.
remote: Counting objects: 625, done.
remote: Compressing objects: 100% (21/21), done.
remote: Total 625 (delta 11), reused 0 (delta 0)
接收对象中: 100% (625/625), 404.75 KiB | 1.23 MiB/s, 完成.
处理 delta 中: 100% (270/270), 完成.
```
