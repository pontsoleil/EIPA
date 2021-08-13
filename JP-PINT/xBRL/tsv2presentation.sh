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
# SemSort BT_ID PINT_ID Level BusinessTerm ビジネス用語名 Definition 説明 Explanation 追加説明 Example Card SemDataType
# 1       2     3       4     5            6            7          8   9           10      11      12   13
# Section Extension SynSort XPath Attributes Rules UBL_DataType Cardinality Alignment
# 14      15        16      17    18         19    20           21          22
cat source/jp_pint.tsv | awk -F'\t' 'BEGIN {
  n=0;
  parent="root";
  curent_level=1;
  currents[1]="";
  currents[2]="";
  currents[3]="";
  currents[4]="";
  print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
  print "<!-- (c) XBRL Japan -->";
  print "<linkbase xmlns=\"http://www.xbrl.org/2003/linkbase\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd\">";
  print "  <presentationLink xlink:type=\"extended\" xlink:role=\"http://www.xbrl.org/2003/role/link\">";
}
{
  if ("root"==$2 || match($2, /^IB[GT]-[0-9]*$/) > 0) {
    id=$2;
    level=$4;
    currents[level]=id;
    if (1 == level) {
      parent="root";
    }
    else {
      parent=currents[level - 1];
    }
    if (level < current_level) {
      for (i = level + 1; i < 5; i++) {
        currents[i]="";
      }
    }
    current_level=level;
    # print n " id=" id " parent=" parent " level=" level " [1]" currents[1] " [2]" currents[2] " [3]" currents[3] " [4]" currents[4];
    if (1!=parents[parent]) {
      parents[parent]=1;
      printf "    <loc xlink:type=\"locator\" xlink:href=\"pint-2021-12-31.xsd#pint_%s\" xlink:label=\"pint_%s\" xlink:title=\"presentation parent: %s\"/>\n", parent, parent, parent;
    }
    printf "    <loc xlink:type=\"locator\" xlink:href=\"pint-2021-12-31.xsd#pint_%s\" xlink:label=\"pint_%s\" xlink:title=\"presentation child: %s\"/>\n", id, id, id;
    printf "    <presentationArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/parent-child\" xlink:from=\"pint_%s\" xlink:to=\"pint_%s\" xlink:title=\"presentation: %s to %s\" use=\"optional\" order=\"%s\"/>\n", parent, id, parent, id, n;
    n=n+1;
  }
}
END {
  print "  </presentationLink>";
  print "</linkbase>"; 
}' > data/pint-2021-12-31-presentation.xml
# --------------------------------------------------------------------
rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# text2presentaton.sh
