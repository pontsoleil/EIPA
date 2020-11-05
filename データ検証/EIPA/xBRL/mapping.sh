#!/bin/sh
# === Initialize shell environment ===================================
set -euvx
# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
# -v  Print shell input lines as they are read.
# -x  Print commands and their arguments as they are executed.
export LC_ALL=C
type command >/dev/null 2>&1 && type getconf >/dev/null 2>&1 &&
export PATH=".:./bin:../bin:$(command -p getconf PATH)${PATH+:}${PATH-}"
export UNIX_STD=2003  # to make HP-UX conform to POSIX
# === temporary file prefix ==========================================
Tmp=/tmp/${0##*/}.$$
# === Log ============================================================
exec 2>log/${0##*/}.$$.log
# === tsv -> xpath ============================================================
# id seq level module term code
# 1    2   3     4      5    6
# Input Text (JSONPath-value Formatted Text) for makrj.sh
#    $.hoge 111
#    $.foo[0] 2\n2
#    $.foo[1].bar 3 3
#    $.foo[1].fizz.bazz 444
#    $.foo[2] \u5555
cat gl/source/mapping.tsv | awk -F'\t' 'BEGIN {
  n=0;
  parent="root";
  curent_level=1;
  currents[1]="";
  currents[2]="";
  currents[3]="";
  currents[4]="";
  currents[5]="";
  currents[6]="";
  idx[1]=0;
  idx[2]=0;
  idx[3]=0;
  idx[4]=0;
  idx[5]=0;
  idx[6]=0;
}
{
  if (n>0) {
    id=$1;
    level=$3;
    term=$5;
    code=$6;
    currents[level]=id;
    idx[level]=idx[level]+1;
    if (level < current_level) {
      for (i=level+1; i<5; i++) {
        currents[i]="";
        idx[i]=0;
      }
    }
    current_level=level;
    # print n " id=" id " level=" level " [1]" currents[1] " [2]" currents[2] " [3]" currents[3] " [4]" currents[4] " [5]" currents[5] " [6]" currents[6];
    printf "$";
    for (i=1; i<=level; i++) {
      printf ".%s[0]", currents[i];
    }
    printf ".name %s\n", term;
        for (i=1; i<=level; i++) {
      printf ".%s[0]", currents[i];
    }
    printf ".code %s\n", code;
  }
  n=n+1;
}
END {}' > $Tmp-source
cat $Tmp-source | makrj.sh > gl/source/mapping_gl.js
# --------------------------------------------------------------------
rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# mapping.sh