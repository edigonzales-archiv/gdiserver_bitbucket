#!/bin/bash

# Set up script variables
PID_FILE=/usr/local/apache-tomcat-8.0.30/bin/catalina.pid
#HTTP_URL=http://www.catais.org:8080/geoserver/openlayers/img/west-mini.png
HTTP_URL=http://85.25.185.233:8080/index.jsp
CATALINA_SCRIPT=/usr/local/apache-tomcat-8.0.30/bin/catalina.sh
PID=`cat $PID_FILE`

# Function to kill and restart application server
function catalinarestart() {
  $CATALINA_SCRIPT stop
  sleep 5
  kill 9 $PID
  $CATALINA_SCRIPT start
}

if [ -d /proc/$PID ]
  then
    # App server is running - kill and restart it if there is no response.
    wget $HTTP_URL -T 1 --timeout=20 -O /dev/null &> /dev/null
    if [ $? -ne "0" ]
      then
      echo Restarting Catalina because $HTTP_URL does not respond, pid $PID
      catalinarestart
      # else
      # echo No Problems!  
    fi
else
  # App server process is not running - restart it
  echo Restarting Catalina because pid $PID is dead.
  catalinarestart
fi
