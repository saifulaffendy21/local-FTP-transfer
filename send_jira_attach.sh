#!/bin/bash

# START THE PROGRAM
SDATE="$(date +%d-%b-%Y--%H:%M)"
echo "THIS PROGRAM RUNNNING AT "$SDATE""
echo ""

# Set IP, Username  and Password
HOST=<ENTER YOUR FTP IP ADDRESS>
USER=<ENTER USERNAME OF FTP USER>
PASSWORD=<ENTER PASSWORD OF FTP USER>

ZIPFILE="$(date +%d:%m:%Y-%H%M-attachments_jira.zip)"
echo $ZIPFILE "will be ZIPPED" 
#Here is where need to specify the directory of the file that need to be ZIP
zip -r ../log/$ZIPFILE attach/
cd ../log/

echo "Connect FTP server to send the backup file"
echo ""
# Connect to FTP server
ftp -inv $HOST <<EOF
user $USER $PASSWORD
cd confluence/
put $ZIPFILE
# mput *.txt
bye
EOF
echo ""

# STOP THE PROGRAM
EDATE="$(date +%d-%b-%Y--%H:%M)"
echo "THIS PROGRAM STOP AT "$EDATE""
echo ""

exit
