#!/bin/bash
ssh 172.16.35.1 -i /docker/key  -o stricthostkeychecking=no > /dev/null 2>&1 << eeooff

cd /home/temp
#这种方式无法获取到变量
#export password1=$(oc whoami -t)
#echo $password1 >> password1
#docker login -u admin -p $password1 docker-registry.default.svc:5000 2>> dockerlog
#docker login -u admin -p `oc whoami -t` docker-registry.default.svc:5000 2>> dockerlog
./logindocker.sh
docker pull docker-registry.default.svc:5000/$2/$1
docker save -o $1.tar docker-registry.default.svc:5000/$2/$1:latest
scp ./$1.tar root@lb.qyos.com:/mnt/devdockertar/

exit
eeooff
echo copy done!
scp -i /docker/key -o stricthostkeychecking=no  /docker/$1.tar 172.16.36.1:/home/temp/
ssh 172.16.36.1 -i /docker/key  -o stricthostkeychecking=no > /dev/null 2>&1 << eeooff

cd /home/temp
docker load -i $1.tar
#password2=`oc whoami -t`
#docker login -u admin -p `oc whoami -t` docker-registry.default.svc:5000
./logindocker.sh
docker tag docker-registry.default.svc:5000/$2/$1:latest docker-registry.default.svc:5000/$3/$1:latest
docker push docker-registry.default.svc:5000/$3/$1:latest

exit
eeooff
echo push done!
