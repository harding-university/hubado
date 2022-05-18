if [ -f /tomcat-env/env.properties ]
then
    cat /tomcat-env/env.properties >> /usr/local/tomcat/conf/catalina.properties
else
    echo "WARNING: No env.properties. See volumes/tomcat-env/env.properties.example"
fi

