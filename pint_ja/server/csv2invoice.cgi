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
# --- 0)各種定義 -----------------------------------------------------
Dir_MINE="$(d=${0%/*}/; [ "_$d" = "_$0/" ] && d='./'; cd "$d"; pwd)"
Dir_SESSION="$Dir_MINE/SESSIONS" # セッションファイル置き場
Tmp=/tmp/tmp.$$                  # テンポラリーファイルの基本名定義
SESSION_LIFETIME=600             # セッションの有効期限(10分)
COOKIE_LIFETIME=7200             # Cookieの有効期限(120分)
export PATH="$(command -p getconf PATH):${PATH:-}"
# --- 1)CookieからセッションIDを読み取る -----------------------------
session_id=$(printf '%s' "${HTTP_COOKIE:-}"                      |
             sed 's/&/%26/g; s/[;, ]\{1,\}/\&/g; s/^&//; s/&$//' |
             cgi-name                                            |
             nameread session_id )
# --- 2)セッションIDの有効性検査 -------------------------------------
session_status='new' # デフォルトは「要新規作成」とする
while :; do
  # --- 古いセッションファイルは消しておく
  touch -t $(date '+%Y%m%d%H%M%S'                  |
             utconv                                |
             awk "{print \$1-$SESSION_LIFETIME-1}" |
             utconv -r                             |
             awk 'sub(/..$/,".&")'                 ) $Tmp-session_expire
  find "$Dir_SESSION" \( \! -newer $Tmp-session_expire \) | xargs rm -f
  # --- セッションID文字列がない or 不正な書式なら「新規作成」判定
  printf '%s' "$session_id" | grep -q '^[A-Za-z0-9]\{16\}$' || break
  # --- セッションID文字列で指定されたファイルが存在しないなら「期限切れ」判定
  [ -f "$Dir_SESSION/$session_id" ] || { session_status='expired'; break; }
  # --- これらの検査に全て合格したら使う
  session_status='exist'
  break
done
# --- 3)セッションファイルの確保(あれば延命、なければ新規作成) -------
case $session_status in
  exist) File_session=$Dir_SESSION/$session_id
         touch "$File_session";;                              # セッションを延命する
  *)     mkdir -p $Dir_SESSION
         File_session=$(mktemp $Dir_SESSION/XXXXXXXXXXXXXXXX)
         [ $? -eq 0 ] || { echo 'cannot create session file' 1>&2; exit; }
         session_id=${File_session##*/};;
esac
# --- 4)-1セッションファイル読み込み ---------------------------------
msg=$(cat "$File_session")
case "${msg}${session_status}" in
  new)     msg="はじめまして! セッションを作りました。(ID=$session_id)";;
  expired) msg="セッションの有効期限が切れたので、作り直しました。(ID=$session_id)";;
esac
# --- 4)-2セッションファイル書き込み ---------------------------------
printf '最終訪問日時は、%04d年%02d月%02d日%02d時%02d分%02d秒です。(ID=%s)' \
       $(date '+%Y %m %d %H %M %S') "$session_id" \
       > "$File_session"
# --- 5)Cookieを焼く -------------------------------------------------
cookie_str=$(echo "session_id ${session_id}"                          |
             "$Dir_MINE/mkcookie" -e+${COOKIE_LIFETIME} -p / -s A -h Y)
# === Upload directory ===============================================
# uuid=$(uuidgen)
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
# file_dir=${file_dir}/${uuid}
file_dir=${file_dir}/${session_id}
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
# csv2invoice.cgi
