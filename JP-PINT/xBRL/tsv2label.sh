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
# see https://stackoverflow.com/questions/8024392/awk-replace-a-column-with-its-hash-value
cat source/jp_pint.tsv | awk -F'\t' '{
  tmp="echo " $2 date " | openssl md5 | cut -f2 -d\" \"";
  tmp | getline cksum;
  close(tmp);
  print cksum "\t" $0;
}' > $Tmp-cksum

# cksum seq code	level	module	term	type	label	description	label-ja	description-ja
# 1     2   3     4     5       6     7     8     9           10        11

# cksum SemSort BT_ID PINT_ID Level BusinessTerm ビジネス用語名 Definition 説明 Explanation 追加説明 Example Card SemDataType
# 1     2       3     4       5     6            7            8          9   10          11      12      13   14
# Section Extension SynSort XPath Attributes Rules UBL_DataType Cardinality Alignment
# 15      16        17      18    19         20    21           22          23
cat $Tmp-cksum | awk -F'\t' 'BEGIN {
  printf "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
  printf "<link:linkbase xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"";
  printf "  xmlns:link=\"http://www.xbrl.org/2003/linkbase\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"";
  printf "  xsi:schemaLocation=\"http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd\">";
  printf "  <link:labelLink xlink:type=\"extended\" xlink:role=\"http://www.xbrl.org/2003/role/link\">\n";
}
{ 
  if ("root"==$3 || match($3, /^IB[GT]-[0-9]*$/) > 0) {
    id=$3;
    cksum="_" $1;
    label="";
    # for(i=6;i<=NF;i++) label=label $i" "; 
    label = $6
    printf "    <link:loc xlink:type=\"locator\" xlink:href=\"pint-2021-12-31.xsd#pint_%s\" xlink:label=\"%s%s\"/>\n", id, id, cksum;
    printf "    <link:label xlink:type=\"resource\" xlink:label=\"label_%s%s\" xlink:role=\"http://www.xbrl.org/2003/role/label\" xml:lang=\"en\" id=\"label_%s%s\">%s</link:label>\n", id, cksum, id, cksum, label;
    printf "    <link:labelArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/concept-label\" xlink:from=\"%s%s\" xlink:to=\"label_%s%s\"/>\n", id, cksum, id, cksum;
  }
}
END {
  printf " </link:labelLink>\n";
  printf "</link:linkbase>";
}' > data/pint-2021-12-31-label.xml

# --------------------------------------------------------------------
# rm $Tmp-*
# rm log/${0##*/}.$$.*
exit 0
# text2label.sh
