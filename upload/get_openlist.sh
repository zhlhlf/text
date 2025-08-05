#!/bin/bash

RELEASE_INFO=$(curl -s "https://api.github.com/repos/zhlhlf/OpenList/releases/latest")

DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep "browser_download_url" | grep "linux-musl-amd64" | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "未找到 linux-musl-amd64 版本的下载链接。使用固定下载地址"
    DOWNLOAD_URL="https://github.com/zhlhlf/OpenList/releases/download/openlist_425fed6/OpenList-linux-musl-amd64"
fi

# 删除openlist
rm -rf openlist

# 下载文件
wget -q "$DOWNLOAD_URL" -O openlist

chmod 777 openlist

if [ $? -ne 0 ]; then
    echo "下载文件失败。"
    exit 1
fi

