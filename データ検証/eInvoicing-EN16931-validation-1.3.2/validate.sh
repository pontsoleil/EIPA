#!/bin/sh
# === Initialize shell environment ===================================
set -eux
# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
# -v  Print shell input lines as they are read.
# -x  Print commands and their arguments as they are executed.
export LC_ALL=C
Tmp=/tmp/${0##*/}.$$
# === Log ============================================================
exec 2>$Tmp.log

result=0
# echo 'validate afterwards'
mvn -f pom-validate.xml validate 2>&1 || result=$?
if [ ! "$result" = "0" ]; then
  echo >&2 'ERROR validate'
  exit 1
fi

rm $Tmp*
exit 0