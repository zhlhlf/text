de(){
 oo=$(find */*app*/* -iname $1  -maxdepth 0)
 if [ "$oo" == "" ];then
   oo=$(find */*/*app*/* -iname $1  -maxdepth 0)
 fi
 if [ "$oo" != "" ];then
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

keep-del-app "Clock FileManager KeKeThemeSpace"   #删除所有*/*del-app*/*  apps为要保留的

del_key #去除data加密 avb验证等
rm -rf */*del-app*
rm -rf */Omoji
echo "ro.setupwizard.mode=DISABLED" >> system/system/build.prop #跳过谷歌向导
#rm -rf $(find ./ -name "SetupWizard") #删除后下拉 全面屏返回等出问题

de update
de LinktoWindows "连接windows"
de *SecurityKeyboard "安全键盘"
de BrowserVideo "视频"

de GlobalSearch "全局搜索"
de RomUpdate "更新服务"
de OTA "软件更新"

del AssistantScreen
del CalendarGoogle
del CloudService
del Drive
del Google_AssistantShell
del Google_Lens
del Google_Pay3
del KeKePay
del LatinImeGoogle
del Meet
del Netflix_Activation_OnePlus
del Netflix_Stub
del Omoji
del Photos
del SoftsimRedteaRoaming
del Videos
del YTMusic
del Google_Home
del Google_News
del Google_One
del Google_Podcasts
del INOnePlusStore
del NewSoundRecorder
del AndroidSystemIntelligence_Features
del GlobalSearch
del Google_Files
del KeKeThemeSpace
del OPMemberShip
del PrivateComputeServices
del ARCore
del Chrome
del ChromePartnerProvider
del EmailPartnerProvider
del Gmail2
del GoogleLocationHistory
del MCS
del Maps
del Melody
del SpeechServicesByGoogle
del YouTube
del *GmsCore*
del GoogleOneTimeInitializer
del GoogleRestore
del Phonesky
del Velvet
del Wellbeing
del BackupAndRestore
del OPBreathMode
del OPForum
del OPWidget
del OppoNote2
del OppoRelax