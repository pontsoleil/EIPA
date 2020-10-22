#!/bin/sh
# === Initialize shell environment ===================================
set -eux
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
# === function =======================================================
error_exit() {
  if [[ "$@" == ERROR* ]]; then
    cat <<HTTP_RESPONSE
Content-Type: text/plain

$@
HTTP_RESPONSE
  else
    cat <<HTTP_RESPONSE
Content-Type: text/plain

ERROR $@
HTTP_RESPONSE
  fi
  exit 0
}
# session_
# user_id=$(is-login)
# === Login check ====================================================
user_info=$(is-login)
[ -n "$user_info" ] || error_exit 'NOT LOGGED IN'
user_id=$(echo "$user_info" | awk '{print $1}')
[[ "$user_id" == ERROR* ]] && error_exit "$user_info"
cgivars=$(echo "$user_info" | awk '{print $3}')
# === Check file directory ===========================================
datetime=$(date '+%Y-%m-%d_%H:%M:%S')
year=$(date '+%Y')
month=$(date '+%2m')
file_dir=$(nameread file data/environment | sed 's/^\"\(.*\)\"$/\1/'  |
sed "s/^\(\/.*\)\/\*\/\(.*\)$/\1\/${user_id}\/\2/"                    )
# === Upload directory ===============================================
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
# === Upload =========================================================
mime-read file $cgivars > $Tmp-uploadfile
filename=$(mime-read -v $cgivars                                       | # tee log/${0##*/}.$$.step1.log |
  grep -Ei '^[0-9]+[[:blank:]]*Content-Disposition:[[:blank:]]*form-data;' | # tee log/${0##*/}.$$.step2.log |
  grep '[[:blank:]]name="file"'                                            | # tee log/${0##*/}.$$.step3.log |
  head -n 1                                                                | # tee log/${0##*/}.$$.step4.log |
  sed 's/.*[[:blank:]]filename="\([^"]*\)".*/\1/'                          | # tee log/${0##*/}.$$.step5.log |
  sed 's/[[:space:]]/_/g')                                                 # escape space
#  tr '/"' '--')
contenttype=$(mime-read -v $cgivars                                    | # tee log/${0##*/}.$$.step6.log |
  grep -Ei '^[0-9]+[[:blank:]]*Content-Type:'                              | # tee log/${0##*/}.$$.step7.log |
  head -n 1                                                                | # tee log/${0##*/}.$$.step8.log |
  sed 's/.*[[:blank:]]*Content-Type:[[:blank:]]*\([[:blank:]]*\)/\1/') #   | # tee log/${0##*/}.$$.step9.log |
#  tr '"' '-')
fullname=$(mime-read fullname $cgivars)
filename=${file_dir}/${filename}
cp $Tmp-uploadfile $filename
# === Resource directory =============================================
uuid=$(uuidgen)
uuidrgx="[0-9a-f]\{8\}-[0-9a-f]\{4\}-[1-5][0-9a-f]\{3\}-[89ab][0-9a-f]\{3\}-[0-9a-f]\{12\}"
base_dir=$(nameread base data/environment | sed 's/^\"\(.*\)\"$/\1/')
escaped_base=$(echo $base_dir | sed 's/\//\\\//g')
# === resource =======================================================
resource_dir=$(nameread resource data/environment | sed 's/^\"\(.*\)\"$/\1/'  |
sed "s/^\(\/.*\)\/\*\/\(.*\)$/\1\/${user_id}\/\2/"                    )
if [ ! -d $resource_dir ]; then
  mkdir $resource_dir
fi
escaped_dir=$(echo $resource_dir | sed 's/\//\\\//g')
# check resource's directory
if [ ! -d $resource_dir ]; then
  mkdir $resource_dir
fi
resource_dir=${resource_dir}/${year}
if [ ! -d $resource_dir ]; then
  mkdir $resource_dir
fi
resource_dir=${resource_dir}/${month}
if [ ! -d $resource_dir ]; then
  mkdir $resource_dir
fi
resource_file=${resource_dir}/${uuid}
resource=$(echo ${resource_file} | sed "s/^${escaped_base}\/\(${uuidrgx}\)\/resource\/\(.*\)$/resource\/\1\/\2/")
# === thumbnail directory ============================================
thumbnail_dir=$(nameread thumbnail data/environment | sed 's/^\"\(.*\)\"$/\1/'  |
sed "s/^\(\/.*\)\/\*\/\(.*\)$/\1\/${user_id}\/\2/"                    )
if [ ! -d $thumbnail_dir ]; then
  mkdir $thumbnail_dir
fi
escaped_dir=$(echo $thumbnail_dir | sed 's/\//\\\//g')
# check thumbnail's directory
if [ ! -d $thumbnail_dir ]; then
  mkdir $thumbnail_dir
fi
thumbnail_dir=${thumbnail_dir}/${year}
if [ ! -d $thumbnail_dir ]; then
  mkdir $thumbnail_dir
fi
thumbnail_dir=${thumbnail_dir}/${month}
if [ ! -d $thumbnail_dir ]; then
  mkdir $thumbnail_dir
fi
_thumbnail=$(echo ${thumbnail_dir}\/${uuid}.jpg | sed "s/^${escaped_base}\/\(${uuidrgx}\)\/thumbnail\/\(.*\)$/thumbnail\/\1\/\2/")
# === check content type =============================================
content_type=$(file -b -i ${filename})
# thumbnail=""
if [[ $content_type == "application/pdf"* ]]; then
  thumbnail=${_thumbnail}
  iw=$(identify $filename[0] | sed -e "s/^[^[:blank:]]*[[:blank:]][^[:blank:]]*[[:blank:]]\([0-9]*\)x\([0-9]*\)[[:blank:]].*$/\1/")
  ih=$(identify $filename[0] | sed -e "s/^[^[:blank:]]*[[:blank:]][^[:blank:]]*[[:blank:]]\([0-9]*\)x\([0-9]*\)[[:blank:]].*$/\2/")
