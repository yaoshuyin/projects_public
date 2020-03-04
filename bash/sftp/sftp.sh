#!/bin/bash
# Func: sftp account create
# Date: 20191107 / 20191016 / 20200207
# mount bind 
#   mount --bind /backup/sftp /sftp
#   /backup/sftp /sftp xfs  defaults,rbind 0 0

if [ $(whoami) != "root" ]
then
   echo "Run as root, or use sudo please"
fi

if [ $# -ne 1 -a $# -ne 2 -a $# -ne 3 -a $# -ne 4 ] 
then
   cat <<_EOF_
Usage $0 <username>  [group] [root_path] [datadir1,datadir2,datadir3]
      $0 tom
      $0 tom  sftp
      $0 tom  sftp  /datafile/sftp
      $0 tom  sftp  /datafile/sftp "in,out,img"

      SSH_MODE=user && $0 tom
      SSH_MODE=user && $0 tom  sftp
      SSH_MODE=user && $0 tom  sftp  /datafile/sftp
      SSH_MODE=user && $0 tom  sftp  /datafile/sftp "in,out,img"

      SSH_MODE=group && $0 tom
      SSH_MODE=group && $0 tom  sftp
      SSH_MODE=group && $0 tom  sftp  /datafile/sftp
      SSH_MODE=group && $0 tom  sftp  /datafile/sftp "in,out,img"
_EOF_
   exit
fi

user=$1
group=${2:-sftp}
root=${3:-/datafile/sftp}
mode=${SSH_MODE:-group}   # default user or group
datadir=${4:-in,out,img}

sed -i 's!^Subsystem\s\+sftp\s\+/usr/\(lib\|libexec\)/openssh/sftp-server!#Subsystem sftp /usr/\1/openssh/sftp-server!g' /etc/ssh/sshd_config

grep -e '^Subsystem\s\+sftp\s\+internal-sftp' /etc/ssh/sshd_config || sed -i '/Subsystem\s\+sftp/aSubsystem sftp internal-sftp' /etc/ssh/sshd_config

function add() {
  path=$root/$user
  grep -w $group /etc/group || groupadd $group 
 
  [ -d $root ] || mkdir -p $root 
 
  useradd -m -g $group -d $path -c "sftp only" -s /usr/sbin/nologin $user
  chmod 755 $path
 
  chown root:root $path
 
  mkdir -p $path/.ssh
  chown -R $user:$group $path/.ssh

  IFS_OLD=$IFS
  IFS=,
  for ddir in ${datadir[@]}
  do
     mkdir -p $path/$ddir
     chown -R $user:$group $path/$ddir
  done
  IFS=$IFS_OLD

  #chown webapp:$group $path/in
}

function cfg() { 
  if [ $mode = "group" ]
  then
     match="group $group"
  else
     match="user $user"
  fi

  echo $match

  if ! egrep "^Match ${match}" /etc/ssh/sshd_config 
  then
     cat >> /etc/ssh/sshd_config <<_EOF_

Match $match
   ChrootDirectory $root/%u
   ForceCommand internal-sftp
_EOF_

   grep 'ID="centos"' ||  /usr/bin/systemctl reload sshd
   grep 'ID="ubuntu"' ||  /bin/systemctl reload ssh
fi
}

function key(){
   ssh-keygen -t rsa  -f $path/.ssh/id_rsa && \
   cat $path/.ssh/id_rsa.pub >> $path/.ssh/authorized_keys && \
   chmod -R 600 $path/.ssh/{authorized_keys,id_rsa,id_rsa.pub} && \
   chown -R $user:$group $path/.ssh && cat $path/.ssh/id_rsa
}

add && cfg && key
