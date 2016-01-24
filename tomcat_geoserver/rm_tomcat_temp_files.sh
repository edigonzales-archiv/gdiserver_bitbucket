Files=`ls --sort=t /usr/local/apache-tomcat-8/temp`
for filename in $Files
do
if rm "/usr/local/apache-tomcat-8/temp/$filename"
then
 echo "Successfully deleted : /usr/local/apache-tomcat-8/temp/$filename "
else
 echo "Could not delete file : /usr/local/apache-tomcat-8/temp/$filename "
fi
done
