
```
!!! virtualbox enp0s3 桥接  混杂模式：全部允许 （否则外部无法ping myexternal-subnet的gateway IP,如192.168.101.201）


ovs-vsctl add-br br-ex2
iptables -t nat -A POSTROUTING -s 192.168.101.0/24 \! -d 192.168.101.0/24 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 \! -d 192.168.10.0/24 -j MASQUERADE

iptables -t nat -A POSTROUTING -s 10.0.2.0/24 \! -d 10.0.2.0/24 -j MASQUERADE


cp ifcfg-enp0s3 ifcfg-br-ex2
vi ifcfg-br-ex2
TYPE=OVSBridge
BOOTPRROTO=static
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
NAME=br-ex2
DEVICE=br-ex2
DEVICETYPE=ovs
ONBOOT=yes
IPADDR=192.168.101.30
NETMASK=255.255.255.0
GATEWAY=192.168.101.1
DNS=8.8.4.4


vi ifcfg-enp0s3
TYPE="OVSPort"
DEVICETYPE="ovs"
OVS_BRIDGE="br-ex2"
BOOTPRROTO=static
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
NAME=ens33
DEVICE=ens33
ONBOOT=yes


systemctl restart network

vim /etc/neutron/plugin.ini

type_drivers=vxlan,flat
flat_networks=*

systemctl restart neutron-server.service


vim /etc/neutron/l3_agent.ini
#external_network_bridge=
===>
external_network_bridge=br-ex2

systemctl restart neutron-l3-agent


vi /etc/neutron/plugins/ml2/openvswitch_agent.ini
bridge_mappings = physnet1:br-ex2

systemctl restart neutron-openvswitch-agent


cd ~
cat keystonerc_admin


Admin:
neutron net-create myexternal --provider:network_type flat --provider:physical_network physnet1 --router:external=True --shared

Admin Admin:
in network expolorer find "myexternal" and add Subnet

subnet name: myexternal-subnet
Network Address: 192.168.65.0/24
IP Version: IPv4
Gateway IP: 192.168.65.2

Next

   192.168.101.200,192.168.101.230
   8.8.4.4
   

Admin Project:

Network / networks / Create Network

myinternal

Next
  Subnet Name: myinternal-subnet
  Address: 192.168.30.0/24
  Version: IPv4
  GatewayIP: 192.168.30.1
  
Next
   Pools: 192.168.30.20,192.168.30.200
  DNS: 192.168.30.1
  

Router:
  Name: myrouter
  Enable Admin State
  External Network: myexternal
  Enable SNAT
  
  Nova
  


Click Router "myrouter" , press Interface tab and press "Add Interface“ button
  
   Subnet: myinternal: 192.168.30.0/24
 Submit
 

windows shang  ping : 192.168.101.201


Admin Project 
  计算 
     实例
	    创建实例
        绑定浮动IP

.vnc
vim /etc/nova/nova.conf

#vncserver_proxyclient_address=openstack.smartont.net
vncserver_proxyclient_address=192.168.10.10
```
