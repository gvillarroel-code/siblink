FROM store/oracle/serverjre:1.8.0_241-b07
#RUN yum install -y wget
#RUN yum install -y net-tools
#RUN yum install -y iputils
#RUN wget https://repo.mysql.com//mysql80-community-release-el7-3.noarch.rpm
#RUN yum-config-manager --enable mysql57-community
#RUN rpm -Uvh mysql80-community-release-el7-3.noarch.rpm 
#RUN yum-config-manager --disable mysql80-community
#RUN yum install -y mysql

RUN yum localinstall -y https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
RUN yum install -y mysql-community-client

RUN mkdir /opt/Siblink
WORKDIR /opt/Siblink
COPY . /opt/Siblink
CMD /opt/Siblink/inicioSibLink.sh

