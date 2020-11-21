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
# 1. cen.tsv
# seq code general level module term ID label description Card dataType
# 1   2    3       4     5      6    7   8    9           10   11
cat gl/source/cen.tsv | awk -F'\t' 'BEGIN {
  n=0;
  printf "\n  <!-- item -->\n";
}
{
  module=$5;
  if (n>0 && "cen"==module) {
    code=$2;
    term=$6;
    type=$11;
    # printf " %s %s %s %s\n", code, module, term, type;
    if (""==$11) {
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
# seq code general level module term ID label description Card dataType
# 1   2    3       4     5      6    7   8    9           10   11
# see https://stackoverflow.com/questions/8024392/awk-replace-a-column-with-its-hash-value
# copy field to XBRL-GL.xlsx to create xBRL-GL.tsv
cat gl/source/cen.tsv | awk -F'\t' 'BEGIN {
  n=0;
}
{
  if (n>0) {
    tmp="echo " $4 date " | openssl md5 | cut -f2 -d\" \"";
    tmp | getline cksum;
    close(tmp);
    print cksum "\t" $0;
  }
  n=n+1;
}' > $Tmp-cksum

# 3. label
# cksum seq code general level module term ID label description Card dataType
# 1     2   3    4       5     6      7    8  9     10          11   12
cat $Tmp-cksum | awk -F'\t' 'BEGIN {
  printf "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
  printf "<link:linkbase xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"";
  printf "  xmlns:link=\"http://www.xbrl.org/2003/linkbase\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"";
  printf "  xsi:schemaLocation=\"http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd\">";
  printf "  <link:labelLink xlink:type=\"extended\" xlink:role=\"http://www.xbrl.org/2003/role/link\">\n";
}
{
  module=$6
  code=$3;
  cksum="_" $1;
  term=$7;
  label=$9;
  description=$10;
  lang="en";
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
END {
  printf " </link:labelLink>\n";
  printf "</link:linkbase>";
}' > gl/source/gl-cen-2020-12-31-label-en.xml

# 4. xBRL-GL.tsv
# code seq level module term type label description label-ja description-ja
# 1    2   3     4      5    6    7     8           9        10
cat gl/source/xBRL-GL.tsv | awk -F'\t' 'BEGIN {
  n=0;
}
{
  if (n>0) {
    seq=$2;
    code=$1;
    level=$3;
    module=$4;
    term=$5;
    terms[code]=term;
    currents[level]=code;
    if (1 == level) {
      parent="root";
    }
    else {
      parent=currents[level - 1];
    }
    if (level < current_level) {
      for (i = level + 1; i < 10; i++) {
        currents[i]="";
      }
    }
    current_level=level;
    p_module=substr(parent, 1, 3);
    if ("src"==p_module) p_module="srcd";
    print code " " parent " " terms[code] " " terms[parent] " " seq;
  }
  n=n+1;
}' | sort > $Tmp-xBRL-GL_parent_child

# 5. cen.tsv
# seq code general level module term ID BT Card path SemanticDataType dataType
# 1   2    3       4     5      6    7  8  9    10   11               12
cat gl/source/cen.tsv | awk -F'\t' 'BEGIN {
  n=0;
}
{
  if (n>0) {
    seq=$1;
    code=$2;
    level=$4;
    module=$5;
    term=$6;
    terms[code]=term;
    currents[level]=code;
    if (1 == level) {
      parent="root";
    } else {
      parent=currents[level - 1];
    }
    if (level < current_level) {
      for (i = level + 1; i < 10; i++) {
        currents[i]="";
      }
    }
    current_level=level;
    p_module=substr(parent, 1, 3);
    if ("src"==p_module) p_module="srcd";
    print code " " parent " " terms[code] " " terms[parent] " " seq;
  }
  n=n+1;
}' | sort > $Tmp-plt_parent_child

