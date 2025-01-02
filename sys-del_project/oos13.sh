


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
    if [ ! -f $i ];then
        continue
    fi
    echo "edit  $i ... "
    sed -i s#avb.*system,#""#g "$i"
    sed -i s#avb.*vendor,#""#g "$i"
    sed -i s#fileencryption.*quota#quota#g "$i"
    sed -i s#,avb_keys.*pubkey#""#g "$i"
   done
}


del_key #去除data加密 avb验证等

keep-del-app "Clock FileManager KeKeThemeSpace"   #删除所有*/*del-app*/*  apps为要保留的

del_key #去除data加密 avb验证等
rm -rf */*del-app*
rm -rf */Omoji
echo "ro.setupwizard.mode=DISABLED" >> system/system/build.prop #跳过谷歌向导
#rm -rf $(find ./ -name "SetupWizard") #删除后下拉 全面屏返回等出问题
de COSA #应用增强服务 #游戏模式相关
de LogKit #反馈工具箱
de Stk #sim卡工具包
de GlobalSearch "全局搜索"
de OplusCommercialEngineerCamera "工程相机"
de HTMLViewer 
de CalendarProvider "日历储存"
de OplusCommercialEngineerMode "工程模式"
de ChildrenSpace "儿童模式"
de LinktoWindows "连接windows"
de ColorDirectService "识屏服务"
de AssistantScreen
de CalendarGoogle
de CloudService
de Drive
de Google_AssistantShell
de Google_Lens
de Google_Pay3
de KeKePay
de LatinImeGoogle
de Meet
de Netflix_Activation_OnePlus
de Netflix_Stub
de Omoji
de Photos
de SoftsimRedteaRoaming
de Videos
de YTMusic
de INOnePlusStore
de NewSoundRecorder
de Google_Home
de Google_News
de Google_One
de Google_Podcasts
de Google_Files
de WellbeingPrebuilt
de RecorderPrebuilt
de PixelLiveWallpaperPrebuilt
de MarkupGoogle
de CalculatorGooglePrebuilt
de CalendarGooglePrebuilt
de DevicePolicyPrebuilt
de FilesPrebuilt
de GoogleRestorePrebuilt
de SafetyHubPrebuilt
de GmsCore
de PrebuiltGmsCore #删除后安装毒瘤qq出问题
de PartnerSetupPrebuilt
de ScribePrebuilt
de SecurityHubPrebuilt
de AndroidAutoStubPrebuilt
de LatinIMEGooglePrebuilt
de LocationHistoryPrebuilt
de DevicePersonalizationPrebuiltPixel2020
de Chrome
de Chrome-Stub
de GoogleTTS
de ChromePartnerProvider
de Gmail2
de GoogleLocationHistory
de GoogleServicesFramework
de Music
de Maps
de SpeechServicesByGoogle
de YouTube
de Melody
de AndroidAutoStub
de GoogleRestore
de Phonesky
de Velvet
de Wellbeing
de OppoWeather2
de OppoWeatherService
de BackupAndRestore
de OPBreathMode
de OPForum
de OPNote
de OPWidget
de Portrait
de Pictorial
de RomUpdate
de AccessoryFramework
de dmp
#de OCar
de CodeBook
de OplusOperationManual
de OppoWeatherService
de Olc
de UpgradeGuide
de KeKeUserCenter
de HeyCast
de OplusEngineerCamera
de OPSynergy
de ONet
de OTA
de OPScout
de talkback
de Account
de SystemAppUpdateService
de OPShelf
de Duo
de SOSHelper
de KeKeThemeSpace


de KeKeMarket "软件商店"
de OTA "软件更新"
de Browser "浏览器"
de Music "音乐"
de update
de LinktoWindows "连接windows"
de OTA "软件更新"
de *SecurityKeyboard "安全键盘"
de BrowserVideo "视频"
de SafeCenter "安全中心"

de VideoGallery "媒体播放器"
de AIUnit "AIUnit"
de KeKeAppDetail  "应用安装器  应用安装安全扫描"
de GlobalSearch "全局搜索"
de RomUpdate "更新服务"
de OTA "软件更新"

