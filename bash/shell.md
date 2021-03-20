```bash
/etc/profile

.ubuntu
/etc/bash.bashrc

/home/tom/.bashrc

/home/tom/.bash_logout
/home/tom/.bash_history

.centos
/etc/bashrc

/root/.bash_profile
/root/.bashrc

/root/.bash_history
/root/.bash_logout

.在当前shell执行
 source a.sh
 . a.sh

.screen
$ screen  -S MySessionName
$ ...
$ screen -list
$ screen -r 4568

.cat
cat </tmp/source.txt >/tmp/dest.txt
cat >/tmp/dest.txt <<EOF
..
EOF

cat <<EOF >/tmp/dest.txt
..
EOF

cat >/tmp/dest.txt <<-EOF
..
EOF

cat >/tmp/dest.txt <<'EOF'
..
EOF

.变量
$1 $2 .. ${10}
$0  脚本名
$*  所有的参数
$@  所有的参数
$#  参数的个数
$$  当前进程的PID
$!  上一个后台进程的PID
$?  上一个命令的返回值

.
$(( a + b ))
$(( a/b ))

i=1
while [ $i -le 5 ]
do
   ...
   let i++
   或
   ((i++))
done

.bc
$ echo 10.0/2 | bc
5

$ echo "scale=2;10.0/2" | bc
5.00

.string
str="www.sina.com.cn"
${#str}         字符串长度

#字符串以*.开, ^*.
${str#*.}       删除第一个.及之前的所有字符串
sina.com.cn

#字符串以*.开头, ^.*
${str##*.}      删除最后一个.及之前的所有字符串
cn

#字符串以.*结尾, .*$
${str%.*}       删除最后一个.及后的字符串
www.sina.com

#字符串以.*结尾, .*$
${str%%.*}      删除第一个.及之后字符串
www

.变量默认值
$ v=
$ echo ${v:=101}
  101
$ echo $v
  101

$ echo ${str/x/y}
$ echo ${str//x/y}
$ echo ${str/x}

if [[ "$num" =~ ^[0-9]+$ ]]
then
  echo ...
fi

[ -d /tmp -a -f /tmp/a ]
[[ -d /tmp && -f /tmp/a ]]

if [ $UID -eq 0 ]
if [ "$USER" = "root" ]

echo "....." |mail -s "title" a@a.com

"语法检查
bash -n a.sh
```









