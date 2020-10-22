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
# num	seq	hdr	uniqueID	kind	DictionaryEntryName	name	description	
# 1   2     3   4         5     6                   7     8
# Card	comment1	comment2	comment3	update	private	SME	Invoice	item_name	note
# 9     10        11        12        13      14      15  16      17        18
cat sme.txt | awk -F'\t' 'BEGIN { n=0; }
{
  if (n>0) {
    print "$.data[" n "].num",$1;
    print "$.data[" n "].seq",$2;
    print "$.data[" n "].hdr",$3;
    print "$.data[" n "].uniqueID",$4;
    print "$.data[" n "].kind",$5;
    print "$.data[" n "].DictionaryEntryName",$6;
    print "$.data[" n "].name",$7;
    print "$.data[" n "].description",$8;
    print "$.data[" n "].Card",$9;
    print "$.data[" n "].comment1",$10;
    print "$.data[" n "].comment2",$11;
    print "$.data[" n "].comment3",$12;
    print "$.data[" n "].update",$13;
    print "$.data[" n "].private",$14;
    print "$.data[" n "].SME",$15;
    print "$.data[" n "].Invoice",$16;
    print "$.data[" n "].item_name",$17;
    print "$.data[" n "].note",$18;
  }
  n=n+1;
}' | ../bin/makrj.sh | sed "s/^\(\"[^\":,]*\":\),/\1null,/" > sme.json
# --------------------------------------------------------------------
# rm log/${0##*/}.$$.*
exit 0
# sme.sh