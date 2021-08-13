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
# SemSort BT_ID PINT_ID Level BusinessTerm ビジネス用語名 Definition 説明 Explanation 追加説明 Example Card SemDataType
# 1       2     3       4     5            6            7          8   9           10      11      12   13
# Section Extension SynSort XPath Attributes Rules UBL_DataType Cardinality Alignment
# 14      15        16      17    18         19    20           21          22
cat source/jp_pint.tsv | awk -F'\t' 'BEGIN {
    printf "\n\n<!-- item type -->\n";
}
{ 
  if ("ibg-00"==$3 || match($3, /^ib[gt]-[0-9]*$/) > 0) {
    id=$3;
    datatype=$13;
    if ("Text"==datatype){
      printf "	<complexType name=\"%s-ItemType\">\n    <simpleContent><restriction base=\"xbrli:stringItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("Code"==datatype) {
      printf "	<complexType name=\"%s-ItemType\">\n    <simpleContent><restriction base=\"xbrli:tokenItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("Identifier"==datatype) {
      printf "	<complexType name=\"%s-ItemType\">\n    <simpleContent><restriction base=\"xbrli:stringItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("DocumentReference"==datatype) {
      printf "	<complexType name=\"%s-ItemType\">\n    <simpleContent><restriction base=\"xbrli:stringItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("Date"==datatype) {
      printf "	<complexType name=\"%s-ItemType\">\n    <simpleContent><restriction base=\"xbrli:dateTimeItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("Amount"==datatype) {
      printf "	<complexType name=\"%s-ItemType\">\n    <simpleContent><restriction base=\"xbrli:monetaryItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("Quantity"==datatype) {
      printf "	<complexType name=\"%s-ItemType\">\n    <simpleContent><restriction base=\"xbrli:decimalItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else if ("Percentage"==datatype) {
      printf "	<complexType name=\"%s-ItemType\">\n    <simpleContent><restriction base=\"xbrli:pureItemType\"/></simpleContent>\n  </complexType>\n", id;
    } else {
      printf "	<complexType name=\"%s-ItemType\">\n    <simpleContent><restriction base=\"xbrli:stringItemType\"/></simpleContent>\n  </complexType>\n", id;
    }
  }
}
END { }' > $Tmp-types

cat source/jp_pint.tsv | awk -F'\t' 'BEGIN {
    printf "\n<!-- element -->\n";
}
{
  if ("ibg-00"==$3 || match($3, /^ib[gt]-[0-9]*$/) > 0) {
    id=$3;
    printf "	<element name=\"%s\" id=\"pint_%s\" type=\"pint:%s-ItemType\" substitutionGroup=\"xbrli:item\" nillable=\"true\" xbrli:periodType=\"instant\"/>\n", id, id, id;
  }
}
END {
  printf "</schema>";
}' > $Tmp-elements

cat source/PINT_schema_head.txt $Tmp-types $Tmp-elements > data/pint-2021-12-31.xsd

# --------------------------------------------------------------------
rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# text2schema.sh
