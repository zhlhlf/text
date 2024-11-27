#!/bin/sh

export RCLONE_CONFIG_PASS=$1
rm -rf rclone.conf ~/.config/rclone/
mkdir -p ~/.config/rclone/
wget -q https://raw.github.com/zhlhlf/text/main/upload/rclone.conf
curl -s https://rclone.org/install.sh | sudo bash > /dev/null 2>&1
mv -f rclone.conf ~/.config/rclone/rclone.conf
umount zhlhlf > /dev/null 2>&1
rm -rf zhlhlf
mkdir zhlhlf 
rclone mount onedrive:/$2 ./zhlhlf --umask 000 --daemon
echo "==============list==============="
du -h 666/*
echo
# rclone sync -P 666 onedrive:/$2 --quiet
rclone copy 666 zhlhlf/
echo
echo
echo "==============onedrive-list==============="
ls zhlhlf
