#!/bin/sh -xv
echo "Content-type: text/plain"
echo
# === Initialize shell environment ===================================
set -u # identify cause error on some pdf file. so drop -e
# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
# -v  Print shell input lines as they are read.
# -x  Print commands and their arguments as they are executed.
export LC_ALL=C
type command >/dev/null 2>&1 && type getconf >/dev/null 2>&1 &&
export PATH=".:./bin:$(command -p getconf PATH)${PATH+:}${PATH-}"
export UNIX_STD=2003  # to make HP-UX conform to POSIX
Tmp=/tmp/${0##*/}.$$
# === Log ============================================================
exec 2>log/${0##*/}.$$.error.log
# === Upload directory ===============================================
# datetime=$(date '+%Y-%m-%d_%H:%M:%S')
year=$(date '+%Y')
month=$(date '+%2m')
file_dir='data'
if [ ! -d $file_dir ]; then
  mkdir $file_dir
fi
# check file's directory
if [ ! -d $file_dir ]; then
  mkdir $file_dir
fi
file_dir=${file_dir}/${year}
if [ ! -d $file_dir ]; then
  mkdir $file_dir
fi
file_dir=${file_dir}/${month}
if [ ! -d $file_dir ]; then
  mkdir $file_dir
fi
uuid=$(uuidgen)
file_dir=${file_dir}/${uuid}
if [ ! -d $file_dir ]; then
  mkdir $file_dir
fi
escaped_dir=$(echo $file_dir | sed 's/\//\\\//g')
# === Upload =========================================================
dd bs=${CONTENT_LENGTH:-0} count=1 > $Tmp-cgivars
mime-read file $Tmp-cgivars        > $Tmp-uploadfile
name=$(mime-read -v $Tmp-cgivars                                         | # tee log/${0##*/}.$$.step1.log |
grep -Ei '^[0-9]+[[:blank:]]*Content-Disposition:[[:blank:]]*form-data;' | # tee log/${0##*/}.$$.step2.log |
grep '[[:blank:]]name="file"'                                            | # tee log/${0##*/}.$$.step3.log |
head -n 1                                                                | # tee log/${0##*/}.$$.step4.log |
sed 's/.*[[:blank:]]filename="\([^"]*\)".*/\1/'                          | # tee log/${0##*/}.$$.step5.log |
sed 's/[[:space:]]/_/g')                                                 # escape space
filename=${file_dir}/${name}
cp $Tmp-uploadfile ${filename}
basename=${filename:0:-4}
encode=$(mime-read encode $Tmp-cgivars)
# === Validate Invoice ===============================================
cat validate/Basic-validate.xml | sed -e "s/_examples_/$escaped_dir/g" > validate/Basic-validate.$$.xml
cat validate/pint-validate.xml | sed -e "s/_examples_/$escaped_dir/g" > validate/pint-validate.$$.xml
cat validate/jp-validate.xml | sed -e "s/_examples_/$escaped_dir/g" > validate/jp-validate.$$.xml

mvn -f validate/Basic-validate.$$.xml validate
mvn -f validate/pint-validate.$$.xml validate
mvn -f validate/jp-validate.$$.xml validate

rm -f $Tmp-*
rm validate/jp-pint-validate.$$.xml
rm log/${0##*/}.$$.*
exit 0
# validate.cgi
