#!/bin/sh
# === Initialize shell environment ===================================
set -eux
# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
# -v  Print shell input lines as they are read.
# -x  Print commands and their arguments as they are executed.
export LC_ALL=C
type command >/dev/null 2>&1 && type getconf >/dev/null 2>&1 &&
export PATH=".:./bin:$(command -p getconf PATH)${PATH+:}${PATH-}"
export UNIX_STD=2003  # to make HP-UX conform to POSIX
Tmp=/tmp/${0##*/}.$$
# === Log ============================================================
exec 2>log/${0##*/}.$$.log
#
# ACK=$(printf '\006') # Use to escape <0x20> temporarily
# POST
dd bs=${CONTENT_LENGTH:-0} count=1 > $Tmp-cgivars_org
cat $Tmp-cgivars_org | cgi-name > $Tmp-cgivars
name=$(nameread name $Tmp-cgivars)
data=$(nameread data $Tmp-cgivars)
echo ${data} > xbrl/${name}.xml
cat <<HTTP_RESPONSE
Content-Type: text/html

saved
HTTP_RESPONSE
#rm $Tmp-*
#rm log/${0##*/}.$$.*
exit 0
# save.cgi