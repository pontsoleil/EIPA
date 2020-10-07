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
# ID Desc
# 1  2
cat rules/EN_16831-1_functionality.txt rules/EN_16831-1_VAT.txt | awk -F'\t' 'BEGIN { n=0; }
{
  if ($1!="") {
    print "$.data[" n "].num",n;
    print "$.data[" n "].ID",$1;
    print "$.data[" n "].Desc",$2;
  }
  n=n+1;
}' | makrj.sh | sed "s/^\(\"[^\":,]*\":\),/\1null,/" > rules/EN_16831-1_rules.json
# ID Desc Target BusinessTerm
# 1  2    3      4
cat rules/EN_16831-1_conditions.txt rules/EN_16831-1_integrity.txt | awk -F'\t' 'BEGIN { n=0; }
{
  if ($1!="") {
    print "$.data[" n "].num",n;
    print "$.data[" n "].ID",$1;
    print "$.data[" n "].Desc",$2;
    print "$.data[" n "].Target",$3;
    print "$.data[" n "].BusinessTerm",$4;
  }
  n=n+1;
}' | makrj.sh | sed "s/^\(\"[^\":,]*\":\),/\1null,/" > rules/EN_16831-1_rules2.json
