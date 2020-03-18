1)  tcp.sh
#!/bin/bash
# date: 2018/04/28 21:10
# netstat -utnp | awk '{ array[$6]++} END{ for(i in array) {if(length(i)>0){ print i,array[i]}}}'

warn_conf_conns=200
warn_conf_conns_est=200
warn_conf_conns_twait=200 

warn_conf_clients=200
warn_conf_clients_est=200
warn_conf_clients_twait=200

netstat -utnp | awk -v conns=$warn_conf_conns -v est=$warn_conf_conns_est -v twait=$warn_conf_conns_twait  '{
     if(NR>2) { array[$6]++;}
  }

  END{
      for(i in array) {
         if(length(i)>0) {
            if(i ~ /EST/) {
                if(array[i]>est) {
                    print "\033[0;31mwarn:\033[0m  ",i," is ",array[i]," greater than ",est;
                } else {
                    print "\033[0;32minfo:\033[0m ",i," is ",array[i];
                }
            } else if(i ~ /TIME_WAIT/) {
                if(array[i]>twait) {
                    print "\033[0;31mwarn:\033[0m ",i," is ",array[i]," greater than ",twait;
                } else {
                    print "\033[0;32minfo:\033[0m ",i," is ",array[i];
                }
            } else {
                if(array[i]>conns) {
                    print "\033[0;31mwarn:\033[0m ",i," is ",array[i]," greater than ",conns;
                } else {
                    print "\033[0;32minfo:\033[0m ",i," is ",array[i];
                }
            }
         }
    }
}'

echo

netstat -tnp |awk '{
       if(NR>2) {
          gsub("::ffff:","",$5);
          gsub(":.*","",$5);
          array[$5,"_",$6]++;
       }
    }
   
    END {
      for( ip in array) {
         print ip, array[ip];
      }
}' | sort -n -k2,2 | awk -v clients=$warn_conf_clients -v est=$warn_conf_clients_est -v twait=$warn_conf_clients_twait '{
    gsub("_"," ",$1);
    if($2>10) {
        if($1 ~ "EST") {
            if($2>est){
               print "\033[0;31mwarn:\033[0m ",$1,"is ",$2," , greater than ",est;
            } else {
               print "\033[0;32minfo:\033[0m ",$1,"is ",$2;
            }
        } else if($1 ~ "TIME_WAIT") {
            if($2>twait) {
                print "\033[0;31mwarn:\033[0m ",$1,"is ",$2," , greater than ",twait;
            } else {
                print "\033[0;32minfo:\033[0m ",$1,"is ",$2;
            }
        } else {
            if($2>clients) {
                print "\033[0;31mwarn:\033[0m ",$1,"is ",$2," , greater than ",clients;
            } else {
                print "\033[0;32minfo:\033[0m ",$1,"is ",$2;
            }
        }
    }
}'


2) 测试
$ ./tcp.sh 
info:  ESTABLISHED  is  4
info:  FIN_WAIT2  is  1
warn:  TIME_WAIT  is  508  greater than  200

info:  192.168.1.45 TIME WAIT is  12
info:  192.168.2.45 TIME WAIT is  12
info:  127.0.0.1 TIME WAIT is  14
info:  192.168.1.81 TIME WAIT is  14
info:  192.168.2.81 TIME WAIT is  15
info:  192.168.1.80 TIME WAIT is  19
info:  6.26.17.4 TIME WAIT is  64
warn:  6.29.17.15 TIME WAIT is  299  , greater than  200