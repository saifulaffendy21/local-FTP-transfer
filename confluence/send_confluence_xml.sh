#!/bin/bash
# Modified by : saifulaffendy21@gmail.com

# START THE PROGRAM
SDATE="$(date +%d-%b-%Y--%H:%M)"
echo "THIS PROGRAM RUNNNING AT "$SDATE""
echo "" 

# Set IP, Username  and Password
HOST=<ENTER YOUR FTP IP ADDRESS>
USER=<ENTER USERNAME OF FTP SERVER>
PASSWORD=<ENTER PASSWORD OF THE USER>

# Get the latest file in the latest folder
FILE=$(find /var/atlassian/application-data/confluence/backups/ -maxdepth 1 -type f \( ! -iname ".*" \) | cut -c1- | xargs ls -t | head -1)
# Change ~/test.lab/test-ftp-tmrnd/ to selected backup file

# Choose character to remove from string
IFS='/' # hyphen (/) is set as delimiter

# Eliminate th character in $FILE and save in $ADDR
read -ra ADDR <<< "$FILE"

# Get the last line in the history.txt file
LASTCOPY=$(tail -n 1 /var/log/FTP_BACKUP/history.txt)
echo ""

#  IF ELSE to compare the if file is new in FTP
if [ ${ADDR[-1]} = $LASTCOPY ]; then
  echo "THE FILE ALREADY EXIST IN THE FTP SERVER!"
  echo "FTP TRANSFER EXITING!"
else 
  echo "The "${ADDR[-1]}"  file will be copy to FTP server (10.44.11.90)"
  echo ""
  echo  ${ADDR[-1]} >> /var/log/FTP_BACKUP/history.txt
  #To save the current selected file for later checking 
  # Connect to FTP server
  ftp -inv $HOST <<EOF
  user $USER $PASSWORD
  cd ~/atlassian_backup/confluence/
  put ${ADDR[-1]}
  # mput *.txt TO SEND MULTIPLE FILE 
  bye
EOF
fi

# STOP THE PROGRAM
EDATE="$(date +%d-%b-%Y--%H:%M)"
echo "THIS PROGRAM STOP AT "$EDATE""
echo ""

exit
