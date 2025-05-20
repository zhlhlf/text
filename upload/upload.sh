#!/bin/sh

#1 密码
#2 挂载路径
#3 需要上传的目录
#4 暂时使用的目录 一般无需更改

pass="$1"
data_host="http://119.8.42.151:29155"

if [ "$2" ];then
    mount_dir=$2
else
    mount_dir=tyy2/short_time_files
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
./alist server > a.log 2>&1 &
cd ..
umount $current_dir > /dev/null 2>&1
rm -rf $current_dir
mkdir $current_dir 
chmod 777 $current_dir

i=0
while true;do
    sleep 1
    if [ "$i" == 60 ];then 
       cat alist/a.log
       exit 1
    fi
    rclone mount alist:/$mount_dir ./$current_dir --umask 000 --daemon >/dev/null 2>&1
    if [ "`df -h $current_dir | grep alist`" ];then break; fi
    i=$((i+1))
done

count=$(nproc --all)
asd(){
    while true;do
        sleep 6
        tail -n$count a.log
        echo
    done
}
# asd &
pid=$!

echo "==============upload-list==============="
du -h $in_dir/*
echo
echo "start sync"
echo
rclone copy $in_dir $current_dir -P --transfers=$count > a.log && kill -8 $pid
echo
echo "mount_dir: $mount_dir"
echo

echo "==============upload-list==============="
cd $in_dir
find -type f | sed 's#./##g' > ../input_file_list.txt
cd ..
cat input_file_list.txt
echo

echo "==============all-file-list==============="
cd $current_dir
find -type f | sed 's#./##g' > ../current_file_list.txt
cd ..
cat current_file_list.txt
echo

echo "==============fail-list==============="
list=""
while IFS= read -r i; do
    if ! grep -qF "$i" current_file_list.txt; then
        list+="$i\n"
    fi
done < input_file_list.txt
echo -e "$list"

rm -f input_file_list.txt current_file_list.txt
kill -8 `ps -A | grep alist | awk -F' ' '{print $1}'` >/dev/null 2>&1
rm -r alist
