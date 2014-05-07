#default=192.168.0.4
#read -p "Enter IP address [$default]: " REPLY
#REPLY=${REPLY:-$default}
#echo "IP is $REPLY"

lname=Beja-arteiga
read -p "enter lname (default $lname): " input
Language=${input:-$lname}
echo "Language is: $Language"
