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

del_key(){
   for i in "vendor/etc/fstab.qcom" "boot/ramdisk/fstab.qcom" "boot/ramdisk/oplus.fstab" "boot/ramdisk/system/etc/fstab.qcom" 
   do
    if [ ! -f $i ];then
        continue
    fi
    echo "edit  $i ... "
    sed -i s#avb.*system,#""#g "$i"
    sed -i s#avb.*vendor,#""#g "$i"
    sed -i s#,fileencryption.*metadata_encryption#""#g "$i"
    sed -i s#,avb_keys.*pubkey#""#g "$i"
   done
}


del_key #去除data加密 avb验证等

keep-del-app "Clock FileManager KeKeThemeSpace"   #删除所有*/*del-app*/*  apps为要保留的

de KeKeMarket "软件商店"
de OTA "软件更新"
de Browser "浏览器"
de Music "音乐"
de update
de LinktoWindows "连接windows"
de OTA "软件更新"
de BrowserVideo "视频"
de SafeCenter "安全中心"

de VideoGallery "媒体播放器"
de AIUnit "AIUnit"
de KeKeAppDetail  "应用安装器  应用安装安全扫描"
de GlobalSearch "全局搜索"
de RomUpdate "更新服务"
de OTA "软件更新"