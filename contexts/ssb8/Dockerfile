FROM tomcat:8.5-jre11-openjdk

ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPORT ORDS_CONFIG=/opt/ords/conf
WORKDIR /opt/ords
RUN wget https://download.oracle.com/otn_software/java/ords/ords-latest.zip && \
    unzip ords-latest.zip && \
    rm ords-latest.zip
