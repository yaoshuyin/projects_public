```bash
export http_proxy="http://127.0.0.1:8889"
export https_proxy="http://127.0.0.1:8889"
export no_proxy=localhost,127.0.01,10.0.0.0/8,192.168.0.0/16,172.17.0.0/16,172.16.0.0/16

$ yay -S minikube kubectl
$  minikube start --image-mirror-country='cn'

$ yay -S python3
$ yay -S python-pip
$ pip3 install neovim
$ curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$ sudo perl -MCPAN -e shell
$  wget https://rubygems.org/rubygems/rubygems-3.3.6.tgz
$ tar xvf rubygems-3.3.6.tgz 
$ cd rubygems-3.3.6
$ ruby setup.rb 
$ gem update --system
$ gem install neovim
$ echo 'export PATH=$PATH:/home/tom/.local/share/gem/ruby/3.0.0/bin' >> ~/.bashrc
$ sudo chmod 777 /usr/bin
$ nvim 
 :healthcheck
$ sudo chmod 755 /usr/bin
$ sudo pacman -S xclip
$ cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
 
$ kubectl get svc  -A
NS             NAME             TYPE        CLUSTER-IP  EXTERNAL-IP   PORT(S)  
default   kubernetes      ClusterIP   10.96.0.1      <none>               443/TCP 
idc            jenkins             ClusterIP   10.97.19.155   <none>              80/TCP
ingress-nginx   ingress-nginx-controller   NodePort  10.97.2.213       80:30348/TCP,443:30808/TCP
ingress-nginx   ingress-nginx-controller-admission   ClusterIP   10.103.56.31      443/TCP
kube-system     kube-dns   ClusterIP   10.96.0.10   53/UDP,53/TCP,9153/TCP

$ minikube -n ingress-nginx service   ingress-nginx-controller  --url
http://192.168.49.2:30348
http://192.168.49.2:30808

$ sudo echo '192.168.49.2 jenkins.a.com' >> /etc/hosts

$ http://jenkins.a.com
```
