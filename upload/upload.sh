#!/bin/sh
#by zhlhlf
#1 openlist_msg
#2 挂载路径
#3 需要上传的目录
#4 暂时使用的目录 一般无需更改

a_host=`echo $1 | awk -F' ' '{print $1}'`
a_username=`echo $1 | awk -F' ' '{print $2}'`
a_password=`echo $1 | awk -F' ' '{print $3}'`

if [ "$2" ];then
    mount_dir=$2
else
    mount_dir=tyy/short_time_files
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
umount $current_dir > /dev/null 2>&1
rm -rf $current_dir
mkdir $current_dir 
chmod 777 $current_dir

mount_A_B $mount_dir $current_dir

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
echo -e "all_size: $(du -h $in_dir | awk '{print $1}' ) \n\n"
du -h $in_dir/*
echo
echo "start sync"
echo
rclone copy $in_dir $current_dir -P --transfers=16 --size-only --config ./openlist/rclone.conf > a.log && kill -8 $pid || ( cat openlist/a.log && cat a.log )
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
kill -8 `ps -A | grep openlist | awk -F' ' '{print $1}'` >/dev/null 2>&1
rm -r openlist
