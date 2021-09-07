#!/bin/sh
# === Initialize shell environment ===================================
set -e
# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
# -v  Print shell input lines as they are read.
# -x  Print commands and their arguments as they are executed.
export LC_ALL=C
type command >/dev/null 2>&1 && type getconf >/dev/null 2>&1 &&
export PATH=".:./bin:$(command -p getconf PATH)${PATH+:}${PATH-}"
export UNIX_STD=2003  # to make HP-UX conform to POSIX
# escape space
VT=$( printf '\v' )
# === temporary file prefix ==========================================
Tmp=/tmp/${0##*/}.$$
# === Log ============================================================
exec 2>log/${0##*/}.$$.log
# --------------------------------------------------------------------
rm -f origin.sambuichi.jp_access.log
if [ -n "$1" ]; then
  sudo cp -f /var/log/nginx/origin.sambuichi.jp_access.log-2021$1.gz origin.sambuichi.jp_access.log.gz
  gunzip origin.sambuichi.jp_access.log.gz
  rm -f origin.sambuichi.jp_access.log.gz
else
  sudo cp /var/log/nginx/origin.sambuichi.jp_access.log .
fi
cat origin.sambuichi.jp_access.log|
grep /jp_pint/billing-japan/|
grep -E "(semantic|syntax|rules)"|
grep -v main|grep -v font-awesome|
awk -F' ' '{ print $7 }'|
awk -F' ' -v day="$1" '{
  rx = "^.*\/jp_pint\/billing-japan\/([^\/]+\/([^\/]+)?).*(en|ja)\/?(index.html)?";
  name = gensub(rx, "\\1", 1, $0);
  lang = gensub(rx, "\\3", 1, $0);
  print day " " name " " lang
}'|sort|uniq -c|sort -nr
# --------------------------------------------------------------------
rm $Tmp-*
rm log/${0##*/}.$$.*
exit 0
# nginx_log.sh