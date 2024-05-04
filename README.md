```
echo "AB------------------------";
url="" ;
fw="" ;
name="";
name="$name-$(date +%Y-%m-%d-%H)";
flash_scripts="http://47.115.224.103:5244/d/5gb-my/%E4%B8%80%E5%8A%A09r/ab_flash_scripts.7z";
image="boot.img dtbo.img odm.img product.img system*.img  vbmeta*.img  vendor.img my_*.img reserve.img";
aria2c -x10 "$url" -o ttt/rom.zip ; unzip ttt/rom.zip ; wget https://github.com/zhlhlf/text/raw/main/payload-dumper-go ; chmod 777 payload-dumper-go ; aria2c -x10 "${flash_scripts}" -o shelll.7z ; 7z x shelll.7z ; rm -rf shelll.7z ; mv ab_flash_scripts ${name} ; mkdir ${name}/images ; ./payload-dumper-go -o limages payload.bin >/dev/null ; rm -rf ttt ; rm -rf payload.bin ; for i in $image ; do mv limages/$i ${name}/images/ || echo "没有$i" ; done ; rm -rf limages ; aria2c -x10 "$fw" -o zzzz.zip ; unzip zzzz.zip -d ${name} ; rm -rf zzzz.zip ; 

cd ${name} ; rm -rf images/vbmeta.img images/reserve.img ; mv vbmeta.img images ; zip -r ${name}.zip * ; mv ${name}.zip ../ ; cd ../ ; rm -rf ${name} ; rm -rf 666 ; mkdir 666 ; mv ${name}.zip 666 ; wget https://raw.github.com/zhlhlf/text/main/onedrive_mount.sh ; sh onedrive_mount.sh $RCK 临时存放文件 ;

```
```
echo "阉割脚本-------------------" ; name="del_$name" ; repacktools="https://raw.githubusercontent.com/zhlhlf/text/main/sys-del_project/repacktools.zip";    rms="https://raw.githubusercontent.com/zhlhlf/text/main/sys-del_project/nameless.sh";    cd $name/images ; mkdir work ; cd work ; mkdir project ; yy="boot.img my_*.img system*.img vendor.img product.img reserve.img" ; for i in $yy ; do mv ../$i ./project || echo "没有$i" ; done ; aria2c -x10 "$repacktools" -o repacktools.zip  ; unzip -qo repacktools.zip ; rm -rf repacktools.zip ; chmod 777 * ; sudo bash un.sh ; cd project ;  curl -sL $rms | sudo bash ; ls */*app* ; rm -rf *.img ; cd ../ ; sudo bash re.sh ; sudo mv project/out/* ../ ; cd ../ ; sudo rm -rf work ; cd ../../ ;
```
```
echo "A only------------------------";
url="" ; 
name="" ; 
name="$name-$(date +%Y-%m-%d-%H)";
fs="http://47.115.224.103:5244/d/5gb-my/%E4%B8%80%E5%8A%A09r/A_flash_scripts.7z";
aria2c -x10 "$fs" -o fs.7z ; 7z x fs.7z; mv A_flash_scripts $name ; rm -rf fs.7z ; 
aria2c -x10 "$url" -o works/rom.zip ; cd works ; wget https://github.com/zhlhlf/text/raw/main/sys-del_project/repacktools.zip ; unzip repacktools.zip ; chmod 777 * -R ; export PATH=${pwd}:${PATH} ; unzip rom.zip ; rm -rf rom.zip ; for i in $(ls *.zip || echo "no") ; do unzip -n $i || echo "no" ; done ;
ls ; echo "\n" ; BR=$(ls *.br) ; for i in $BR ; do line=$(basename $i .new.dat.br) ; echo "> 正在分解：${line}.new.dat.br" ; brotli -d $i ; rm -r $i ; if [ -f ${line}.transfer.list ] ; then  a=${line}.transfer.list ; b=${line}.new.dat ; c="${line/.*/}.img" ; echo "$i   >   $a  $b   >   $c" ; log=$(sdat2img.py $a $b $c) ; rm -rf ${line}.transfer.list ; rm -rf ${line}.new.dat ; fi ; done ;  rm -r *.dat ; mkdir images ; rm -r my_preload.img || echo "没有my_preload.img" ; mv *.img images/ ; cp -r images ../$name/ ; mv firmware-update ../$name/ ; cd .. ; rm -r works ; ls $name/images ; 

cd ${name} ; rm -rf firmware-update/vbmeta.img ; mv vbmeta.img firmware-update ; zip -r ${name}.zip * ; mv ${name}.zip ../ ; cd ../ ; rm -rf ${name} ; rm -r 666 || echo "666" ; mkdir 666 ; mv ${name}.zip 666 ; wget https://raw.github.com/zhlhlf/text/main/onedrive_mount.sh ; sh onedrive_mount.sh $RCK 临时存放文件 ；
```
```
onedrive下载案列链接改法
https://drive.google.com/uc?id=1mvZxjJRPp-dweFv7sE7jTxIvvUEXReFQ&export=download&confirm=t&uuid=zhlhlf
https://drive.google.com/uc?id=1mvZxjJRPp-dweFv7sE7jTxIvvUEXReFQ&export=download
```
```
urls=""; 
pip install youtube-dl;rm -rf 666;mkdir 666;cd 666;for i in $urls;do youtube-dl  $i --external-downloader aria2c --external-downloader-args "-x10" ;done;cd ..;wget -q https://raw.github.com/zhlhlf/text/main/onedrive_mount.sh && sh onedrive_mount.sh $RCK vide;
```