elif [[ $content_type == "image/"* ]]; then
  thumbnail=${_thumbnail}
  # === thumbnail ====================================================
  iw=$(identify $filename | sed -e "s/^[^[:blank:]]*[[:blank:]][^[:blank:]]*[[:blank:]]\([0-9]*\)x\([0-9]*\)[[:blank:]].*$/\1/")
  ih=$(identify $filename | sed -e "s/^[^[:blank:]]*[[:blank:]][^[:blank:]]*[[:blank:]]\([0-9]*\)x\([0-9]*\)[[:blank:]].*$/\2/")
else
  :
fi
if [[ $content_type == "application/pdf"* ]] ||
   [[ $content_type == "image/"* ]]; then
  size=200
  if [ -n "$iw" -a -n "$ih" ]; then
    if (($iw > $ih)) && (($iw > $size)); then
      w=$size
      h=$(echo "$ih*$size/$iw"|bc)
    elif (($ih > $iw)) && (($ih > $size)); then
      h=$size
      w=$(echo "$iw*$size/$ih"|bc)
    else
      w=$iw
      h=$ih
    fi
  else
    :
  fi
  # ImageMagick convert
  if [[ $content_type == "application/pdf"* ]]; then
    convert -thumbnail ${w}x${h} -background white -alpha remove $filename[0] ${thumbnail_dir}/${uuid}.jpg
  elif [[ $content_type == "image/"* ]]; then
    convert -define jpeg:size=${iw:-200}x${ih:-200} $filename  -auto-orient -thumbnail ${w}x${h} -unsharp 0x.5 ${thumbnail_dir}/${uuid}.jpg
  else
    :
  fi
else
  :
fi
# === Save resource ==================================================
uri=$(echo ${filename} | sed "s/^${escaped_base}\/\(${uuidrgx}\)\/content\/\(.*\)$/content\/\1\/\2/")
file=""
if [[ $content_type == "application/pdf"* ]]; then
  identify=$(identify ${filename}[0])
  file=$(ls -ghG ${filename})
elif [[ $content_type == "image/"* ]]; then
  identify=$(identify ${filename})
  file=$(file ${filename})
else
  identify=""
  file=$(ls -ghG ${filename})
fi
# resource_file
echo 'id' $uuid >> ${resource_file}
if [ -n "$fullname" ]; then
  name=${fullname}
else
  name=$(echo ${filename} | sed 's/^\(.*\)\/\([^\/]*\)$/\2/')
fi
# file stat
totalsize=$(stat -c %s ${filename})
lastmodified=$(stat -c %y ${filename})
# === resource file ==================================================
echo 'name' $name >> ${resource_file}
echo 'option' 'upload' >> ${resource_file}
echo 'contenttype' $contenttype >> ${resource_file}
echo 'uri' $uri >> ${resource_file}
echo 'value.totalsize' $totalsize >> ${resource_file}
echo 'value.lastmodified' $lastmodified >> ${resource_file}
echo 'value.commment null' >> ${resource_file}
if [[ $content_type == "application/pdf"* ]] ||
   [[ $content_type == "image/"* ]]; then
  echo 'value.resource.uri' ${resource} >> ${resource_file}
  echo 'value.resource.size' ${iw}x${ih} >> ${resource_file}
  echo 'value.thumbnail.uri' ${thumbnail} >> ${resource_file}
  echo 'value.thumbnail.size' ${w}x${h} >> ${resource_file}
  echo 'value.identify' $identify >> ${resource_file}
  echo 'value.file' $file >> ${resource_file}
else
  echo 'value.resource.uri' ${resource} >> ${resource_file}
  echo 'value.resource.size null' >> ${resource_file}
  echo 'value.thumbnail.uri null' >> ${resource_file}
  echo 'value.thumbnail.size null' >> ${resource_file}
  echo 'value.identify null' >> ${resource_file}
  echo 'value.file' $file >> ${resource_file}
fi
# === Return result ==================================================
if [[ $content_type == "application/pdf"* ]] ||
   [[ $content_type == "image/"* ]]; then
  cat <<HTML_CONTENT
Content-Type: application/json

{
  "id":"${uuid}",
  "name":"${name}",
  "option":"upload",
  "contenttype":"${contenttype}",
  "uri":"${uri}",
  "value":{
    "totalsize":"${totalsize}",
    "lastmodified":"${lastmodified}",
    "resource":{"uri":"${resource}","size":"${iw}x${ih}"},
    "thumbnail":{"uri":"${thumbnail}","size":"${w}x${h}"},
    "file":"${file}",
    "identify":"${identify}"
  }
}
HTML_CONTENT
else
  # === Return result ==================================================
  cat <<HTML_CONTENT
Content-Type: application/json

{
  "id":"${uuid}",
  "name":"${name}",
  "option":"upload",
  "contenttype":"${contenttype}",
  "uri":"${uri}",
  "value":{
    "totalsize":"${totalsize}",
    "lastmodified":"${lastmodified}",
    "resource":{"uri":"${resource}"},
    "file":"${file}",
    "identify":"${identify}"
  }
}
HTML_CONTENT
fi
# rm -f $Tmp-*
exit 0
# upload.cgi
