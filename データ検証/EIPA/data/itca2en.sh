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
# ITCA_Path level ITCA_Card EN_ID EN_Level EN_Card EN_BT EN_Desc EN_DT 
# 1         2     3         4     5        6       7     8       9     
# seq itca_num name CCL_ID EDI Invoice Matching
# 10  11       12   13     14  15      16
cat itca/itca2en.tsv | awk -F'\t' 'BEGIN { n=0; }
{
  if (n>0) {
    print "$.data[" n "].num",n;
    print "$.data[" n "].Path",$1;
    print "$.data[" n "].level",$2;
    print "$.data[" n "].Card",$3;
    print "$.data[" n "].EN_ID",$4;
    print "$.data[" n "].EN_Level",$5;
    print "$.data[" n "].EN_Card",$6;
    print "$.data[" n "].EN_BT",$7;
    print "$.data[" n "].EN_Desc",$8;
    print "$.data[" n "].EN_DT",$9;
    print "$.data[" n "].seq",$10;
    print "$.data[" n "].itca_num",$11;
    print "$.data[" n "].name",$12;
    print "$.data[" n "].CCL_ID",$13;
    print "$.data[" n "].EDI",$14;
    print "$.data[" n "].Invoice",$15;
    print "$.data[" n "].Matching",$16;
  }
  n=n+1;
}' | makrj.sh | sed "s/^\(\"[^\":,]*\":\),/\1null,/" > itca/itca2en.json
# --------------------------------------------------------------------
rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# cii2en.sh