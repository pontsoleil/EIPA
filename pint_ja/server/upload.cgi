#!/bin/sh
# === Initialize shell environment ===================================
set -ux # identify cause error on some pdf file. so drop -e
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
exec 2>log/${0##*/}.$$.log
# === Check file directory ===========================================
datetime=$(date '+%Y-%m-%d_%H:%M:%S')
year=$(date '+%Y')
month=$(date '+%2m')
# === Upload directory ===============================================
uuid=$(uuidgen)
file_dir='data'
if [ ! -d $file_dir ]; then
  mkdir $file_dir
fi
escaped_dir=$(echo $file_dir | sed 's/\//\\\//g')
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
file_dir=${file_dir}/${uuid}
if [ ! -d $file_dir ]; then
  mkdir $file_dir
fi
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
# === Generate Invoice ===============================================
xmlfile=${basename}.xml
./csv2invoice ${filename} -o ${xmlfile} -e ${encode}
# === XSLT ===========================================================
htmlfile=${basename}.html
java -jar saxon-he-10.6.jar -o:${htmlfile} ${xmlfile} stylesheet-ubl.xslt
# === Generate <table> ===============================================
tablefile=${basename}_table.html
./csv2html ${filename} -o ${tablefile} -e ${encode}
# === Return result ==================================================
cat <<HTML_CONTENT
Content-Type: application/json

{"html":"${htmlfile}","xml":"${xmlfile}","table":"${tablefile}","name":"${name:0:-4}"}
HTML_CONTENT
rm -f $Tmp-*
exit 0
# upload.cgi
