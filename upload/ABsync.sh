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
            cat openlist/a.log
            exit 1
        fi
        rclone mount openlist:/$1 ./$2 --umask 000 --daemon --config ./openlist/rclone.conf  >/dev/null 2>&1
        if [ "$(df -h $2 | grep openlist)" ]; then break; fi
        i=$((i + 1))
    done
    echo "mount $1 succeeded"
}

command rclone >>/dev/null 2>&1 || curl -s https://rclone.org/install.sh | sudo bash > /dev/null 2>&1
mkdir openlist && cd openlist
curl -sL https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/get_openlist.sh | bash
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/openlist_back_restore.py
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/rclone.conf
kill -8 `ps -A | grep openlist | awk -F' ' '{print $1}'` >/dev/null 2>&1
chmod 777 * -R
./openlist server > a.log 2>&1 &
pip install httpx >> null
python3 openlist_back_restore.py --host $a_host --username $a_username --password $a_password
python3 openlist_back_restore.py

cd ..

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
rclone copy $A $B -P --transfers=16 --size-only --config ./openlist/rclone.conf > a.log && kill -8 $pid
echo

kill -8 `ps -A | grep openlist | awk -F' ' '{print $1}'` >/dev/null 2>&1
rm -r openlist
