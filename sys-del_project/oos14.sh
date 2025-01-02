


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

de AIUnit
de Aod "息屏显示"
de ChildrenSpace "儿童空间"
de FloatAssistant "悬浮球"
de HealthCheck
de Portrait "人像绘影"
de COSA "应用增强服务"
de OplusOperationManual "帮助与反馈"
de SceneMode "简易模式"
de HeyCast "手机投屏"
de OPSynergy "设备互联服务"

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
de Google_Home
de Google_News
de Google_One
de Google_Podcasts
de INOnePlusStore
de NewSoundRecorder
de AndroidSystemIntelligence_Features
de GlobalSearch
de Google_Files
de KeKeThemeSpace
de OPMemberShip
de PrivateComputeServices
de ARCore
de Chrome
de ChromePartnerProvider
de EmailPartnerProvider
de Gmail2
de GoogleLocationHistory
de MCS
de Maps
de Melody
de SpeechServicesByGoogle
de YouTube
de *GmsCore*
de GoogleOneTimeInitializer
de GoogleRestore
de Phonesky
de Velvet
de Wellbeing
de BackupAndRestore
de OPBreathMode
de OPForum
de OPWidget
de OppoNote2
de OppoRelax

de ColorDirectService
de *Weather*
de ViewTalk
de AccessoryFramework
de KeKeUserCenter
de GoogleServicesFramework
de Olc
de PostmanService
de HealthConnectControllerGoogle*
de AdServicesApkGoogle*
de NetworkAssistSys
de CalendarProvider
de *EngineerCamera
de BuiltInPrintService
