#!/bin/bash

sleep 5

echo "Modo inicio recibido: " $MODOINICIO

if [[ $MODOINICIO = "inic" ]] 
then
	echo "*** Arranque SibLink modo inic***"
	aa=inic
	echo "*** Resguardando tablas TRACKING y SF***"
	mysql -hdockerhost -uusrSibLink -pzaq12wsx -e "`cat backup_tracking.sql`"
	echo "*** Resguardo OK .. ***"
else
	echo "*** Arranque SibLink modo reenganche***"
	aa=""
fi 

java -Xms2G -Xmx2G -Duser.timezone=GMT-03:00 -jar SibLink.jar test $aa 1 

cat Linksrv.log

