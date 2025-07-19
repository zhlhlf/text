#!/bin/sh

export RCLONE_CONFIG_PASS=$1

if [ "$2" ];then
    mount_dir=$2
else
    mount_dir=临时存放文件
fi

if [ "$3" ];then
    in_dir=$3
else
    in_dir=666
fi

if [ "$4" ];then
    current_dir=$4
else
    current_dir=zhlhlf
fi

echo "mount_dir: $mount_dir"

rm -rf rclone.conf ~/.config/rclone/
mkdir -p ~/.config/rclone/
wget -q https://raw.github.com/zhlhlf/text/main/upload/rclone.conf
curl -s https://rclone.org/install.sh | sudo bash > /dev/null 2>&1
mv -f rclone.conf ~/.config/rclone/rclone.conf

umount $current_dir > /dev/null 2>&1
rm -rf $current_dir
mkdir $current_dir 
chmod 777 $current_dir

rclone mount onedrive:/$mount_dir ./$current_dir --umask 000 --daemon >/dev/null 2>&1

count=$(nproc --all)
asd(){
    while true;do
        sleep 6
        tail -n$count a.log
        echo > a.log
    done
}
asd &
pid=$!

echo "==============list==============="
du -h $in_dir/*
echo
echo "start sync"
echo
rclone copy $in_dir $current_dir -P --transfers=$count > a.log && kill -8 $pid
echo
echo
echo "==============all-file-list==============="
ls $current_dir
umount $current_dir
