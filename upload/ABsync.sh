#!/bin/sh

#1 密码
#2 被同步
#3 同步目录

pass=$1
A=$2
B=$3

umount $A > /dev/null 2>&1
umount $B > /dev/null 2>&1
rm -rf $A $B
mkdir $A $B

alist_data=https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/alist_data.zip


rm -rf rclone.conf ~/.config/rclone/
mkdir -p ~/.config/rclone/
command rclone >>/dev/null 2>&1 || curl -s https://rclone.org/install.sh | sudo bash > /dev/null 2>&1
rm -rf alist_data.zip alist
mkdir alist && cd alist
wget -q $alist_data -O alist_data.zip
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/alist
unzip -P $pass -qo alist_data.zip
rm -r alist_data.zip
cp -r rclone.conf ~/.config/rclone/rclone.conf
kill -8 `ps -A | grep alist | awk -F' ' '{print $1}'` >/dev/null 2>&1
chmod 777 * -R
nohup ./alist server >>/dev/null 2>&1 &
cd ..

#curl 127.0.0.1:5244 > /dev/null 2>&1
i=0
while true;do
    sleep 3
    if [ "$i" == 6 ];then exit; fi
    rclone mount alist:/$A ./$A --umask 000 --daemon >/dev/null 2>&1
    if [ "`df -h $current_dir | grep alist`" ];then break; fi
    i=$((i+1))
done

i=0
while true;do
    if [ "$i" == 4 ];then exit; fi
    rclone mount alist:/$B ./$B --umask 000 --daemon >/dev/null 2>&1
    if [ "`df -h $current_dir | grep alist`" ];then break; fi
    i=$((i+1))
    sleep 3
done

asd(){
    while true; do
        echo > a.log
        sleep 3
        tail -n$(nproc --all) a.log
        echo -e "\n"
        sleep 10
    done
}

echo "mount yes    start sync"
asd &
pid=$!

rclone copy $A $B --progress --transfers=$(nproc --all) > a.log && kill -8 $pid

kill -8 `ps -A | grep alist | awk -F' ' '{print $1}'` >/dev/null 2>&1
