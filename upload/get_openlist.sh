#!/bin/bash

# 2秒内访问谷歌，失败则使用代理
timeout 2 curl -s -I "https://www.google.com" > /dev/null 2>&1 || PROXY="https://ghfast.top/"

# 获取处理器架构
ARCH=$(uname -m | sed 's/x86_64/amd64/; s/aarch64/arm64/')

URL="${PROXY}https://github.com/zhlhlf/OpenList-private/releases/download/openlist_cc112cd/OpenList-private-linux-musl-${ARCH}"

rm -rf openlist
wget -q "$URL" -O openlist && chmod 777 openlist || echo "下载失败，请检查网络或稍后重试！"

