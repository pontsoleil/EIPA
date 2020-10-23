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
cat eipa/source/EN_16931-1.txt | awk -F'\t' 'BEGIN {
    printf "\n\n<!-- item type -->\n";
}
{ 
  if ("root"==$1 || match($1, /^B[GT]-[0-9]*$/) > 0) {
    id=$1;
    datatype=$4;
    if ("Text"==datatype){
      printf "	<complexType name=\"%sItemType\">\n    <simpleContent><restriction base=\"xbrli:stringItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("Code"==datatype) {
      printf "	<complexType name=\"%sItemType\">\n    <simpleContent><restriction base=\"xbrli:tokenItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("Identifier"==datatype) {
      printf "	<complexType name=\"%sItemType\">\n    <simpleContent><restriction base=\"xbrli:stringItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("DocumentReference"==datatype) {
      printf "	<complexType name=\"%sItemType\">\n    <simpleContent><restriction base=\"xbrli:stringItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("Amount"==datatype) {
      printf "	<complexType name=\"%sItemType\">\n    <simpleContent><restriction base=\"xbrli:monetaryItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("Quantity"==datatype) {
      printf "	<complexType name=\"%sItemType\">\n    <simpleContent><restriction base=\"xbrli:decimalItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("Percentage"==datatype) {
      printf "	<complexType name=\"%sItemType\">\n    <simpleContent><restriction base=\"xbrli:pureItemType\"/></simpleContent>\n  </complexType>\n", id;
    }
  }
}
END { }' > $Tmp-types

cat eipa/source/EN_16931-1.txt | awk -F'\t' 'BEGIN {
    printf "\n<!-- element -->\n";
}
{
  if ("root"==$1 || match($1, /^B[GT]-[0-9]*$/) > 0) {
    id=$1;
    printf "	<element name=\"%s\" id=\"eipa-cen_%s\" type=\"eipa-cen:%sItemType\" substitutionGroup=\"xbrli:item\" nillable=\"true\" xbrli:periodType=\"instant\"/>\n", id, id, id;
  }
}
END {
  printf "</schema>";
}' > $Tmp-elements

cat eipa/source/xBRL_schema_head.txt $Tmp-types $Tmp-elements > eipa/source/xBRL_schema.xml

# --------------------------------------------------------------------
# rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# text2schema.sh
