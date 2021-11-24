**master**
```conf
global_defs {
   router_id LVS_DEVEL

   vrrp_skip_check_adv_addr
   #vrrp_strict  此项要禁止,否则在ubunt20.04上IP无法ping通
   vrrp_garp_interval 0
   vrrp_gna_interval 0

   script_user root
   enable_script_security
}

 vrrp_script chkscript {
    script "/usr/bin/nc -n -z 127.0.0.1 3306"
    interval 2
    weight -20
}

vrrp_instance VI_COMMON_MYSQL {
    state MASTER
    interface ens160
    virtual_router_id 22
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }

    track_script {
       chkscript
    }

    virtual_ipaddress {
        10.133.30.22/24 dev ens160 label ens160:0
    }
}
```

**slave**
```conf
global_defs {
   router_id LVS_DEVEL

   vrrp_skip_check_adv_addr
   #vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0

   script_user root
   enable_script_security
}

 vrrp_script chkscript {
    script "/usr/bin/nc -n -z 127.0.0.1 3306"
    interval 2
    weight -20
}

vrrp_instance VI_COMMON_MYSQL {
    state BACKUP
    interface ens160
    virtual_router_id 22
    priority 99
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }

     track_script {
       chkscript
    }

    virtual_ipaddress {
        10.133.30.22/24  dev ens160 label ens160:0
    }
}
```
