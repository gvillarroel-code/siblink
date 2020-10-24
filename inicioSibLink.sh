#!/usr/bin/bash

echo "*** Arranque SibLink ***"


############################################################
# Verifica que el contenedor Mysql este iniciado
# Si no esta iniciado indica el comando a ejecutar y sale
###########################################################

mysqlproc=`docker ps --format '{{.Names}}' | grep mysql | wc -l`
if [[ $mysqlproc -lt 1 ]] 
then
 echo "ERROR:  debe iniciar el servidor mysql ***" 
 echo "ejecutar: sudo docker run --rm --name mysql -v /opt/mysql/data:/var/lib/mysql -d -p3306:3306 mysql:5.7  " 
 exit 1
fi


FILE=Siblink_Iniciado 
if test -f "$FILE"; then
	echo "*** SibLink ya iniciado (ver archivo Siblink_Iniciado) , Pulse enter para continuar"
	read
	exit
fi

echo "*** Inicio del dia: inicializa tracking y logs del sistema"
aa=
echo "Inicio del dia (I) o reenganche (R)"
read KeyPressed
if [[ $KeyPressed="I" ]] || [[ $KeyPressed="i" ]]
then
	set aa=inic
	rm Linksrv1.log
	mv Linksrv.log  Linksrv1.log 
	docker exec -e MYSQL_PWD=zaq12wsx mysql mysql -uusrSibLink -e "`cat backup_tracking.sql`"
fi 

while [ 1 ]; do

	touch  Siblink_Iniciado
	echo "Iniciando Siblink, RelayISO y KeepAlive Siblink ..." $aa

	#####################################################	
	# Verifica si el contenedor kasiblink esta iniciado
	# Si esta iniciado lo detiene altes de iniciar Siblink
	#####################################################	

        kasilinkbproc=`docker ps --format '{{.Names}}' | grep kasiblink | wc -l`
        if [[ $kasiblinkproc -eq 1 ]]
        then
         echo "INFO:  deteniendo KeepAlive Siblink ***" 
         sudo docker stop kasiblink
        fi

        ##############################################################   
	# Verifica si el contenedor mcrelayiso (relay) esta iniciado
        # Si no esta iniciado lo inicia de lo contrario lo reinicia
        ############################################################## 

        mcrelayproc=`docker ps --format '{{.Names}}' | grep mcrelayiso | wc -l`
        if [[ $mcrelayproc -lt 1 ]]
        then
         echo "INFO:  iniciando MCrelayISO ***" 
	 sudo docker run --rm -d --name mcrelayiso -p 4000:4000 -p 10767:10767 -m 2G itservicegvillarroel/mcrelay:v3.0
	else
         echo "INFO:  reiniciando MCrelayISO ***" 
 	 sudo docker restart mcrelayiso
        fi
	

        ##############################################################   
        # Inicia en background y con un retardo de 30 seg, keepalive
        ############################################################# 
        echo "INFO:  keepalive iniciara en 30 segundos ***" 
	nohup ./kasiblink_delay.sh &

	java -Xms2G -Xmx2G -Duser.timezone=GMT-03:00 -jar SibLink.jar test $aa %1%

	sleep 5
	echo "INFO: deteniendo relay ISO"
	sudo docker stop mcrelayiso

	echo "INFO: deteniendo keepalive"
	sudo docker stop kasiblink


	set aa=""
	echo "*** Reenganche SibLink ***"
	echo "*"
	echo "Reenganche (R) o Finalizar sistema (X)"
	read KeyPressed

	if [[ $KeyPressed = "X" ]] || [[ $KeyPressed = "x" ]]
	then
		rm Siblink_Iniciado
		exit 0
	fi 
	echo "Reiniciando..."
done


