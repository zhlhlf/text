#!/bin/bash

RELEASE_INFO=$(curl -s "https://api.github.com/repos/OpenListTeam/OpenList/releases/latest")

DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep "browser_download_url" | grep "linux-amd64.tar.gz" | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "未找到 linux-amd64 版本的下载链接。使用固定下载地址"
    DOWNLOAD_URL="https://github.com/OpenListTeam/OpenList/releases/download/v4.0.4/openlist-linux-amd64.tar.gz"
fi

#强制使用指定版本
DOWNLOAD_URL="https://github.com/zhlhlf/text/raw/refs/heads/main/upload/OpenList-linux-musl-amd64.tar.gz"

# 下载文件
DOWNLOAD_FILE="openlist_linux-amd64-musl.tar.gz"
curl -sL -o "$DOWNLOAD_FILE" "$DOWNLOAD_URL"

if [ $? -ne 0 ]; then
    echo "下载文件失败。"
    exit 1
fi

# 解压文件
TMP_DIR="tmp_openlist"
mkdir -p "$TMP_DIR"
tar -xzf "$DOWNLOAD_FILE" -C "$TMP_DIR"

if [ $? -ne 0 ]; then
    echo "解压文件失败。"
    rm -f "$DOWNLOAD_FILE"
    rm -rf "$TMP_DIR"
    exit 1
fi

# 重命名解压后的文件为 openlist
mv "$TMP_DIR"/* openlist

# 清理临时文件和目录
rm -f "$DOWNLOAD_FILE"
rm -rf "$TMP_DIR"

# echo "下载、解压和重命名完成，最新的 linux-amd64 版本已命名为 openlist。"
