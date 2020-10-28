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
# seq parent code level type module term description
# 1   2      3    4     5    6      7    8
# see https://stackoverflow.com/questions/8024392/awk-replace-a-column-with-its-hash-value
cat gl/source/xBRL-GL.txt | awk -F'\t' '{
  tmp="echo " $3 date " | openssl md5 | cut -f2 -d\" \"";
  tmp | getline cksum;
  close(tmp);
  print cksum "\t" $0;
}' > $Tmp-cksum
# cksum seq parent code level type module term description
# 1     2   3      4    5     6    7      8    9
cat $Tmp-cksum | awk -F'\t' -v module=$1 'BEGIN {
  printf "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
  printf "<link:linkbase xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"";
  printf "  xmlns:link=\"http://www.xbrl.org/2003/linkbase\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"";
  printf "  xsi:schemaLocation=\"http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd\">";
  printf "  <link:labelLink xlink:type=\"extended\" xlink:role=\"http://www.xbrl.org/2003/role/link\">\n";
}
{
  if (module==$7) {
    code=$4;
    cksum="_" $1;
    term=$8
    description="";
    for(i=9;i<=NF;i++) description=description $i" "; 
    # print code " " description;
    printf "    <!-- %s gl-%s:%s -->\n", code, module, term;
    printf "    <link:loc xlink:type=\"locator\" xlink:href=\"gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s%s\"/>\n", module, module, term, module, term, cksum;
    if (term) {
      printf "    <link:label xlink:type=\"resource\" xlink:label=\"label_%s%s\" xlink:role=\"http://www.xbrl.org/2003/role/label\" xml:lang=\"en\">%s</link:label>\n", code, cksum, term;
      printf "    <link:labelArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/concept-label\" xlink:from=\"gl-%s_%s%s\" xlink:to=\"label_%s%s\"/>\n", module, term, cksum, code, cksum;
    }
    if (description) {
      printf "    <link:label xlink:type=\"resource\" xlink:label=\"documentation_%s%s\" xlink:role=\"http://www.xbrl.org/2003/role/documentation\" xml:lang=\"en\">%s</link:label>\n", code, cksum, description;
      printf "    <link:labelArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/concept-documentation\" xlink:from=\"gl-%s_%s%s\" xlink:to=\"documentation_%s%s\"/>\n", module, term, cksum, code, cksum;
    }
  }
}
END {
  printf " </link:labelLink>\n";
  printf "</link:linkbase>";
}' > gl/source/gl-"$1"-2020-12-31-label.xml

# --------------------------------------------------------------------
rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# xBRL-GL2label.sh
