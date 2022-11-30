FROM openjdk:8 as builder

WORKDIR /build
COPY ["{app_name}.war", "."]
RUN unzip {app_name}.war -d {app_name}

WORKDIR /build/{app_name}/WEB-INF/classes/
COPY ["footer*.groovy", "/tmp/"]
# echo a newline to the .groovy file before the adding the footer
# (the file may not end with a newline)
RUN echo >> {app_name}.groovy && \
    cat /tmp/footer*.groovy >> {app_name}.groovy

COPY ["footer*.groovy", "/tmp/"]
RUN cat /tmp/footer*.groovy >> {app_name}_configuration.groovy


FROM tomcat:8.5-jre8-openjdk

ENV TZ={timezone}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ["ojdbc8.jar", "/usr/local/tomcat/lib/"]

COPY ["context.xml", "/usr/local/tomcat/conf/"]
COPY ["server.xml", "/usr/local/tomcat/conf/"]

WORKDIR /usr/local/tomcat/webapps
COPY --from=builder /build/{app_name} {app_name}

#COPY ["*.jpg", "{app_name}/assets/backgrounds/"]

WORKDIR /usr/local/tomcat/
COPY ["setenv.sh", "bin/setenv.sh"]

RUN useradd tomcat && \
    chown -R tomcat.tomcat /usr/local/tomcat
USER tomcat

#copy ["limits.conf", "/etc/security/limits.conf"]
#ENV CATALINA_OPTS="-server -Xms14g -Xmx14g -Doracle.jdbc.autoCommitSpecCompliant=false"
