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
cat eipa/source/EN_16931-1.txt | awk -F'\t' 'BEGIN { n=0; }
{
  id=$1;
  printf "	<element name=\"%s\" id=\"eipa-cor_%s\" type=\"xbrli:stringItemType\" substitutionGroup=\"xbrli:item\" nillable=\"true\" xbrli:periodType=\"instant\"/>\n", id, id;
  n=n+1;
}
END { }' > eipa/source/elements.xml
# --------------------------------------------------------------------
# rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# presentaton.sh
