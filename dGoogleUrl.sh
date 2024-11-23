a1="https://drive.usercontent.google.com/download?id=14S0v0GMzWcOZJKNXoMOF_vt_2p9MQNvW&export=download&authuser=0"
#xmlData=`curl "$a1"`
xmlData=`curl "$1"`
ff="https://drive.usercontent.google.com/download?"
add(){
    if [ "$1" = "" ];then
        echo $ff
        exit 0
    fi
#        echo $1
    ff+=$1
}
getValue(){ 
  i=0
   
  h1=`echo $xmlData | sed s/'input type="hidden"'/"\nzhlhlf"/g | grep "zhlhlf name" | awk -F"form" '{print $1}'`
while true
do
  i=$((i+2))
  g=`echo $h1 | awk -F'"' "{print $"$i"}"`
  add $g
  add "="
  i=$((i+2))
  g=`echo $h1 | awk -F'"' "{print $"$i"}"`
  add $g
  add "&" 
done
  
}
getValue
echo $ff
