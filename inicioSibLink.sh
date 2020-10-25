#!/usr/bin/bash

#cd /opt/Siblink



aa=
if [[ $MODOINICIO = "inic" ]] 
then
	echo "*** Arranque SibLink modo inic***"
	aa=inic
	rm Linksrv1.log
	mv Linksrv.log  Linksrv1.log 
	mysql -hdockerhost -uusrSibLink -pzaq12wsx -e "`cat backup_tracking.sql`"
else
	echo "*** Arranque SibLink modo reenganche***"
	aa=""
fi 

java -Xms2G -Xmx2G -Duser.timezone=GMT-03:00 -jar SibLink.jar test $aa %1%

cat Linksrv.log

