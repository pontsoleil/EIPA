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
cat eipa/source/EN_16931-1.txt | awk -F'\t' 'BEGIN {
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
  id=$1;
  level=$2;
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
    printf "    <loc xlink:type=\"locator\" xlink:href=\"eipa-cor-2020-12-31.xsd#eipa-cor_%s\" xlink:label=\"eipa-cor_%s\" xlink:title=\"presentation parent: %s\"/>\n", parent, parent, parent;
  }
  printf "    <loc xlink:type=\"locator\" xlink:href=\"eipa-cor-2020-12-31.xsd#eipa-cor_%s\" xlink:label=\"eipa-cor_%s\" xlink:title=\"presentation child: %s\"/>\n", id, id, id;
  printf "    <presentationArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/parent-child\" xlink:from=\"eipa-cor_%s\" xlink:to=\"eipa-cor_%s\" xlink:title=\"presentation: %s to %s\" use=\"optional\" order=\"%s\"/>\n", parent, id, parent, id, n;
  n=n+1;
}
END {
  print "  </presentationLink>";
  print "</linkbase>"; 
}' > eipa/cor/eipa-cor-2020-12-31-presentation.xml
# --------------------------------------------------------------------
# rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# presentaton.sh
