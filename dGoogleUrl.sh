#google url download
# in https://drive.usercontent.google.com/download?id=18beYZJsFLoroun3DlaaI188KWdjU1Zr9&export=download&authuser=0

file=data

url="$1"

curl "$url" > $file

sed -i 's/.*<form//g' $file
sed -i 's/<input/\n/g' $file

url=`grep "action=" $file | sed "s/.*action=\"//g" | sed 's/".*//g'`

sed -i "s/.*action=.*//g" $file
sed -i "s/.*submit.*//g" $file
sed -i "s/>/\n/g" $file

sed -i "s/<.*//g" $file

ff=""
while true;do
    key=`grep "name" $file | head -n1 | cut -d'"' -f 4`
    if [ ! "$key" ];then break; fi
    value=`grep "name" $file | head -n1 | cut -d'"' -f 6`
    ff+="&$key=$value"
    sed -i "s/.*name=\"$key\".*//g" $file
done

echo ${url}${ff}


