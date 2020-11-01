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
# === tsv -> xml ============================================================
# code	level	module	term	type	label	description	label-ja	description-ja
# 1     2     3       4     5     6     7           8         9
cat gl/source/xBRL-GL.tsv | awk -F'\t' -v module=$1 'BEGIN {
    printf "\n  <!-- item %s -->\n", module;
}
{
  if (module==$3) {
    code=$1;
    type=$5;
    term=$4;
    if ("_"==$5) {
      printf "	<element name=\"%s\" id=\"gl-%s_%s\" type=\"xbrli:stringItemType\" substitutionGroup=\"xbrli:item\" nillable=\"true\" xbrli:periodType=\"instant\"/>\n", code, module, term;
    } else {
      if ("gl-gen:"==substr(type,1,7)) {
        printf "	<element name=\"%s\" id=\"gl-%s_%s\" type=\"%s\" substitutionGroup=\"xbrli:item\" nillable=\"true\" xbrli:periodType=\"instant\"/>\n", code, module, term, type;
      } else {
        printf "	<element name=\"%s\" id=\"gl-%s_%s\" type=\"gl-%s:%s\" substitutionGroup=\"xbrli:item\" nillable=\"true\" xbrli:periodType=\"instant\"/>\n", code, module, term, module, type;
      }
    }
  }
}
END {
  printf "</schema>";
}' > $Tmp-elements

cat gl/source/xBRL-GL-"$1"-head.txt $Tmp-elements > gl/source/gl-"$1"-2020-12-31.xsd

# --------------------------------------------------------------------
rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# xBRL-GL2schema.sh
