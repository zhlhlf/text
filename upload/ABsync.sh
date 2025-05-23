#!/bin/sh

#1 密码
#2 被同步
#3 同步目录

a_host=`echo $1 | awk -F' ' '{print $1}'`
a_username=`echo $1 | awk -F' ' '{print $2}'`
a_password=`echo $1 | awk -F' ' '{print $3}'`

A=$2
B=$3


A2=`echo "$A" | sed "s/\//\-/g"`
B2=`echo "$B" | sed "s/\//\-/g"`

umount $A2 > /dev/null 2>&1
umount $B2 > /dev/null 2>&1
rm -rf $A2 $B2
mkdir $A2 $B2

mount_A_B() {
    echo "start mount $1 to $2"
    i=0
    while true; do
        sleep 1
        if [ "$i" == 60 ]; then
            cat alist/a.log
            exit 1
        fi
        rclone mount alist:/$1 ./$2 --umask 000 --daemon --config ./alist/rclone.conf  >/dev/null 2>&1
        if [ "$(df -h $2 | grep alist)" ]; then break; fi
        i=$((i + 1))
    done
    echo "mount $1 succeeded"
}

command rclone >>/dev/null 2>&1 || curl -s https://rclone.org/install.sh | sudo bash > /dev/null 2>&1
mkdir alist && cd alist
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/alist
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/alist_back_restore.py
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/rclone.conf
kill -8 `ps -A | grep alist | awk -F' ' '{print $1}'` >/dev/null 2>&1
chmod 777 * -R
./alist server > a.log 2>&1 &
pip install tabulate httpx >> null
python3 alist_back_restore.py --host $a_host --username $a_username --password $a_password
python3 alist_back_restore.py

cd ..

mount_A_B $A $A2

mount_A_B $B $B2

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
rclone copy $A2 $B2 -P --transfers=$count --config ./alist/rclone.conf > a.log && kill -8 $pid
echo

kill -8 `ps -A | grep alist | awk -F' ' '{print $1}'` >/dev/null 2>&1
rm -r alist
