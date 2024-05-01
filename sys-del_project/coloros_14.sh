de(){
 
 oo=$(find */*app*/ -name $1)
 if [ ! "$oo" ];then
   oo=$(find */*/*app*/ -name $1)
 fi
 if [ "$oo" ];then
  echo "删除--- $oo \"$2\"" >> ../../../del_app-by-zhlhlf.txt
  echo "删除--- $oo \"$2\""
  rm -rf $oo
 fi

}

keep-del-app(){
echo "-------del-app------"
for i in $(find */*del-app*/* -maxdepth 0)
do
  uu=$(echo "$1" | grep -i $(basename $i))
  if [ "$uu" ];then
    echo "    保留--- $i"
  else
    rm -rf $i
    echo "删除--- $i"
    echo "删除--- $i" >> ../../../del_app-by-zhlhlf.txt
  fi
done

if [ -d "reserve" ];then
  echo "----存在reserve分区-----"
  for i in $(find reserve/*/*app*/* -maxdepth 0)
  do
   uu=$(echo "$1" | grep -i $(basename $i))
   if [ "$uu" ];then
   echo "    保留--- $i"
      name=$(basename $(ls $i))
      echo "name=\"$name\" info_1=\"0\" info_2=\"0\" location=\"del-app/$(basename $i)/$name\"" >> my_bigball/apkcerts.txt
      mv $i my_bigball/del-app/
    else
      rm -rf $i
      echo "删除--- $i"
      echo "删除--- $i" >> ../../../del_app-by-zhlhlf.txt
    fi
  done
fi

echo "-------del-app------"
}

del_key(){
   for i in "vendor/etc/fstab.qcom" "boot/ramdisk/fstab.qcom" "boot/ramdisk/oplus.fstab" "boot/ramdisk/system/etc/fstab.qcom" 
   do
    sed -i s#avb.*system,#""#g "$i"
    sed -i s#avb.*vendor,#""#g "$i"
    sed -i s#,fileencryption.*metadata_encryption#""#g "$i"
    sed -i s#,avb_keys.*pubkey#""#g "$i"
   done
}

del_key #去除data加密 avb验证等

keep-del-app "Clock FileManager KeKeThemeSpace"   #删除所有*/*del-app*/*  apps为要保留的

rm -rf */Omoji

de SupertextInput "扫描输入"
de PostmanService "诊断工具服务"
de CrashBox ""
de UMS "服务治理框架"
de SogouInput_U_Product "搜狗输入法"
de NetworkAssistSys "网络服务"
de CloudAccService "OPPO智慧云加速"
de TasWallet "系统卡包"
de MSPService "移动服务"
de ViewTalk "图片描述"
de OWork "随身工作台"
de TravelEngine "智慧出行"
de *SecurityKeyboard "安全键盘"
de WallpaperChooser "动态壁纸选择器"
de PhoneManager "手机管家"
de LinktoWindows "连接windows"
de ColorDirectService "识屏服务"
de ONet "增强服务里面的"
de COSA "应用增强服务 游戏模式相关"
de Omoji ""
de GameSpace "游戏空间"
de Music "音乐"
de Browser "浏览器"
de EasterEgg  "安卓彩蛋"
de KeKeAppDetail  "应用安装器  应用安装安全扫描"
de HTMLViewer ""
#de *ExServiceUI "手势体感服务  双击亮屏  "
#de *GestureUI "手势体感 双击亮屏"
de GmsCore "谷歌服务"
de HotwordEnrollmentOKGoogle ""
de HotwordEnrollmentXGoogle ""
de arcore ""
de GooglePlayServicesUpdater ""
de DiracAudioControlService ""
de com.qualcomm.location ""
de DownloadProvider "下载管理服务"
de PrintSpooler "打印处理服务"
de Stk "sim工具包"
de GoogleServicesFramework "谷歌服务框架"
#de NfcNci "nfc功能"
de ChildrenSpace "儿童空间"
de AssistantScreen "速览"
de DigitalWellBeing "应用使用时间"
de ColorDirectUI "小布识屏"
de FileEncryption ""
de BaiduInput_* "百度输入法"
de FloatAssistant "悬浮球 "
de OcrScanner "小布扫一扫"
de *TranslationService "翻译服务"
de BrowserVideo "视频"
de MDSService ""
de HeySynergy ""
de HeyCast ""
de Olc ""
de MyDevices "我的设备"
de SystemClone "系统分身"
de SOSHelper "紧急联络"
de SmartDrive "驾驶模式"
de OCar "车联"
de SceneService "数据服务平台"
de SceneMode "简易模式"
de RemoteGuardService "远程守护"
de OPSynergy ""
de *DCS ""
de *AccessoryFramework "设备快连"
de MyDevices "我的设备"
de HeyTapSpeechAssist "小布助手"
de BaiduInput_S_Product "百度输入法"
de ColorAccessibilityAssistant "语音转文字"
de OVoiceManagerServiceOnePlus "语音唤醒 "
de GoogleOneTimeInitializer "谷歌时间进程"
de KeKeMarket "软件商店"
de SystemHelper ""
de Traceur ""
de BuiltInPrintService ""
de *MultiApp "应用分身"
de OTA "软件更新"
de SafeCenter "安全中心"
de SystemAppUpdateService ""
de GlobalSearch "全局搜索"
de Instant "快应用"
de KeKePay "安全支付"
de SecurePay "安全支付"
de FinShellWallet "钱包"
de talkback "安卓无障碍套件"
de SecurityGuard "安全事件"
de *perationManual "使用说明"
#de MCS "系统消息"
de *WifiSecureDetect "wifi安全检测"
de FindMyPhone "查找手机 "
de FindMyPhoneClient2 "查找手机连接"
de CloudService "云服务 "
de ShareScreen "屏幕共享"
de OShare "一加互传"
de Calendar "日历"
de CalendarProvider "日历储存"
de *DCS ""
#de Aod "息屏 "
de Karaoke "耳机返听"
#de SmartSideBar "智能边框 "
de Portrait "人像绘影"
de Pictorial "乐划锁屏"
de RomUpdate "更新服务"
de DCS "用户体验计划"
de dmp "融合搜索服务"
de CodeBook "密码本"
de *WeatherService "天气服务"
de Olc ""
de UpgradeGuide "升级指南"
#de KeKeUserCenter "设置中用户中心 "
de *EngineerCamera "一加工程相机"
de *EngineerMode "工程模式"
de ADS "商业服务"
de IFlySpeechService "讯飞语音引擎"
de LogKit "反馈工具箱"
de BackupAndRestore "c11的手机搬家"
de iFlyIME "讯飞输入法"
de SogouInput_S_Product "搜狗输入法定制版"
#de *EyeProtect "护眼模式"

# 2024-3-29
de CarLink ""
de DigitalKeyFramework "数字车钥匙"
de HealthCheck "常规检测"
de BaiduInput* "百度输入"
de AIUnit "AIUnit"
de ColorfulEngine "多彩引擎"
de VariUIEngine "百变引擎"
de SmartLock "智能解锁"
de DeepThinker "智慧能力服务"
de HealthService "健康数据平台"
de VDCService "外设融合框架"
de SmartEngine "智能引擎？"
de Metis "智慧决策服务"
de OpenCapabilityService ""
de de VideoGallery "媒体播放器"


