#!/bin/sh

export RCLONE_CONFIG_PASS=$1
rm -rf rclone.conf
wget -q https://raw.github.com/zhlhlf/text/main/rclone.conf
curl -s https://rclone.org/install.sh | sudo bash > /dev/null 2>&1
rm -rf /home/runner/.config/rclone/
mkdir -p /home/runner/.config/rclone/
mv -f rclone.conf /home/runner/.config/rclone/rclone.conf
umount zhlhlf > /dev/null 2>&1
rm -rf zhlhlf
mkdir zhlhlf 
rclone mount onedrive:/$2 ./zhlhlf --umask 000 --daemon 
echo "==============list==============="
du -h 666/*
echo
rclone copy 666 zhlhlf/ 
echo
echo
echo "==============onedrive-list==============="
ls zhlhlf
