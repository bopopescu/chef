#!/bin/bash

BACKUP_MASTER_DIR=/data/backups/iad-auth101
BACKUP_FILE=`/bin/ls $BACKUP_MASTER_DIR/*data.tar.gz | /bin/sort -r | /usr/bin/head -1`

if /sbin/ip addr | grep -v '10.5.43.23';
then
 if /bin/tar tzvf $BACKUP_FILE;
 then
   /usr/bin/nagios_passive.py iad-auth101-v260.ihr AUTHDB_Data_Backup_Corruption 0 "OK"
 else
   /usr/bin/nagios_passive.py iad-auth101-v260.ihr AUTHDB_Data_Backup_Corruption 1 "AuthDB data backup may be corrupt"
 fi
fi
