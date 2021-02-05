#!/bin/bash

echo "Esperando 20 seg para iniciar Siblink " 
date
sleep 20
date
echo "Modo inicio recibido: " $MODOINICIO

if [[ $MODOINICIO = "inic" ]] 
then
	echo "*** Arranque SibLink modo inic***"
	aa=inic
	echo "*** Resguardando tablas TRACKING y SF***"
	export MYSQL_PWD=zaq12wsx
	mysql -hdockerhost -uusrSibLink -e "`cat backup_tracking.sql`"
	echo "*** Resguardo OK .. ***"
else
	echo "*** Arranque SibLink modo reenganche***"
	aa=""
fi 

java -Xms2G -Xmx2G -Duser.timezone=GMT-03:00 -jar SibLink1.0.6.jar test $aa 1 


