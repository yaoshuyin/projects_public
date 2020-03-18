#!/bin/bash
#
# Script: aptfastermirror.sh
#
# Usage: ./aptfastermirror.sh 
#        ./aptfastermirror.sh http://archive.ubuntu.com/ubuntu/
#        ./aptfastermirror.sh http://mirror01.idc.hinet.net/ubuntu/
#

function getfaster()
{
    for mirror in $(wget http://mirrors.ubuntu.com/mirrors.txt -O - 2> /dev/null)
    do 
        (
            host=$(echo $mirror |sed s,.*//,,|sed s,/.*,,)
            echo -e $(ping $host -c1 | grep time=|sed -e 's/.*time=//' -e 's/ ms/ms/')','$mirror
        ) &
    done
    wait

}

function applysource() 
{
    OLD_SOURCE=$(cat /etc/apt/sources.list | grep ^deb\ | head -n1 | cut -d\  -f2)
    
    [ -e  /etc/apt/sources.list.orig ] || cp /etc/apt/sources.list /etc/apt/sources.list.orig
    
    cp /etc/apt/sources.list /etc/apt/sources.list.tmp
    sed "s,$OLD_SOURCE,$1," < /etc/apt/sources.list.tmp > /etc/apt/sources.list
    [ $? -eq 0 ] && echo "apt source has been changed, then run  apt update and apt upgrade and apt autoremove"
}

if [ -z "$1" ]
then
   select mirror in $(getfaster | grep ms | sort -n) :
   do
       IFS=, read time url <<< $mirror
       [ -z $url ] || applysource $url
       exit
   done
else
   applysource "$1"
fi
