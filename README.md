```

name: Action

on:
  watch:
    types: [started]
#  push:
#    branches: [ master ]
#  pull_request:
#    branches: [ master ]
   
env:
  WeTransfer: true

jobs:
    build:
      runs-on: ubuntu-20.04

      steps:
        - name: 获取本仓库源码
          uses: actions/checkout@main
  
        - name: 清理环境
          run: |
             curl -sL https://git.io/file-transfer | sh
             git clone https://github.com/chongshengB/rt-n56u 666
             zip -r 666.zip 666/trunk/configs
                               
        - name: 上传至WeTransfer
          if: env.WeTransfer == 'true'            
          run: |
             sudo ./transfer wet 666.zip
```
```
name: Action

on:
  watch:
    types: [started]
#  push:
#    branches: [ master ]
#  pull_request:
#    branches: [ master ]
   
env:
  WeTransfer: true

jobs:
    build:
      runs-on: ubuntu-20.04

      steps:
        - name: 获取本仓库源码
          uses: actions/checkout@main
  
        - name: 清理环境
          run: |
             curl -sL https://git.io/file-transfer | sh
             git clone https://github.com/coolsnowwolf/lede openwrt
             zip -r 666.zip openwrt/target/linux/ramips
   
        - name: 上传至WeTransfer
          if: env.WeTransfer == 'true'            
          run: |
             sudo ./transfer wet 666.zip
```
