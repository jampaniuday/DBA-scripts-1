!cat hc.sh
NORM="\033[0m"
LLBLUE="\033[1;34m"
RED="\033[0;31m"
LGREEN="\033[1;32m"
BOLD="\033[1m"
UNDERLINE="\033[4m"
LYELLOW="\033[1;33m"

echo "*************************************************************************************"
echo "${LGREEN}${BOLD}                    ${UNDERLINE}THE DB AND LISTENER${NORM}"
echo "${LLBLUE}${UNDERLINE}DB${NORM}"
ps -ef|grep pmon
echo "${LLBLUE}${UNDERLINE}Listener${NORM}"
ps -ef|grep tns
echo "------------------------------------------------------------------------------------"
echo "${LGREEN}${BOLD}                    ${UNDERLINE}THE FILESYSTEMS${NORM}"
echo "${LLBLUE}${UNDERLINE}ORACLE HOME${NORM}"
bdf | grep /SP04CR01_u01/oracle
echo "${LLBLUE}${UNDERLINE}ADMIN${NORM}"
bdf | grep /SP04CR01_u01/admin
echo "${LLBLUE}${UNDERLINE}ARCHIVES${NORM}"
bdf | grep archives_
echo "*************************************************************************************"
echo "${LGREEN}${BOLD}                    ${UNDERLINE}THE TABLESPACES AND MODE OF DATABASE${NORM}"

export ORACLE_HOME=/SP04CR01_u01/oracle/product/10.2.0.3
export PATH=$PATH:$ORACLE_HOME/bin:/usr/sbin
export ORACLE_SID=CRMSPH1
sqlplus -s /nolog  <<EOF

conn /as sysdba

!echo "${LLBLUE}${UNDERLINE}TABLESPACES${NORM}"
@ts
!echo "${LLBLUE}${UNDERLINE}DB MODE${NORM}"
select name,open_mode,log_mode from v\$database;
!echo "${LLBLUE}${UNDERLINE}SESSION COUNTS${NORM}"
select count(sid) ALL_SESSIONS from v\$session where username is not null and status <> 'KILLED';
select count(sid) ACTIVE_SESSIONS from v\$session where username is not null and status='ACTIVE';
select count(sid) INACTIVE_SESSIONS from v\$session where username is not null and status='INACTIVE';
EOF
echo "*************************************************************************************"
echo "${LGREEN}${BOLD}                    ${UNDERLINE}BACKUP STATUS AND FILESYSTEM ALERTS${NORM}"
echo "${LYELLOW}${UNDERLINE}BACKUPS STATUS${NORM}"
cd /SP04CR01_bkpscripts
ora_verify_backup_SP04CR01.sh
echo "${RED}${BOLD}            ${UNDERLINE}FILESYSTEM ALERTS(>85%)${NORM}"
echo "${RED}"
bdf | grep -v /dev | awk '+$4 >= 85{print}'
echo "${NORM}*********************************************************"
