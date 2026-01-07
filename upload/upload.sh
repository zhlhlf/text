#!/bin/sh
#by zhlhlf
#1 openlist_msg
#2 挂载路径
#3 需要上传的目录
#4 暂时使用的目录 一般无需更改


# 1 openlist_msg
# 2 远端openlist目录名
# 3 本地上传目录

a_host=`echo $1 | awk -F' ' '{print $1}'`
a_username=`echo $1 | awk -F' ' '{print $2}'`
a_password=`echo $1 | awk -F' ' '{print $3}'`

if [ "$2" ];then
    mount_dir=$2
else
    mount_dir=gg
fi
echo "mount_dir: $mount_dir"

if [ "$3" ];then
    in_dir=$3
else
    in_dir=666
fi

rm -rf local_file_list_sorted.txt current_file_list_sorted.txt openlist

command rclone >>/dev/null 2>&1 || curl -s https://rclone.org/install.sh | sudo bash > /dev/null 2>&1
pip install httpx >> null &
rm -rf openlist
mkdir openlist && cd openlist
curl -sL https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/get_openlist.sh | bash &
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/openlist_back_restore.py &
wget -q https://raw.githubusercontent.com/zhlhlf/text/refs/heads/main/upload/rclone.conf &
pkill openlist
wait
chmod 777 * -R
./openlist server > /dev/null 2>&1 &
python3 openlist_back_restore.py $a_host $a_username $a_password
python3 openlist_back_restore.py
cd ..
    

echo "==============upload-list==============="
echo -e "all_size: $(du -h $in_dir | awk '{print $1}' ) \n\n"
du -h $in_dir/*
echo
echo "start sync..."
echo
rclone copy $in_dir openlist:$mount_dir -P --transfers=16 --size-only --config ./openlist/rclone.conf > openlist/a.log
echo
echo "==============fail-list==============="
find "$in_dir" -type f | sed "s#^$in_dir/##" | sort > local_file_list_sorted.txt
rclone lsf openlist:/$mount_dir --files-only --recursive --config ./openlist/rclone.conf | sort > current_file_list_sorted.txt
list=""
while IFS= read -r i; do
    if ! grep -qF "$i" current_file_list_sorted.txt; then
        list+="$i\n"
    fi
done < local_file_list_sorted.txt
echo -e "$list"

rm -rf local_file_list_sorted.txt current_file_list_sorted.txt openlist
