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
# === Usage ===
# Usage   : parsrx.sh [options] [XML_file]
# Options : -c  Prints the child tags which are had by the parent tag
#         : -n  Prints the array subscript number after the tag name
#         : -lf Replaces the newline sign "\n" with <s>. And in this mode,
#               also replaces \ with \\
# CII_exampleN.xml
parsrx.sh -n -lf "$1".xml |
awk '/\/xbrli:xbrl\[1\][^ ]+ [a-zA-Z0-9\-\+\/]/{print}' > $Tmp-step1
cat $Tmp-step1 | 
sed -e 's/\/xbrli:xbrl\[1\]/$/' | sed -e 's/\] /\].v /' |
awk '{
  gsub("/",".",$1);
  print $0;
}' | sort > $Tmp-step2
cat $Tmp-step2 | 
makrj.sh > "$1".json

# rm $Tmp-*
# rm log/${0##*/}.$$.log
exit 0