# 6. join
# join $Tmp-plt_parent_child $Tmp-xBRL-GL_parent_child > $Tmp-step1
# cat $Tmp-step1 | awk '{if ($2!=$6) { print $0 }}' >  $Tmp-step2
# cat $Tmp-step2 | awk 'a !~ $0; {a=$0}' | awk '{ print $0 " u"}' > $Tmp-palette
# comm -23 $Tmp-plt_parent_child $Tmp-xBRL-GL_parent_child |
# awk '{ print $0 " _ _ _ _ a"}' >> $Tmp-palette

# 7.
# x-nn xG-pp  xxxx zzzz   mmm yG-qq      yyyy ttt      nnn     u
# code parent term p_term seq plt_parent term plt_term plt_seq mode
# 1    2      3    4      5   6          7    8        9       10
cat $Tmp-palette | awk 'BEGIN {
  print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
  print "<!-- (c) XBRL Japan -->";
  print "<linkbase xmlns=\"http://www.xbrl.org/2003/linkbase\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd\">";
  print "  <presentationLink xlink:type=\"extended\" xlink:role=\"http://www.xbrl.org/2003/role/link\">";
}
{
  code=$1;
  parent=$2;
  term=$3;
  p_term=$4;
  seq=$5;
  plt_parent=$6;
  plt_term=$8;
  plt_seq=$9;
  mode=$10;
  terms[code]=term;
  terms[parent]=p_term;
  terms[plt_parent]=plt_term;
  module=substr(code, 1, 3);
  if ("src"==module) module="srcd";
  p_module=substr(parent, 1, 3);
  if ("src"==p_module) p_module="srcd";
  plt_module=substr(plt_parent, 1, 3);
  if ("src"==plt_module) plt_module="srcd";
  printf "    <!-- %s -->\n", term;
  # print seq " 1." code " 2." p_module " 3." parent " 4." plt_module " 5." plt_parent " 6." mode;
  if (1!=parents[parent]) {
    parents[parent]=1;
    printf "    <loc xlink:type=\"locator\" xlink:href=\"../../%s/gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s\" xlink:title=\"presentation parent: %s\"/>\n", p_module, p_module, p_module, terms[parent], p_module, terms[parent], terms[parent];
  }
  if (1!=parents[plt_parent]) {
    parents[plt_parent]=1;
    printf "    <loc xlink:type=\"locator\" xlink:href=\"../../%s/gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s\" xlink:title=\"presentation parent: %s\"/>\n", plt_module, plt_module, plt_module, terms[plt_parent], plt_module, terms[plt_parent], terms[plt_parent];
  }
  if (1!=parents[code] || 1!=children[code]) {
    children[code]=1;
    printf "    <loc xlink:type=\"locator\" xlink:href=\"../../%s/gl-%s-2020-12-31.xsd#gl-%s_%s\" xlink:label=\"gl-%s_%s\" xlink:title=\"presentation child: %s\"/>\n", module, module, module, term, module, term, term;
  }
  if ("u"==mode) {
    printf "    <presentationArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/parent-child\" xlink:from=\"gl-%s_%s\" xlink:to=\"gl-%s_%s\" priority=\"1\" xlink:title=\"presentation: %s to %s\" use=\"prohibited\"/>\n", p_module, terms[parent], module, term, terms[parent], term, seq;
    # printf "    <presentationArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/parent-child\" xlink:from=\"gl-%s_%s\" xlink:to=\"gl-%s_%s\" priority=\"2\" xlink:title=\"presentation: %s to %s\" use=\"optional\" order=\"%s\"/>\n", plt_module, terms[plt_parent], module, term, terms[plt_parent], term, seq;
  } else if ("a"==mode) {
    printf "    <presentationArc xlink:type=\"arc\" xlink:arcrole=\"http://www.xbrl.org/2003/arcrole/parent-child\" xlink:from=\"gl-%s_%s\" xlink:to=\"gl-%s_%s\" priority=\"2\" xlink:title=\"presentation: %s to %s\" use=\"optional\" order=\"%s\"/>\n", p_module, terms[parent], module, term, terms[parent], term, seq;
  }
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
