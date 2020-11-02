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
# code seq level module term type label description label-ja description-ja
# 1    2   3     4      5    6    7     8           9         10
# see https://stackoverflow.com/questions/8024392/awk-replace-a-column-with-its-hash-value
# cat test.txt | awk '{
# term=$0;
# match(term, /^([a-z])(.*)$/, b);
# term=toupper(b[1]) b[2];
# term=gensub(/([a-z])([A-Z])/, "\\1 \\2", "g", term);
# print term;
# }' > test.tsv
# copy field to XBRL-GL.xlsx to create xBRL-GL.tsv
cat gl/source/xBRL-GL.tsv | awk -F'\t' '{
  tmp="echo " $4 date " | openssl md5 | cut -f2 -d\" \"";
  tmp | getline cksum;
  close(tmp);
  print cksum "\t" $0;
}' > $Tmp-cksum
# cksum code seq level module term type label description label-ja description-ja
# 1     2    3   4     5      6    7    8     9           10       11
cat $Tmp-cksum | awk -F'\t' -v module=$1 -v lang=$2 'BEGIN {
  printf "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
  printf "<link:linkbase xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"";
  printf "  xmlns:link=\"http://www.xbrl.org/2003/linkbase\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"";
  printf "  xsi:schemaLocation=\"http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd\">";
  printf "  <link:labelLink xlink:type=\"extended\" xlink:role=\"http://www.xbrl.org/2003/role/link\">\n";
}
{
  if (module==$5) {
    code=$2;
    cksum="_" $1;
    term=$6;
    if ("ja"==lang) {
      label=$10;
      description=$11;
    } else if ("en"==lang) {
      label=$8;
      description=$9;
    }
    if (term || description) {
      printf "    <!-- %s gl-%s:%s -->\n", code, module, term;
      printf "    <link:loc xlink:type=\"locator\" xlink:href=\"gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s%s\"/>\n", module, module, term, module, term, cksum;
      printf "    <link:labelArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/concept-label\" xlink:from=\"gl-%s_%s%s\" xlink:to=\"lbl_%s-%s%s\"/>\n", module, term, cksum, code, lang, cksum;
    }
    if (label) {
      printf "    <link:label xlink:type=\"resource\" xlink:label=\"lbl_%s-%s%s\" xlink:role=\"http://www.xbrl.org/2003/role/label\" xml:lang=\"%s\">%s</link:label>\n", code, lang, cksum, lang, label;
    }
    if (description) {
      printf "    <link:label xlink:type=\"resource\" xlink:label=\"lbl_%s-%s%s\" xlink:role=\"http://www.xbrl.org/2003/role/documentation\" xml:lang=\"%s\">%s</link:label>\n", code, lang, cksum, lang, description;
    }
  }
}
END {
  printf " </link:labelLink>\n";
  printf "</link:linkbase>";
}' > gl/source/gl-"$1"-2020-12-31-label"-$2".xml

# --------------------------------------------------------------------
rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# xBRL-GL2label.sh
