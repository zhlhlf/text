#!/bin/sh

#1 密码
#2 挂载路径
#3 需要上传的目录
#4 暂时使用的目录 一般无需更改
pass="$1"

if [ "$2" ];then
    mount_dir=$2
else
    mount_dir=5tb/临时存放文件
fi
echo "mount_dir: $mount_dir"

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

alist_data=https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/alist_data.zip


rm -rf rclone.conf ~/.config/rclone/
mkdir -p ~/.config/rclone/
command rclone >>/dev/null 2>&1 || curl -s https://rclone.org/install.sh | sudo bash > /dev/null 2>&1
rm -rf alist_data.zip alist
mkdir alist && cd alist
wget -q $alist_data -O alist_data.zip
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/alist
unzip -P $pass -qo alist_data.zip || (echo "pass fail" ; exit)
rm -r alist_data.zip
cp -r rclone.conf ~/.config/rclone/rclone.conf
kill -8 `ps -A | grep alist | awk -F' ' '{print $1}'` >/dev/null 2>&1
chmod 777 * -R
nohup ./alist server >>/dev/null 2>&1 &
cd ..
umount $current_dir > /dev/null 2>&1
rm -rf $current_dir
mkdir $current_dir 
chmod 777 $current_di
#curl 127.0.0.1:5244 > /dev/null 2>&1
i=0
while true;do
    sleep 3
    if [ "$i" == 6 ];then exit; fi
    rclone mount alist:/$mount_dir ./$current_dir --umask 000 --daemon >/dev/null 2>&1
    if [ "`df -h $current_dir | grep alist`" ];then break; fi
    i=$((i+1))
done

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

kill -8 `ps -A | grep alist | awk -F' ' '{print $1}'` >/dev/null 2>&1
rm -r alist
