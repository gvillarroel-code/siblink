FROM store/oracle/serverjre:1.8.0_241-b07
RUN mkdir /opt/Siblink
WORKDIR /opt/Siblink
COPY . /opt/Siblink
CMD . ./opt/Siblink/inicioSiblink.sh $MODO

