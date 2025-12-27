#!/bin/sh

#1 密码
#2 get同步
#3 put目录
#4 同步线程数

a_host=`echo $1 | awk -F' ' '{print $1}'`
a_username=`echo $1 | awk -F' ' '{print $2}'`
a_password=`echo $1 | awk -F' ' '{print $3}'`

A=$2
B=$3

if [ "$4" ];then
    transfers=$4
else
    transfers=$(nproc)
fi

command rclone >>/dev/null 2>&1 || curl -s https://rclone.org/install.sh | sudo bash > /dev/null 2>&1
pip install httpx >> null &
mkdir openlist && cd openlist
curl -sL https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/get_openlist.sh | bash
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/openlist_back_restore.py
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/rclone.conf
pkill openlist
chmod 777 * -R
wait
./openlist server 2>&1 &
python3 openlist_back_restore.py $a_host $a_username $a_password
python3 openlist_back_restore.py

cd ..

echo "start sync"
echo
if [ "$4" = "1" ];then
    rclone move "openlist:/$A" "openlist:/$B" -P --transfers=$transfers --size-only --config ./openlist/rclone.conf
else
    rclone copy "openlist:/$A" "openlist:/$B" -P --transfers=$transfers --size-only --config ./openlist/rclone.conf
fi
echo

kill -8 `ps -A | grep openlist | awk -F' ' '{print $1}'` >/dev/null 2>&1
rm -r openlist
