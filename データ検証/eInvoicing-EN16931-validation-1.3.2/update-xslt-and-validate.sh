# !/bin/sh
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

echo 'preprocess first - catches errors quickers'
mvn -f pom-preprocess.xml generate-resources 2>&1 || result=$?
if [ ! "$result" = "0" ]; then
  echo >&2 'ERROR preprocess'
  exit 1
fi

echo 'convert to XSLT - takes forever'
mvn -f pom-xslt.xml process-resources 2>&1 || result=$?
if [ ! "$result" = "0" ]; then
  echo >&2 'ERROR convert'
  exit 1
fi

echo 'Add license headers to all relevant files'
mvn -f pom-license.xml license:format 2>&1 || result=$?
if [ ! "$result" = "0" ]; then
  echo >&2 'ERROR add license'
  exit 1
fi

echo 'validate afterwards'
mvn -f pom-validate.xml validate 2>&1 || result=$?
if [ ! "$result" = "0" ]; then
  echo >&2 'ERROR validate'
  exit 1
fi

rm $Tmp*
exit 0