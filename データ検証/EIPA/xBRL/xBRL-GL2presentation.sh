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
# code	level	module	term	type	label	description	label-ja	description-ja
# 1     2     3       4     5     6     7           8         9
cat gl/source/xBRL-GL.tsv | awk -F'\t' -v module=$1 'BEGIN {
  n=0;
  parent="root";
  curent_level=1;
  currents[1]="";
  currents[2]="";
  currents[3]="";
  currents[4]="";
  currents[5]="";
  currents[6]="";
  currents[7]="";
  print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
  print "<!-- (c) XBRL Japan -->";
  print "<linkbase xmlns=\"http://www.xbrl.org/2003/linkbase\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd\">";
  print "  <presentationLink xlink:type=\"extended\" xlink:role=\"http://www.xbrl.org/2003/role/link\">";
}
{
  code=$1;
  level=$2;
  term=$4;
  currents[level]=code;
  if (1 == level) {
    parent="root";
  }
  else {
    parent=currents[level - 1];
  }
  if (level < current_level) {
    for (i = level + 1; i < 8; i++) {
      currents[i]="";
    }
  }
  current_level=level;
  terms[code]=term;
  p_module=substr(parent, 1, 3);
  if ("src"==p_module) p_module="srcd";
  if ("root"!=parent) {
    if (module==$3) {  
      # print n " " code " parent module=" p_module " parent=" parent " level=" level " [1]" currents[1] " [2]" currents[2] " [3]" currents[3] " [4]" currents[4] " [5]" currents[5] " [6]" currents[6] " [7]" currents[7];
      if (1!=parents[parent]) {
        parents[parent]=1;
        if (p_module==module) {
          printf "    <loc xlink:type=\"locator\" xlink:href=\"gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s\" xlink:title=\"presentation parent: %s\"/>\n", p_module, p_module, terms[parent], p_module, terms[parent], terms[parent];
        } else {
          printf "    <loc xlink:type=\"locator\" xlink:href=\"../gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s\" xlink:title=\"presentation parent: %s\"/>\n", p_module, p_module, terms[parent], p_module, terms[parent], terms[parent];
        }
      }
      printf "    <loc xlink:type=\"locator\" xlink:href=\"gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s\" xlink:title=\"presentation child: %s\"/>\n", module, module, term, module, term, term;
      printf "    <presentationArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/parent-child\" xlink:from=\"gl-%s_%s\" xlink:to=\"gl-%s_%s\" xlink:title=\"presentation: %s to %s\" use=\"optional\" order=\"%s\"/>\n", p_module, terms[parent], module, term, terms[parent], term, n;
    }
    n=n+1;
  }
}
END {
  print "  </presentationLink>";
  print "</linkbase>"; 
}' > gl/source/gl-"$1"-2020-12-31-presentation.xml
# --------------------------------------------------------------------
rm log/${0##*/}.$$.*
exit 0
# xBRL-GL2presentaton.sh
