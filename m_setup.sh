#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: 参数为你的域名！"
    echo "Usage: $0 domain"
    exit 1
fi

domain=$1
username=$(whoami)
random_port=$((RANDOM % 40001 + 20000))  


read -p "输入UUID:" uuid
if [ -z "$uuid" ]; then
    echo "Error: UUID不能为空！"
    exit 1
fi
echo "你输入的UUID: $uuid"
read -p "是否安装探针? [y/n] [n]:" input
input=${input:-n}
if [ "$input" != "n" ]; then
   read -p "输入NEZHA_SERVER(哪吒v1填写形式：nz.abc.com:8008,哪吒v0填写形式：nz.abc.com):" nezha_server
   if [ -z "$nezha_server" ]; then
    echo "Error: nezha_server不能为空！"
    exit 1
  fi
  read -p "输入NEZHA_PORT( v1面板此处按回车, v0的agent端口为{443,8443,2096,2087,2083,2053}其中之一时开启tls):" nezha_port
  nezha_port=${nezha_port:-""}
  read -p "输入NEZHA_KEY(v1的NZ_CLIENT_SECRET或v0的agent端口):" nezha_key
  if [ -z "$nezha_key" ]; then
    echo "Error: nezha_key不能为空！"
    exit 1
  fi
fi
echo "你输入的nezha_server: $nezha_server, nezha_port:$nezha_port, nezha_key:$nezha_key"

sed -i "s/NEZHA_SERVER || ''/NEZHA_SERVER || '$nezha_server'/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/NEZHA_PORT || ''/NEZHA_PORT || '$nezha_port'/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/NEZHA_KEY || ''/NEZHA_KEY || '$nezha_key'/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/#DOMAIN#/$domain/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/3000;/$random_port;/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/#UUID#/$uuid/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s|/HOME|/home/$username|g" "/home/$username/domains/$domain/public_html/index.js"


echo "安装完毕" 