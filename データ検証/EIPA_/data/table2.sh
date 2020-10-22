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
# ID Level Card BusinessTerm Desc UsageNote ReqID SemanticDataType
# 1  2     3    4            5    6         7     8
cat rules/EN_16831-1_table2.txt | awk -F'\t' 'BEGIN { n=0; }
{
  if (n>0 && $1!="") {
    print "$.data[" n "].num",n;
    print "$.data[" n "].ID",$1;
    print "$.data[" n "].Level",$2;
    print "$.data[" n "].Card",$3;
    print "$.data[" n "].BusinessTerm",$4;
    print "$.data[" n "].Desc",$5;
    print "$.data[" n "].UsageNote",$6;
    print "$.data[" n "].ReqID",$7;
    print "$.data[" n "].SemanticDataType",$8;
  }
  n=n+1;
}' | makrj.sh | sed "s/^\(\"[^\":,]*\":\),/\1null,/" > rules/EN_16831-1_table2.json
