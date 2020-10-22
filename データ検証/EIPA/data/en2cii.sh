#!/bin/sh
# === Initialize shell environment ===================================
set -euvx
# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
# -v  Print shell input lines as they are read.
# -x  Print commands and their arguments as they are executed.
export LC_ALL=C
type command >/dev/null 2>&1 && type getconf >/dev/null 2>&1 &&
export PATH=".:./bin:$(command -p getconf PATH)${PATH+:}${PATH-}"
export UNIX_STD=2003  # to make HP-UX conform to POSIX
# === temporary file prefix ==========================================
Tmp=/tmp/${0##*/}.$$
# === Log ============================================================
exec 2>log/${0##*/}.$$.log
# --------------------------------------------------------------------
# EN_Parent EN_ID EN_Level EN_Card EN_BT EN_Desc EN_DT CII_Path CII_Type
# 1         2     3        4       5     6       7     8        9
# CII_Card CII_Match CII_Rules
# 10       11        12
cat en2cii.txt | awk -F'\t' 'BEGIN { n=0; }
{
  if (n>0 && $1!="") {
    print "$.data[" n "].num",n;
    print "$.data[" n "].EN_Parent",$1;
    print "$.data[" n "].EN_ID",$2;
    print "$.data[" n "].EN_Level",$3;
    print "$.data[" n "].EN_Card",$4;
    print "$.data[" n "].EN_BT",$5;
    print "$.data[" n "].EN_Desc",$6;
    print "$.data[" n "].EN_DT",$7;
    print "$.data[" n "].CII_Path",$8;
    print "$.data[" n "].CII_Type",$9;
    print "$.data[" n "].CII_Card",$10;
    print "$.data[" n "].CII_Match",$11;
    print "$.data[" n "].CII_Rules",$12;
  }
  n=n+1;
}' | makrj.sh | sed "s/^\(\"[^\":,]*\":\),/\1null,/" > en2cii.json
# --------------------------------------------------------------------
rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# en2cii.sh