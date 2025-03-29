#!/bin/sh

#1 密码
#2 被同步
#3 同步目录

pass=$1
A=$2
B=$3
data_host="http://119.8.42.151:29155"

A2=`echo "$A" | sed "s/\//\-/g"`
B2=`echo "$B" | sed "s/\//\-/g"`

umount $A2 > /dev/null 2>&1
umount $B2 > /dev/null 2>&1
rm -rf $A2 $B2
mkdir $A2 $B2

alist_data="$data_host/getAlistDataZip?key=$pass"

rm -rf rclone.conf ~/.config/rclone/
mkdir -p ~/.config/rclone/
command rclone >>/dev/null 2>&1 || curl -s https://rclone.org/install.sh | sudo bash > /dev/null 2>&1
rm -rf alist_data.zip alist
mkdir alist && cd alist
wget -q $alist_data -O alist_data.zip
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/alist
unzip -qo alist_data.zip || (echo "pass fail" ; exit)
rm -r alist_data.zip
cp -r rclone.conf ~/.config/rclone/rclone.conf
kill -8 `ps -A | grep alist | awk -F' ' '{print $1}'` >/dev/null 2>&1
chmod 777 * -R
nohup ./alist server >>/dev/null 2>&1 &
cd ..

#curl 127.0.0.1:5244 > /dev/null 2>&1
i=0
while true;do
    sleep 1
    if [ "$i" == 60 ];then exit; fi
    rclone mount alist:/$A ./$A2 --umask 000 --daemon >/dev/null 2>&1
    if [ "`df -h $current_dir | grep alist`" ];then break; fi
    i=$((i+1))
done

echo "mount $A succed"

i=0
while true;do
    sleep 1
    if [ "$i" == 60 ];then exit; fi
    rclone mount alist:/$B ./$B2 --umask 000 --daemon >/dev/null 2>&1
    if [ "`df -h $current_dir | grep alist`" ];then break; fi
    i=$((i+1))
done

count=$(nproc --all)
asd(){
    while true;do
        sleep 12
        tail -n$count a.log
        echo > a.log
        echo
    done
}
asd &
pid=$!
echo "start sync"
echo
rclone copy $A2 $B2 -P --transfers=$count > a.log && kill -8 $pid
echo

kill -8 `ps -A | grep alist | awk -F' ' '{print $1}'` >/dev/null 2>&1
rm -r alist
