name: Action

on:
  watch:
    types: [started]
#  push:
#    branches: [ master ]
#  pull_request:
#    branches: [ master ]
   
env:
  ssh: true
  WeTransfer: true



jobs:
    build:
      runs-on: ubuntu-20.04

      steps:
        - name: 获取本仓库源码
          uses: actions/checkout@main
  
        - name: 高端操作
          run: |
             git clone https://github.com/hanwckf/rt-n56u 
             zip 666.zip rt-n56u/trunk/configs

        - name: ssh连接
          if: env.ssh == 'true'            
          uses: P3TERX/ssh2actions@v1.0.0
          env:
            TELEGRAM_CHAT_ID: ${{ secrets.TELEGRAM_CHAT_ID }}
            TELEGRAM_BOT_TOKEN: ${{ secrets.TELEGRAM_BOT_TOKEN }}      
                              
        - name: 上传至WeTransfer
          if: env.WeTransfer == 'true'            
          run: |
             sudo ./transfer wet 666.zip
