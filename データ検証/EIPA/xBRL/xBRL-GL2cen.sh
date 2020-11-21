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
# Tmp=log/${0##*/}.$$
# === Log ============================================================
exec 2>log/${0##*/}.$$.log
# ====================================================================
# 1. cen.tsv -> schema
# seq code general level parent mode plt_parent module term ID label description p_term plt_term Card dataType
# 1   2    3       4     5      6    7          8      9    10 11    12          13     14       15   16
cat gl/source/cen.tsv | awk -F'\t' 'BEGIN {
  n=0;
  printf "\n  <!-- item -->\n";
}
{
  module=$8;
  if (n>0 && "cen"==module) {
    code=$2;
    term=$9;
    type=$16;
    # printf " %s %s %s %s\n", code, module, term, type;
    if (""==$16) {
      printf "  <element name=\"%s\" id=\"gl-%s_%s\" type=\"xbrli:stringItemType\" substitutionGroup=\"xbrli:item\" nillable=\"true\" xbrli:periodType=\"instant\"/>\n", code, module, term;
    } else {
      printf "  <element name=\"%s\" id=\"gl-%s_%s\" type=\"gl-%s:%s\" substitutionGroup=\"xbrli:item\" nillable=\"true\" xbrli:periodType=\"instant\"/>\n", code, module, term, module, type;
    }
  }
  n=n+1;
}
END {
  printf "</schema>";
}' > $Tmp-elements
cat gl/source/head/xBRL-GL-cen-head.txt $Tmp-elements > gl/source/gl-cen-2020-12-31.xsd

# 2. cen.tsv
# seq code general level parent mode plt_parent module term ID label description p_term plt_term Card dataType
# 1   2    3       4     5      6    7          8      9    10 11    12          13     14       15   16
# see https://stackoverflow.com/questions/8024392/awk-replace-a-column-with-its-hash-value
# copy field to XBRL-GL.xlsx to create xBRL-GL.tsv
cat gl/source/cen.tsv | awk -F'\t' 'BEGIN {
  n=0;
}
{
  if (n>0) {
    tmp="echo " $2 date " | openssl md5 | cut -f2 -d\" \"";
    tmp | getline cksum;
    close(tmp);
    print cksum "\t" $0;
  }
  n=n+1;
}' > $Tmp-cksum

# 3. label
# cksum seq code general level parent mode plt_parent module term ID label description p_term plt_term Card dataType
# 1     2   3    4       5     6      7    8          9      10   11 12    13          14     15       16   17
cat $Tmp-cksum | awk -F'\t' 'BEGIN {
  printf "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
  printf "<link:linkbase xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"";
  printf "  xmlns:link=\"http://www.xbrl.org/2003/linkbase\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"";
  printf "  xsi:schemaLocation=\"http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd\">";
  printf "  <link:labelLink xlink:type=\"extended\" xlink:role=\"http://www.xbrl.org/2003/role/link\">\n";
}
{
  module=$9;
  mode=$7;
  code=$3;
  cksum="_" $1;
  term=$10;
  label=$12;
  description=$13;
  lang="en";
  if ("a"==mode) {
    if (term || description) {
      printf "    <!-- %s gl-%s:%s -->\n", code, module, term;
      if ("cen"==module) {
        printf "    <link:loc xlink:type=\"locator\" xlink:href=\"gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s%s\"/>\n", module, module, term, module, term, cksum;
      } else {
        printf "    <link:loc xlink:type=\"locator\" xlink:href=\"../%s/gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s%s\"/>\n", module, module, module, term, module, term, cksum;
      }
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
}' > gl/source/gl-cen-2020-12-31-label-en.xml

# 4. presentation
# seq code general level parent mode plt_parent module term ID label description p_term plt_term Card dataType
# 1   2    3       4     5      6    7          8      9    10 11    12          13     14       15   16
cat gl/source/cen.tsv | awk -F'\t' 'BEGIN {
  n=0;
  print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
  print "<!-- (c) XBRL Japan -->";
  print "<linkbase xmlns=\"http://www.xbrl.org/2003/linkbase\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd\">";
  print "  <presentationLink xlink:type=\"extended\" xlink:role=\"http://www.xbrl.org/2003/role/link\">";
}
{
  if (n>2) {
    seq=$1;
    code=$2;
    parent=$5;
    mode=$6;
    plt_parent=$7;
    module=$8;
    term=$9;
    p_term=$13;
    plt_term=$14;
    terms[code]=term;
    terms[parent]=p_term;
    terms[plt_parent]=plt_term;
    if ("src"==module) module="srcd";
    p_module=substr(parent, 1, 3);
    if ("src"==p_module) p_module="srcd";
    plt_module=substr(plt_parent, 1, 3);
    if ("src"==plt_module) plt_module="srcd";
    printf "    <!-- %s -->\n", term;
    # print seq " 1." code " 2." p_module " 3." parent " 4." plt_module " 5." plt_parent " 6." mode;
    if (1!=parents[parent] && ("a"==mode || "u"==mode)) {
      parents[parent]=1;
      printf "    <loc xlink:type=\"locator\" xlink:href=\"../../%s/gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s\" xlink:title=\"presentation parent: %s\"/>\n", p_module, p_module, p_module, terms[parent], p_module, terms[parent], terms[parent];
    }
    if (1!=parents[plt_parent] && "u"==mode) {
      parents[plt_parent]=1;
      printf "    <loc xlink:type=\"locator\" xlink:href=\"../../%s/gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s\" xlink:title=\"presentation parent: %s\"/>\n", plt_module, plt_module, plt_module, terms[plt_parent], plt_module, terms[plt_parent], terms[plt_parent];
    }
    if ((1!=parents[code] || 1!=children[code]) && ("a"==mode || "u"==mode)) {
      children[code]=1;
      printf "    <loc xlink:type=\"locator\" xlink:href=\"../../%s/gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s\" xlink:title=\"presentation child: %s\"/>\n", module, module, module, term, module, term, term;
    }
    if ("u"==mode) {
      if (plt_module && plt_parent && terms[plt_parent]) {
        printf "    <presentationArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/parent-child\" xlink:from=\"gl-%s_%s\" xlink:to=\"gl-%s_%s\" priority=\"1\" xlink:title=\"presentation: %s to %s\" use=\"prohibited\"/>\n", plt_module, terms[plt_parent], module, term, terms[plt_parent], term;
      }
      if (p_module && p_parent && terms[p_parent]) {
        printf "    <presentationArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/parent-child\" xlink:from=\"gl-%s_%s\" xlink:to=\"gl-%s_%s\" priority=\"2\" xlink:title=\"presentation: %s to %s\" use=\"optional\" order=\"%s\"/>\n", p_module, terms[p_parent], module, term, terms[p_parent], term, seq;
      }
    } else if ("a"==mode) {
      printf "    <presentationArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/parent-child\" xlink:from=\"gl-%s_%s\" xlink:to=\"gl-%s_%s\" priority=\"2\" xlink:title=\"presentation: %s to %s\" use=\"optional\" order=\"%s\"/>\n", p_module, terms[parent], module, term, terms[parent], term, seq;
    }
  }
  n=n+1;
}
END {
  print "  </presentationLink>";
  print "</linkbase>"; 
}' > gl/source/gl-plt-2020-12-31-presentation.xml

# --------------------------------------------------------------------
# rm $Tmp-*
# rm log/${0##*/}.$$.*
exit 0
# xBRL-GL2cen.sh
