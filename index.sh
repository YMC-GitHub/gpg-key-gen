#!/usr/bin/env bash

zero_app_nsh="./`basename $0`"

zero_app_msg_usage="
{{HELP_MSG}}
"
zero_app_msg_version="{ns} version 1.0.0"

# zero:task:s:get-project-dir-and-other
ZERO_THIS_FILE_PATH_REL="./"
ZERO_THIS_FILE_PATH=$(cd $(dirname $0);pwd)
ZERO_THIS_FILE_NAME=$(basename $0)
[ -z "$ZERO_RUN_SCRIPT_PATH" ] && ZERO_RUN_SCRIPT_PATH=$(pwd)
ZERO_THIS_FILE_PROJECT_PATH=$(cd "$ZERO_THIS_FILE_PATH";cd "$ZERO_THIS_FILE_PATH_REL" ;pwd)
# zero:task:e:get-project-dir-and-other


#zero:task:s:load-help-msg-for-url
# ./help.md,~/help.md,thiscript/help.md,--url
# zero_app_msg_usage_loaded=1
function zero_app_check_msg_usage_loaded(){
    echo "$zero_app_msg_usage" | grep "{{HELP_MSG}}" > /dev/null 2>&1 ;
    # [ $? -ne 0 ] && zero_app_msg_usage_loaded=0
}
 
# if you do no like loading from zero_app_msg_current_dir_url,skip it.
zero_app_msg_current_dir_url=$ZERO_THIS_FILE_PROJECT_PATH"/lang/en/help.txt"
zero_app_check_msg_usage_loaded ; [ $? -eq 0 ] && [ -e "$zero_app_msg_current_dir_url" ] && zero_app_msg_usage=`cat "$zero_app_msg_current_dir_url"`
 
# if you do no like loading from zero_app_msg_user_dir_url,skip it.
zero_app_msg_user_dir_url=~./help.txt
zero_app_check_msg_usage_loaded ; [ $? -eq 0 ] && [ -e "$zero_app_msg_user_dir_url" ] && zero_app_msg_usage=`cat "$zero_app_msg_user_dir_url"`
 
# if you do no like loading from url,skip it.
zero_app_msg_remote_url=https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/gpg-key-gen/main/lang/en/help.txt
zero_app_check_msg_usage_loaded ; [ $? -eq 0 ] && zero_app_msg_remote=`curl -sfL $zero_app_msg_remote_url` && zero_app_msg_usage=$zero_app_msg_remote
#zero:task:e:load-help-msg-for-url


#zero:task:s:get space md5
zero_const_space_md5=`echo -n " " | md5sum | cut -b -32`
zero_const_comma_md5=`echo -n "," | md5sum | cut -b -32`
#zero:task:e:get space md5


# zero:task:s:render-msg-tpl
# zero_app_msg_usage=`echo "$zero_app_msg_usage" | sed "s,{ns},$zero_app_nsh,g"`
# zero_app_msg_version=`echo "$zero_app_msg_version" | sed "s,{ns},$zero_app_nsh,g"`

function render_tpl(){
    tpl=topic/today/email
    [ -n "$1" ] && tpl=$1
    [ -n "$2" ] && key=$2
    [ -n "$3" ] && val=$3
    if [ $key ] ; then
        echo "$tpl" | sed "s/$key/$val/g"
    else
        echo "$tpl"
    fi
}

function zero_app_render_msg_tpl(){
    tpl="$1"
    key="$2"
    val="$3"
    echo "$tpl" | sed "s,{ns},$val,g"
}
zero_app_msg_usage=`zero_app_render_msg_tpl "$zero_app_msg_usage" "{ns}" "$zero_app_nsh"`
zero_app_msg_version=`zero_app_render_msg_tpl "$zero_app_msg_version" "{ns}" "$zero_app_msg_version"`
# zero:task:e:render-msg-tpl

zero_app_sarg=""
zero_app_larg=""

zero_app_subns=""
zero_app_subcmd=""
zero_app_cmd=""

# zero:task:s:extraxt-subns-and-subcmd
# ./index.sh <subns> <command> [option]
# ./index.sh <command> [option]
function zero_app_extract_subcmd(){
    zero_app_subns=$1 ; zero_app_subcmd=$2; zero_app_cmd=$1; shift 2;
}
# usage:
# zero_app_extract_subcmd $@
# zero_app_extract_subcmd $@ ; shift 2;

# debug:
# echo "$@"
# zero_app_extract_subcmd $@ ; shift 2;
# echo "$zero_app_subns $zero_app_subcmd $zero_app_cmd"
# echo "$@"
# exit 0
# zero:task:e:extraxt-subns-and-subcmd


# zero:task:s:extraxt-cmd
# if you do not like it,skip.
# ./index.sh <command> [option]
function zero_app_extract_cmd(){
    zero_app_cmd=$1; shift 1;
}
# usage:
# zero_app_extract_cmd $@
# zero_app_extract_cmd $@ ; shift 1;

# debug:
# echo "$@"
# # zero_app_extract_cmd $@
# zero_app_extract_cmd $@ ; shift 1;
# echo "$@"
# echo $zero_app_cmd
# exit 0
# zero:task:e:extraxt-cmd



function zero_app_lst_var_name_by_prefix(){
valn="GPG"
[ "$1" ] && valn=$1
vars_code="echo \${!$valn*}"
# eval $vars_code
vars=(`eval $vars_code`)
# vars=(`echo ${!GPG*}`)
for s in ${vars[@]}
do
    echo $s
done
}
# usage:
# zero_app_lst_var_name_by_prefix "zero_"
# zero_app_lst_var_name_by_prefix "GPG_"

function zero_app_lst_var_value_by_prefix(){
valn="GPG"
[ "$1" ] && valn=$1
vars_code="echo \${!$valn*}"
# eval $vars_code
vars=(`eval $vars_code`)
# vars=(`echo ${!GPG*}`)
for s in ${vars[@]}
do
    v="echo \$$s"
    v=`eval $v`
    echo "$s=$v"
done
}
# usage:
# zero_app_lst_var_value_by_prefix "zero_"
# zero_app_lst_var_value_by_prefix "GPG_"

# var lst -h

function zero_str_join(){
    # echo "$@"

    # a b c
    c=""
    a=$1
    b=$2
    d=""
    [ -n "$3" ] && c=$3
    [ -n "$4" ] && d=$4

    [ $b ] && {
        if [ $a ] ; then
            echo ${a}${c}${b}${d}
        else
            echo ${b}${d}
        fi 
        return 0
    }
    echo $a
}


function zero_app_getopt_opts_def(){
    o=$(echo $1 | sed -E "s/ -- +.*//g")
    o=$(echo $o | sed -E "s/^ +//g")
    o=$(echo $o | sed -E "s/-+//g")
    o=$(echo $o | sed -E "s/,+/ /g")
    # echo $o
    oa=(${o// / })
    # echo $o
    # echo ${oa[0]}
    # echo ${oa[1]}
    # echo ${oa[2]}

    # zero_app_sarg=$(zero_str_join "$zero_app_sarg" ${oa[0]} "" ":")
    # zero_app_larg=$(zero_str_join "$zero_app_larg" ${oa[1]} ", ":")


    os=${oa[0]}
    ol=${oa[1]}
    ot=${oa[2]}
    # eg. nc,<value>
    [ -z $ot ] && {
        ot=$ol
    }

    # eg. os is --eml
    [ $os ] && {
        [ ${#os} -ne 1 ] && { ol=$os; os=""; }
    }

    
    # echo $os,$ol,$ot

    if [[ $ot =~ "]" ]];then
        #  echo ${oa[0]}
        zero_app_sarg=$(zero_str_join "$zero_app_sarg" $os "" ":")
        zero_app_larg=$(zero_str_join "$zero_app_larg" $ol "," ":")
    elif [[ $ot =~ ">" ]];then
        # echo ${oa[0]}
        zero_app_sarg=$(zero_str_join "$zero_app_sarg" $os "" "::")
        zero_app_larg=$(zero_str_join "$zero_app_larg" $ol "," "::")
    else
        # echo ${oa[0]}
        zero_app_sarg=$(zero_str_join "$zero_app_sarg" $os "")
        zero_app_larg=$(zero_str_join "$zero_app_larg" $ol ",")
    fi

}
# zero_app_getopt_opts_def "-h,--help -- info help usage"
# zero_app_getopt_opts_def '-v,--version -- info version'
# zero_app_getopt_opts_def "-p,--preset [value] -- use some preset"
# zero_app_getopt_opts_def "--hubs <value> -- set hub url list. multi one will split with , char"
# zero_app_getopt_opts_def "--eml <value> -- set email list. multi one will split with , char"


function zero_app_getopt_opts_use(){

# zero_const_space_md5=$2

opts="$1"
space_md5=$2
space=$3

opts=`echo "$opts" | sed "s/$space/$space_md5/g" `
# echo "$options"
array=(`echo "$opts"` )

id=0
for line in ${array[@]}
do
if [ "$line" ]; then
    vline=`echo "$line" | sed "s/$space_md5/$space/g" `
    zero_app_getopt_opts_def "$vline"

    #  echo "$ld:$vline"
    # # echo "$ld:$line"
    # ld=$(($ld + 1))
fi
done 

# echo $ld
# echo "args:"
# echo $zero_app_sarg
# echo $zero_app_larg

}

# options="
# -h,--help -- info help usage
# -v,--version -- info version
# -p,--preset [value] -- use some preset
# --hubs <value> -- set hub url list. multi one will split with , char
# --eml <value> -- set email list. multi one will split with , char
# "

# zero_app_getopt_opts_use "$options" "$zero_const_space_md5" " "



function zero_app_getopt_opts_get(){

# zero_const_space_md5=$2

opts="$1"
space_md5=$2
space=$3

opts=`echo "$opts" | sed "s/$space/$space_md5/g" `
opts=`echo "$opts" |sed '/^$/d' `

# echo "$options"
array=(`echo "$opts"` )

idf=`echo "$opts" | grep -n 'options' | cut -d ':' -f1`
idf=$(($idf + 0))
# echo $idf
id=0


# for line in ${array[@]}
for id in "${!array[@]}"
do
line=${array[$id]}
# echo "$id$line" | sed "s/$space_md5/$space/g"
if [ "$line" ]; then
    # echo $id
    if [ $id -ge $idf ] ; then
        # echo $id
        echo "$line" | sed "s/$space_md5/$space/g"
    fi 
    # id=$(($id + 1))
fi
done 
}
# options=`zero_app_getopt_opts_get "$zero_app_msg_usage" "$zero_const_space_md5" " "`

function zero_app_getopt_opts_out(){
    echo "args:(getopt)"
    # echo $zero_app_sarg
    # echo $zero_app_larg
    echo "-o $zero_app_sarg --long $zero_app_larg"
    # exit 0
}

function zero_app_dbg_getopts()
{
    local opt_ab
    while getopts "ab" opt_ab; do
        # funname,index,key
        echo $FUNCNAME: $OPTIND: $opt_ab
    done
}

# zero_app_dbg_getopts "-a" "-b"
# OPTIND=1
# $OPTARG

#zero:task:s:out-cli-version
function zero_app_out_version(){
   echo "$zero_app_msg_version";
   exit 0 
}
# out version when the arg1 is -v or --version
# if you do not like it, skip.
# if [ $1"_" = "version_" ];then
#     zero_app_out_version
# fi
case "$1" in
    -v|--version)
        zero_app_out_version
    ;;
esac
#zero:task:e:out-cli-version

#zero:task:s:out-usage
function zero_app_out_usage(){
    echo "$zero_app_msg_usage";
    exit 0
}
# out usage when the args length ne 1
# if you do not like it, skip.
# if [ $# -ne 1 ];then
#     zero_app_out_usage
# fi

# out usage when the arg1 is -h or --help
# if you do not like it, skip.
# if [[ $1"_" = "help_" ]] || [[ $1"_" = "-h_" ]];then
#    zero_app_out_usage
# fi
case "$1" in
    -h|--help)
        zero_app_out_usage
    ;;
esac
#zero:task:e:out-usage



# [getopt-and-getopts](https://zhuanlan.zhihu.com/p/113837365)


#zero:task:s:out-usage-uc3

# https://unix.stackexchange.com/questions/628942/bash-script-with-optional-input-arguments-using-getopt



#zero:task:s:define-cli-option
options=`zero_app_getopt_opts_get "$zero_app_msg_usage" "$zero_const_space_md5" " "`
# echo "$options"
#zero:task:e:define-cli-option

#zero:task:s:gen-getopt-option
zero_app_getopt_opts_use "$options" "$zero_const_space_md5" " "
# zero_app_getopt_opts_out
# exit 0
#zero:task:e:gen-getopt-option
# zero:task:s:extraxt-subns-and-subcm
zero_app_extract_subcmd $@ ; shift 2;
# zero:task:e:extraxt-subns-and-subcmd


#zero:task:s:set-default-value
GPG_KEY_LENGTH=2048
GPG_KEY_TYPE=RSA
GPG_KEY_EXP=0 # eg:365|12m|1y
GPG_USER_NAME=yemiancheng
GPG_USER_NOTE=ymc-github
GPG_USER_EMAIL=ymc.github@gmail.com
GPG_USER_ID= # will be gen
GPG_KEY_PATH=~/.gnupg
GPG_PASSPHRASE=yemiancheng123
# gpg_var_cal
#GPG_PUB_KEY_SERVER="hkp://subkeys.pgp.net"
#GPG_PUB_KEY_SERVER=hkp://p80.pool.sks-keyservers.net:80
GPG_PUB_KEY_SERVER=hkp://ipv4.pool.sks-keyservers.net
#GPG_PUB_KEY_SERVER=hkp://pgp.mit.edu:80

# [encode]
GPG_ENCODE_FILE_NAME=SHASUMS256
GPG_ENCODE_FILE_SUFFIX="txt"
# [decode]
GPG_DECODE_FILE_NAME=SHASUMS256
GPG_DECODE_FILE_SUFFIX="txt"
# [sign]
GPG_SIGN_FILE_NAME=SHASUMS256
GPG_SIGN_FILE_SUFFIX=txt
GPG_SIGN_FILE_TYPE=txt

# inputdir=~/.gnupg
# outputdir=~/.gnupg
# password=""
# topic="github"
# today=`date +'%Y%m%d'`
dryrun=1
#zero:task:e:set-default-value

vars=$(getopt -o $zero_app_sarg --long $zero_app_larg -- "$@")
eval set -- "$vars"

#zero:task:s:bind-scr-level-args-value
function zero_app_fix_val(){
    if [[ $1 =~ "--" ]] ;then
        #  "--name"
        echo ${2}
    else
        # "-n"
        echo ${2:1}
    fi
}
# extract options and their arguments into variables.
for opt; do
    case "$opt" in
      -n|--name)
        GPG_USER_NAME=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;
      -e|--email)
        GPG_USER_EMAIL=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;
      -p|--passphrase)
        GPG_PASSPHRASE=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;
      --nc)
        GPG_USER_NOTE=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;
      --keypath)
        GPG_KEY_PATH=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;
      --keytype)
        GPG_KEY_TYPE=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;
      --keylength)
        GPG_KEY_LENGTH=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;
      --keyexp)
        GPG_KEY_EXP=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;
      --keyserver)
        GPG_PUB_KEY_SERVER=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;
      --fname)
        v=`zero_app_fix_val "$opt" "$2"`
        GPG_ENCODE_FILE_NAME=$v
        GPG_DECODE_FILE_NAME=$v
        GPG_SIGN_FILE_NAME=$v
        shift 2
        ;;
      --fsuffix)
        v=`zero_app_fix_val "$opt" "$2"`
        GPG_ENCODE_FILE_SUFFIX=$v
        GPG_DECODE_FILE_SUFFIX=$v
        GPG_SIGN_FILE_SUFFIX=$v
        shift 2
        ;;      
      --ftype)
        GPG_SIGN_FILE_TYPE=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;    
        
    #   -i|--input)
    #     inputdir=`zero_app_fix_val "$opt" "$2"`
    #     shift 2
    #     ;;
    #   -o|--output)
    #     outputdir=`zero_app_fix_val "$opt" "$2"`
    #     shift 2
    #     ;;
    #   -t|--topic)
    #     topic=`zero_app_fix_val "$opt" "$2"`
    #     shift 2
    #     ;;
      --dryrun)
        dryrun=0
        shift 1
        ;;
      --)
        shift
        ;;
      -v|--version)
        zero_app_out_version
        ;;
      -h|--help)
        zero_app_out_usage
        ;;
    esac
done
# echo "input: $inputdir"
# echo "out: $outputdir"
# echo "dryrun: $dryrun"
# echo  "$@"



# [ -n "$1" ] && email=$1
# [ -n "$2" ] && topic=$2
# [ -n "$3" ] && today=$3
# exit 0
#zero:task:e:bind-scr-level-args-value


# zero:task:s:get-uid
# gpg_id_get_by_name_and_mail "$GPG_USER_NAME" "$GPG_USER_EMAIL"
# gpg_id_list_by_mail "$GPG_USER_EMAIL"
# zero:task:e:get-uid

# get uid
function gpg_id_get_by_name_and_mail(){
  local name= ; [ "${1}" ] && name="${1}" ; [ -z "$name" ] && name="yemiancheng" ;
  local mail= ; [ "${2}" ] && mail="${2}" ; [ -z "$mail" ] && mail="hualei03042013@163.com" ;
  local uid= ; uid="$name <$mail>"
  # step-x: list key and get the line before match pattern

  [ "$uid" ] &&  {
    GPG_USER_ID=$(gpg --list-keys | grep -B 1 "$uid" | grep -v "$uid" | sed "s/ //g" | sed "/^-*$/d") ;
    echo "$GPG_USER_ID" ;
  }
}

# fun usage
# gpg_id_get_by_name_and_mail
# gpg_id_get_by_name_and_mail "yemiancheng" "hualei03042013@163.com"
# gpg_id_get_by_name_and_mail "$GPG_USER_NAME" "$GPG_USER_EMAIL"

function gpg_id_list_by_mail(){
  local mail= ; [ "${1}" ] && mail="${1}" ; [ -z "$mail" ] && mail="hualei03042013@163.com" ;
  local uid= ; uid="<$mail>"
  [ "$uid" ] &&  {
    #gpg --list-keys | grep -B 1 "$uid"
    #gpg --list-keys | grep -B 1 "$uid" | grep -v "$uid"
    gpg --list-keys | grep -B 1 "$uid" | grep -v "$uid" | sed "s/ //g" | sed "/^-*$/d" ;
  }
}
# fun usage
# gpg_id_list_by_mail
# gpg_id_list_by_mail "hualei03042013@163.com"
# gpg_id_list_by_mail "$GPG_USER_EMAIL"

function gpg_sec_key_list(){
    echo "[task] sec key list"
  echo "[info] files:"
  ls "$GPG_KEY_PATH"
  echo "[info] keys:"
  gpg --list-keys
}
# fun usage
#gpg_sec_key_list


function gpg_sec_key_gen_v1(){
  gpg --gen-key
}
# fun usage
#gpg_sec_key_gen_v1

function gpg_sec_key_gen_v2(){
  gpg --full-generate-key
}
# fun usage
#gpg_sec_key_gen_v2


function gpg_cnf_key_tpl_01(){
  local tpl=$(
  cat <<EOF
%echo Generating a basic OpenPGP key
Key-Type: $GPG_KEY_TYPE
Key-Length: $GPG_KEY_LENGTH
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: $GPG_USER_NAME
Name-Comment: $GPG_USER_NOTE
Name-Email: $GPG_USER_EMAIL
Expire-Date: 0
Passphrase: abc
%pubring $FILE.pub
%secring $FILE.sec
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
EOF
)
  echo "$tpl"
}
# fun usage
# gpg_cnf_key_tpl_01
# gpg_cnf_key_tpl_01 > "$f"
# gpg_cnf_key_tpl_01 > "$GPG_CNF_KEY_FILE"

function gpg_cnf_key_tpl_02(){
  local tpl=$(
  cat <<EOF
%echo Generating a basic OpenPGP key
Key-Type: $GPG_KEY_TYPE
Key-Length: $GPG_KEY_LENGTH
Subkey-Type: $GPG_KEY_TYPE
Subkey-Length: $GPG_KEY_LENGTH
Name-Real: $GPG_USER_NAME
Name-Email: $GPG_USER_EMAIL
Expire-Date: $GPG_KEY_EXP
Passphrase: $GPG_PASSPHRASE
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
EOF
)
  echo "$tpl"
}
# fun usage
# gpg_cnf_key_tpl_02
# gpg_cnf_key_tpl_02 > "$f"
# gpg_cnf_key_tpl_02 > "$GPG_CNF_KEY_FILE"

function gpg_sec_key_gen(){
  local f= ; [ "${1}" ] && f="${1}" ; [ -z "$f" ] && f="$GPG_CNF_KEY_FILE" ; [ -z "$f" ] && f="" ;
  local p= ; [ "${2}" ] && p="${2}" ; [ -z "$p" ] && p="$GPG_PASSPHRASE" ; [ -z "$p" ] && p="yemiancheng123" ;
  [ "$f" ] && GPG_CNF_KEY_FILE="$f"
  [ "$p" ] && GPG_PASSPHRASE="$p"
  # step-x: get cnf
  # step-x: get arg
  [ ! -e "$f" ] && {
    gpg_cnf_key_tpl_02 > "$f"
    gpg --batch --gen-key "$f"
  }
  GPG_PASSPHRASE=
}

# fun usage
#gpg_sec_key_gen
#gpg_sec_key_gen "$GPG_CNF_KEY_FILE" $GPG_PASSPHRASE

function gpg_sec_key_del(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"
  gpg --delete-secret-key "$id"
  gpg --delete-key "$id"
}
# fun usage
#gpg_sec_key_del
#gpg_sec_key_del "$GPG_USER_ID"

function gpg_sec_key_del_by_mail(){
  local mail= ; [ "${1}" ] && mail="${1}" ; [ -z "$mail" ] && mail="" ;
  local list=
  list=$(gpg_id_list_by_mail "$mail")
  list=$(echo "$list" | sed "/^ *#.*/d")
  #for line in $(echo "$list") ; do echo "gpg_sec_key_del $line"; done
  for line in $(echo "$list") ; do gpg_sec_key_del "$line"; done
}
# fun usage
#gpg_sec_key_del_by_mail
#gpg_sec_key_del_by_mail "$GPG_USER_MAIL"

function gpg_pri_key_list(){
  gpg --list-secret-key
}
# fun usage
#gpg_pri_key_list

function gpg_pri_key_del(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"
  gpg --delete-secret-key "$id"
}
# fun usage
#gpg_pri_key_del
#gpg_pri_key_del "$GPG_USER_ID"

function gpg_pri_key_export(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"

  local f= ; [ "${2}" ] && f="${2}" ; [ -z "$f" ] && f="$GPG_PRI_KEY_FILE" ; [ -z "$f" ] && f="" ;
  [ "$f" ] && GPG_PRI_KEY_FILE="$f"
  [ "$id" ] && [ "$f" ] && [ ! -e "$f" ] && { gpg --armor --output "$f" --export-secret-keys "$id" ; echo "output:$f" ; }
}
# fun usage
#gpg_pri_key_export
#gpg_pri_key_export "$GPG_USER_ID" "$GPG_PRI_KEY_FILE"

function gpg_pri_key_import(){
  local f= ; [ "${1}" ] && f="${1}" ; [ -z "$f" ] && f="$GPG_PRI_KEY_FILE" ; [ -z "$f" ] && f="" ;
  [ "$f" ] && GPG_PRI_KEY_FILE="$f"
  [ "$f" ] && [ -e "$f" ] && gpg --import "$f"
}
# fun usage
#gpg_pri_key_import
#gpg_pri_key_import "$GPG_PRI_KEY_FILE"

function gpg_pub_key_export(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"

  local f= ; [ "${2}" ] && f="${2}" ; [ -z "$f" ] && f="$GPG_PUB_KEY_FILE" ; [ -z "$f" ] && f="" ;
  [ "$f" ] && GPG_PUB_KEY_FILE="$f"

  [ "$f" ] && [ ! -e "$f" ] &&  { gpg --armor --output "$f" --export "$id" ; echo "output:$f" ; }
  # armor to show with ASCII code
  #[ ! -e "$f" ] && gpg --armor --export "$id" > "$f"
}
# fun usage
#gpg_pub_key_export
#gpg_pub_key_export "$GPG_USER_ID" "$GPG_PUB_KEY_FILE"

function gpg_pub_key_upload(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"

  local f= ; [ "${2}" ] && f="${2}" ; [ -z "$f" ] && f="$GPG_PUB_KEY_SERVER" ; [ -z "$f" ] && f="hkp://ipv4.pool.sks-keyservers.net" ;
  [ "$f" ] && GPG_PUB_KEY_SERVER="$f"

  gpg --keyserver "$f" --send-keys "$id"
}
# fun usage
#gpg_pub_key_upload
#gpg_pub_key_upload "$GPG_USER_ID" "hkp://ipv4.pool.sks-keyservers.net"
#gpg_pub_key_upload "$GPG_USER_ID" "$GPG_PUB_KEY_SERVER"

function gpg_pub_key_search(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"

  local f= ; [ "${2}" ] && f="${2}" ; [ -z "$f" ] && f="$GPG_PUB_KEY_SERVER" ; [ -z "$f" ] && f="hkp://ipv4.pool.sks-keyservers.net" ;
  [ "$f" ] && GPG_PUB_KEY_SERVER="$f"

  gpg --keyserver "$f" --search-keys "$id"
}
# fun usage
#gpg_pub_key_search
#gpg_pub_key_search "$GPG_USER_ID" "hkp://ipv4.pool.sks-keyservers.net"
#gpg_pub_key_search "$GPG_USER_ID" "$GPG_PUB_KEY_SERVER"

function gpg_pub_key_download(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"

  local f= ; [ "${2}" ] && f="${2}" ; [ -z "$f" ] && f="$GPG_PUB_KEY_SERVER" ; [ -z "$f" ] && f="hkp://ipv4.pool.sks-keyservers.net" ;
  [ "$f" ] && GPG_PUB_KEY_SERVER="$f"

  gpg --keyserver "$f" --receive-keys "$id"
}
# fun usage
#gpg_pub_key_download
#gpg_pub_key_download "$GPG_USER_ID" "hkp://ipv4.pool.sks-keyservers.net"
#gpg_pub_key_download "$GPG_USER_ID" "$GPG_PUB_KEY_SERVER"

function gpg_pub_key_check(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"

  #2生成公钥指纹
  gpg --fingerprint "$id"
  #...
  # todos
}

# fun usage
#gpg_pub_key_check
#gpg_pub_key_check "$GPG_USER_ID"

function gpg_pub_key_revoke(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"
  local s= ; [ "${2}" ] && s="${2}" ; [ -z "$s" ] && s="$GPG_PUB_KEY_SERVER" ; [ -z "$s" ] && s="hkp://ipv4.pool.sks-keyservers.net" ;
  [ "$s" ] && GPG_PUB_KEY_SERVER="$s"

  local f= ; [ "${3}" ] && f="${3}" ; [ -z "$f" ] && f="$GPG_REV_KEY_FILE" ; [ -z "$f" ] && f="t" ;
  [ "$f" ] && GPG_REV_KEY_FILE="$f"

  gpg --gen-revoke "$id" --output "$f"
  #...
  gpg --send-keys "$id" --keyserver "$s"
}
# fun usage
#gpg_pub_key_revoke
#gpg_pub_key_revoke "$GPG_USER_ID" "$GPG_PUB_KEY_SERVER" "$GPG_REV_KEY_FILE"

function gpg_pub_key_import(){
  local f= ; [ "${1}" ] && f="${1}" ; [ -z "$f" ] && f="$GPG_PUB_KEY_FILE" ; [ -z "$f" ] && f="" ;
  [ "$f" ] && GPG_PUB_KEY_FILE="$f"
  [ "$f" ] && [ ! -e "$f" ] && gpg --import "$f"
}
# fun usage
#gpg_pub_key_import
#gpg_pub_key_import "$GPG_PUB_KEY_FILE"

function gpg_rev_key_export(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"

  local f= ; [ "${2}" ] && f="${2}" ; [ -z "$f" ] && f="$GPG_REV_KEY_FILE" ; [ -z "$f" ] && f="t" ;
  [ "$f" ] && GPG_REV_KEY_FILE="$f"

  #2生成撤销证书
  #[ ! -e "$f" ] && gpg --gen-revoke "$id" --output "$f"
  [ "$f" ] && [ ! -e "$f" ] && gpg --gen-revoke "$id" > "$f"
}
# fun usage
#gpg_rev_key_export
#gpg_rev_key_export "$GPG_USER_ID" "$GPG_REV_KEY_FILE"

function gpg_rev_key_import(){
  local f= ; [ "${1}" ] && f="${1}" ; [ -z "$f" ] && f="$GPG_REV_KEY_FILE" ; [ -z "$f" ] && f="" ;
  [ "$f" ] && GPG_REV_KEY_FILE="$f"
  [ "$f" ] && [ ! -e "$f" ] &&  gpg --import "$f"
}
# fun usage
#gpg_rev_key_import
#gpg_rev_key_import "$GPG_REV_KEY_FILE"


function gpg_file_encode(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"

  local name=
  [ "${2}" ] && name="${2}"
  [ -z "$name" ] && name="$GPG_ENCODE_FILE_NAME"
  [ -z "$name" ] && name=
  [ "$name" ] && GPG_ENCODE_FILE_NAME="$name"

  local suffix=
  [ "${3}" ] && suffix="${3}"
  [ -z "$suffix" ] && suffix="$GPG_ENCODE_FILE_SUFFIX"
  [ -z "$suffix" ] && suffix=
  [ "$suffix" ] && GPG_ENCODE_FILE_SUFFIX="$suffix"

  local src=
  local des=
  src="${name}.${suffix}"
  des="${name}.en.${suffix}"
  #gpg --recipient "$id" --encrypt "$src" --output "$des" # error
  # fix in gpg (GnuPG) 2.2.20 ;desc=Note: '--output' is not considered an option
  gpg --recipient "$id" --output "$des" --encrypt "$src"
}
# fun usage
#gpg_file_encode
#gpg_file_encode "$GPG_USER_ID" "lang-$ver.all" "tar.gz"
#gpg_file_encode "$GPG_USER_ID" "$GPG_ENCODE_FILE_NAME" "$GPG_ENCODE_FILE_SUFFIX"

function gpg_file_decode(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"

  local name=
  [ "${2}" ] && name="${2}"
  [ -z "$name" ] && name="$GPG_DECODE_FILE_NAME"
  [ -z "$name" ] && name=
  [ "$name" ] && GPG_DECODE_FILE_NAME="$name"

  local suffix=
  [ "${3}" ] && suffix="${3}"
  [ -z "$suffix" ] && suffix="$GPG_DECODE_FILE_SUFFIX"
  [ -z "$suffix" ] && suffix=
  [ "$suffix" ] && GPG_DECODE_FILE_SUFFIX="$suffix"

  local src=
  local des=
  des="${name}.${suffix}"
  src="${name}.en.${suffix}"
  #gpg --decrypt "$src" --output "$des" # error
  # fix gpg: Note: '--output' is not considered an option
  gpg --output "$des" --decrypt "$src"
  #des="${name}.de.${suffix}"
  #gpg --output "$des" --decrypt "$src"
}
# fun usage
#gpg_file_decode
#gpg_file_decode "$GPG_USER_ID" "lang-$ver.all" "tar.gz"
#gpg_file_decode "$GPG_USER_ID" "$GPG_DECODE_FILE_NAME" "$GPG_DECODE_FILE_SUFFIX"


function gpg_file_sign(){
  local n1=
  [ "${1}" ] && n1="${1}"
  [ -z "$n1" ] && n1="$GPG_SIGN_FILE_NAME"
  [ -z "$n1" ] && n1=password
  [ "$n1" ] && GPG_SIGN_FILE_NAME="$n1"

  local n2=
  [ "${2}" ] && n2="${2}"
  [ -z "$n2" ] && n2="$GPG_SIGN_FILE_SUFFIX"
  [ -z "$n2" ] && n2=txt
  [ "$n2" ] && GPG_SIGN_FILE_SUFFIX="$n2"

  local t=
  [ "${3}" ] && t="${3}"
  [ -z "$t" ] &&  t="$GPG_SIGN_FILE_TYPE"
  [ -z "$t" ] && t="txt+sign"
  [ "$t" ] && GPG_SIGN_FILE_TYPE="$t"

  local file=
  file="${n1}.${n2}"

  #2 以二进制式存储+合并式的=数字签名+合并式的
  [ -e "$file" ] && [ _"$t" = _"bin" ] && {
      echo "sign file and gen file $file.gpg ..." ;
      gpg --sign "$file";
  }

  #2 以文本形式存储+合并式的=文本签名+合并式的
  [ -e "$file" ] && [ _"$t" = _"txt" ] && {
      echo "sign file and gen file $file.asc ..." ;
      gpg --clearsign "$file";
  }

  #2 以二进制式存储+分离式的=数字签名+分离式的
  [ -e "$file" ] && [ _"$t" = _"bin+sign" ] && {
      echo "sign file and gen file $file.sig ..." ;
      gpg --detach-sign  "$file";
  }
  #2 以文本形式存储+签名文件=文本签名+分离式的
  [ -e "$file" ] && [ _"$t" = _"txt+sign" ] && {
      echo "sign file and gen file $file.asc ..." ;
      gpg --armor --detach-sign  "$file";
  }
}
# fun usage
#gpg_file_sign
#gpg_file_sign "password" "txt" "txt"
#gpg_file_sign "lang-$ver.all" "tar.gz" "txt+sign"
#gpg_file_sign "$GPG_SIGN_FILE_NAME" "$GPG_SIGN_FILE_SUFFIX" "$GPG_SIGN_FILE_TYPE"


function gpg_file_checksign(){
  local n1=
  [ "${1}" ] && n1="${1}"
  [ -z "$n1" ] && n1="$GPG_SIGN_FILE_NAME"
  [ -z "$n1" ] && n1=password
  [ "$n1" ] && GPG_SIGN_FILE_NAME="$n1"

  local n2=
  [ "${2}" ] && n2="${2}"
  [ -z "$n2" ] && n2="$GPG_SIGN_FILE_SUFFIX"
  [ -z "$n2" ] && n2=txt
  [ "$n2" ] && GPG_SIGN_FILE_SUFFIX="$n2"

  local t=
  [ "${3}" ] && t="${3}"
  [ -z "$t" ] &&  t="$GPG_SIGN_FILE_TYPE"
  [ -z "$t" ] && t="txt+sign"
  [ "$t" ] && GPG_SIGN_FILE_TYPE="$t"

  local file=
  file="${n1}.${n2}"

  # 文本签名+合并式的
  #[ _"$t" = _"txt" ] && gpg --verify "${1}.${n2}.asc"
  [ _"$t" = _"txt" ] && [ -e "$file.asc" ] && gpg --verify "${1}.${n2}.asc" "${1}.${n2}"
  # 文本签名+分离式的
  [ _"$t" = _"txt+sign" ] && [ -e "$file.asc" ] && gpg --verify "${1}.${n2}.asc" "${1}.${n2}"
  # 数字签名+合并式的
  [ _"$t" = _"bin" ] && [ -e "$file.gpg" ] && gpg --verify "${1}.${n2}.gpg"
  # 数字签名+分离式的
  [ _"$t" = _"bin+sign" ] && [ -e "$file.sig" ] && gpg --verify "${1}.${n2}.sig" "${1}.${n2}"
}
# fun usage
#gpg_file_checksign
#gpg_file_checksign "password" "txt" "txt"
#gpg_file_checksign "lang-$ver.all" "tar.gz" "txt+sign"
#gpg_file_checksign "$GPG_SIGN_FILE_NAME" "$GPG_SIGN_FILE_SUFFIX" "$GPG_SIGN_FILE_TYPE"

function gpg_passphrase_change(){
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_USER_ID" ; [ -z "$id" ] && id="" ;
  [ "$id" ] && GPG_USER_ID="$id"
  echo 'step 1. go in to gpg cli:gpg --edit-key "$id"'
  echo "step 2. to update password:password"
  echo "step 3. to save password:save"
  gpg --edit-key "$id"
  #gpg2 --edit-key "$id"
  # then write password
}
# fun usage
#gpg_passphrase_change
#gpg_passphrase_change "$GPG_USER_ID"



function gpg_var_ini(){
# [curd]
GPG_KEY_LENGTH=2048
GPG_KEY_TYPE=RSA
GPG_KEY_EXP=0 # eg:365|12m|1y
GPG_USER_NAME=yemiancheng
GPG_USER_NOTE=ymc-github
GPG_USER_EMAIL=ymc.github@gmail.com
GPG_USER_ID= # will be gen
GPG_KEY_PATH=~/.gnupg
# gpg_var_cal
#GPG_PUB_KEY_SERVER="hkp://subkeys.pgp.net"
#GPG_PUB_KEY_SERVER=hkp://p80.pool.sks-keyservers.net:80
GPG_PUB_KEY_SERVER=hkp://ipv4.pool.sks-keyservers.net
#GPG_PUB_KEY_SERVER=hkp://pgp.mit.edu:80

# [encode]
GPG_ENCODE_FILE_NAME=SHASUMS256
GPG_ENCODE_FILE_SUFFIX="txt"
# [decode]
GPG_DECODE_FILE_NAME=SHASUMS256
GPG_DECODE_FILE_SUFFIX="txt"
# [sign]
GPG_SIGN_FILE_NAME=SHASUMS256
GPG_SIGN_FILE_SUFFIX=txt
GPG_SIGN_FILE_TYPE=txt
}
# fun usage
#gpg_var_ini


function gpg_var_cal(){
GPG_CNF_KEY_NAME="gpg.$GPG_USER_NOTE.cnf"
GPG_PUB_KEY_NAME="gpg.$GPG_USER_NOTE.pub"
GPG_PRI_KEY_NAME="gpg.$GPG_USER_NOTE.pri"
GPG_REV_KEY_NAME="gpg.$GPG_USER_NOTE.rev"
GPG_SEC_KEY_NAME="gpg.$GPG_USER_NOTE.sec"
GPG_CNF_KEY_FILE="${GPG_KEY_PATH}/${GPG_CNF_KEY_NAME}.txt"
GPG_PUB_KEY_FILE="${GPG_KEY_PATH}/${GPG_PUB_KEY_NAME}.txt"
GPG_PRI_KEY_FILE="${GPG_KEY_PATH}/${GPG_PRI_KEY_NAME}.txt"
GPG_REV_KEY_FILE="${GPG_KEY_PATH}/${GPG_REV_KEY_NAME}.txt"
GPG_SEC_KEY_FILE="${GPG_KEY_PATH}/${GPG_SEC_KEY_NAME}.txt"
}
# fun usage
#gpg_var_cal

function gpg_backup_file_gen(){
  local list=
  local i=
  local src=
  local des=

  local p2=
  [ "${1}" ] && p2="${1}"
  [ -z "$p2" ] && p2="$BACKUP_DES_PATH"
  [ -z "$p2" ] && p2=secret

  local pr=
  [ "${2}" ] && pr="${2}"
  [ -z "$pr" ] && pr="$GPG_KEY_PATH"
  [ -z "$pr" ] && pr=~/.gnupg

  # step-x: back up gpg pri key file
  src="$GPG_PRI_KEY_FILE"
  des=$(echo "$GPG_PRI_KEY_FILE" | sed "s#$pr#$p2#")
  [ -e "$src" ] && [ ! -e "$des" ] && echo "$des" && cp -rf "$src" "$des"
  # step-x: back up gpg pub key file
  src="$GPG_PUB_KEY_FILE"
  des=$(echo "$GPG_PUB_KEY_FILE" | sed "s#$pr#$p2#")
  [ -e "$src" ] && [ ! -e "$des" ] && echo "$des" && cp -rf "$src" "$des"
  # step-x: back up gpg rev key file
  src="$GPG_REV_KEY_FILE"
  des=$(echo "$GPG_REV_KEY_FILE" | sed "s#$pr#$p2#")
  [ -e "$src" ] && [ ! -e "$des" ] && echo "$des" && cp -rf "$src" "$des"
  # step-x: back up gpg sec key file
  src="$GPG_SEC_KEY_FILE"
  des=$(echo "$GPG_SEC_KEY_FILE" | sed "s#$pr#$p2#")
  [ -e "$src" ] && [ ! -e "$des" ] && echo "$des" && cp -rf "$src" "$des"

}

# fun usage
# gpg_backup_file_gen
# gpg_backup_file_gen "secret" ~/.gnupg
# gpg_backup_file_gen "secret/gpg" ~/.gnupg
# gpg_backup_file_gen "$des_dir" "$src_dir"
# gpg_backup_file_gen "$des_dir" "$GPG_KEY_PATH"

function gpg_backup_file_del(){
  local list=
  local i=
  local src=
  local des=

  local p2=
  [ "${1}" ] && p2="${1}"
  [ -z "$p2" ] && p2="$BACKUP_DES_PATH"
  [ -z "$p2" ] && p2=secret

  local pr=
  [ "${2}" ] && pr="${2}"
  [ -z "$pr" ] && pr="$GPG_KEY_PATH"
  [ -z "$pr" ] && pr=~/.gnupg
  src="$GPG_PRI_KEY_FILE"
  des=$(echo "$GPG_PRI_KEY_FILE" | sed "s#$pr#$p2#")
  [ -e "$des" ] && echo "$des" && rm -rf "$des"
  src="$GPG_PUB_KEY_FILE"
  des=$(echo "$GPG_PUB_KEY_FILE" | sed "s#$pr#$p2#")
  [ -e "$des" ] && echo "$des" && rm -rf "$des"
  src="$GPG_REV_KEY_FILE"
  des=$(echo "$GPG_REV_KEY_FILE" | sed "s#$pr#$p2#")
  [ -e "$des" ] && echo "$des" && rm -rf "$des"
  src="$GPG_SEC_KEY_FILE"
  des=$(echo "$GPG_SEC_KEY_FILE" | sed "s#$pr#$p2#")
  [ -e "$des" ] && echo "$des" && rm -rf "$des"
}
# fun usage
# gpg_backup_file_del
# gpg_backup_file_del "secret" ~/.gnupg
# gpg_backup_file_del "secret/gpg" ~/.gnupg
# gpg_backup_file_del "$des_dir" "$src_dir"
# gpg_backup_file_del "$des_dir" "$GPG_KEY_PATH"

function gpg_sec_id_get_by_name_and_mail(){
  local name= ; [ "${1}" ] && name="${1}" ; [ -z "$name" ] && name="yemiancheng" ;
  local mail= ; [ "${2}" ] && mail="${2}" ; [ -z "$mail" ] && mail="hualei03042013@163.com" ;
  local uid= ; uid="$name <$mail>"
  # step-x: list and get the line before match pattern
  # step-x: get str begin with sec
  # step-x: only get the first line
  # step-x: delete more than one space to one
  [ "$uid" ] &&  {
    GPG_SEC_ID=$(gpg --list-secret-keys --keyid-format LONG |  grep -B 2 "$uid" | grep "^sec" | sed -n "1p" |sed "s# +# #g" | cut -d " " -f 4 | cut -d "/" -f 2) ;
    echo "$GPG_SEC_ID" ;
  }
}
# fun usage
#gpg_sec_id_get_by_name_and_mail
#

function gpg_sec_key_export(){
  # step-x: passed id with arg
  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_SEC_ID" ; [ -z "$id" ] && id="" ;
  local f= ; [ "${2}" ] && f="${2}" ; [ -z "$f" ] && f="$GPG_SEC_KEY_FILE" ; [ -z "$f" ] && f="" ;
  # step-x: update GPG_SEC_ID with arg
  [ "$id" ] && GPG_SEC_ID="$id"
  # step-x: update GPG_SEC_KEY_FILE with arg
  [ "$f" ] && GPG_SEC_KEY_FILE="$f"
  [ "$id" ] && [ "$f" ] && [ ! -e "$f" ] && { gpg --armor --export "$id" > "$f" ; echo "output:$f" ; }
}
# fun usage
#gpg_sec_key_export
#gpg_sec_key_export "$GPG_SEC_ID" "$GPG_SEC_KEY_FILE"

function gpg_sec_key_to_github(){
  echo "note:1. to github"
  echo "note:2. todos"
  echo "note:3. now only copy"
  local f= ; [ "${1}" ] && f="${1}" ; [ -z "$f" ] && f="$GPG_SEC_KEY_FILE" ; [ -z "$f" ] && f="" ;
  [ "$f" ] && GPG_SEC_KEY_FILE="$f"
  [ -e "$f" ] &&  cat "$f" | clip
}
# fun usage
#gpg_sec_key_to_github
#gpg_sec_key_to_github "$GPG_SEC_KEY_FILE"

function gpg_sec_id_to_git(){
  msg="
steps:
1. get secret id
2. get secret key
3. put secret key to github/gitlab/gitee ...
4. put secret id to git
   eg:git config --global user.signingkey {{id}}
   eg:git config user.signingkey {{id}}
5. tell git use gpg sign when commit
   eg:git config --global commit.gpgsign true
   eg:git config commit.gpgsign true
6. it will check when:git commit or git commit -S
7. it will get Verified label in github/gitlab/gitee
note:now is step 4,5
"
  

  local id= ; [ "${1}" ] && id="${1}" ; [ -z "$id" ] && id="$GPG_SEC_ID" ; [ -z "$id" ] && id="" ;
  local sc= ; [ "${2}" ] && sc="${2}" ; [ -z "$sc" ] && sc="$GPG_GIT_SCOPE" ; [ -z "$sc" ] && sc="local" ;
  
  echo "$msg" | sed "s/{{id}}/$id/g"

  # step-x: update relative var
  [ "$id" ] && GPG_SEC_ID="$id"
  [ "$sc" ] && GPG_GIT_SCOPE="$sc"
  # local project
  [ _"$sc" = _"local" ] && {
    git config --global user.signingkey "$id" ;
    git config commit.gpgsign true ;
  }
  # all project
  [ _"$sc" = _"global" ] && {
    git config --global user.signingkey $id
    git config --global commit.gpgsign true ;
  }

}
# fun usage
# gpg_sec_id_to_git
# gpg_sec_id_to_git "$GPG_SEC_ID" "local"
# gpg_sec_id_to_git "$GPG_SEC_ID" "global"
# gpg_sec_id_to_git "$GPG_SEC_ID" "$GPG_GIT_SCOPE"




# gpg_var_ini

gpg_var_cal


#zero:task:s:list-pgp-prefix-var
# zero_app_lst_var_name_by_prefix "zero_"
# zero_app_lst_var_name_by_prefix "GPG_"
#zero:task:e:list-pgp-prefix-var

#zero:task:s:list-pgp-prefix-var-val
function run_var_lst(){
    echo "[task] log var about GPG_"
    zero_app_lst_var_value_by_prefix "GPG_"
}

#zero:task:e:list-pgp-prefix-var-val
function run_var(){
case "$zero_app_subcmd" in
    lst)
        run_var_lst
        exit 0
    ;;
esac
}


# zero:task:s:out cnf of gpg key gen
function run_cnf_get(){
echo "[task] log tpl val"
# gpg_cnf_key_tpl_01
gpg_cnf_key_tpl_02
# exit  0
}
# zero:task:e:out cnf of gpg key gen
function run_cnf(){
case "$zero_app_subcmd" in
    get)
        run_cnf_get
        exit 0
    ;;
esac
}

# zero:task:s:gpg key gen
# if uid does not exsit, gen.
function run_key_add(){
echo "[task] gpg key gen"
echo "[info] if uid does not exsit, gen."
gpg_id_get_by_name_and_mail "$GPG_USER_NAME" "$GPG_USER_EMAIL" > /dev/null 2>&1 ;
[ -z "$GPG_USER_ID" ] && gpg_sec_key_gen "$GPG_CNF_KEY_FILE"
echo "$GPG_USER_ID"
}
# zero:task:e:gpg key gen

# zero:task:s:gpg key del
function run_key_del(){
echo "[task] gpg key del"
echo "[info] if uid exsits, del."
gpg_id_get_by_name_and_mail "$GPG_USER_NAME" "$GPG_USER_EMAIL" > /dev/null 2>&1 ;
[ "$GPG_USER_ID" ] && gpg_sec_key_del "$GPG_USER_ID"
echo "$GPG_USER_ID"
}
# zero:task:e:gpg key del

function run_key_cpw(){
echo "[task] gpg key cpw"
echo "[info] if uid exsits, cpw."
gpg_id_get_by_name_and_mail "$GPG_USER_NAME" "$GPG_USER_EMAIL" > /dev/null 2>&1 ;
[ "$GPG_USER_ID" ] && gpg_passphrase_change "$GPG_USER_ID"
echo "$GPG_USER_ID"
}

# zero:task:s:list files and keys
# gpg_sec_key_list
# zero:task:e:list files and keys


function run_key(){
case "$zero_app_subcmd" in
    add)
        run_key_add
        exit 0
    ;;
    del)
        run_key_del
        exit 0
    ;;
    lst)
        gpg_sec_key_list
        exit 0
    ;;
    cnf)
        run_cnf_get
        exit 0
    ;;
    cpw)
        run_key_cpw
        exit 0
    ;;
    
esac
}


# zero:task:s:gpg uid list though email
function run_uid_lst(){
echo "[task] gpg uid list though email"
gpg_id_list_by_mail "$GPG_USER_EMAIL"
}

# zero:task:e:gpg uid list though email
function run_uid(){
case "$zero_app_subcmd" in
    lst)
        run_uid_lst
        exit 0
    ;;
esac
}


# zero:task:s:gpg pub key export
function run_pubkey_export(){
echo "[task] gpg pub key export"
echo "[info] if pubkey exsits, skip."
gpg_id_get_by_name_and_mail "$GPG_USER_NAME" "$GPG_USER_EMAIL" > /dev/null 2>&1 ;
gpg_pub_key_export "$GPG_USER_ID" "$GPG_PUB_KEY_FILE"
}
# zero:task:e:gpg pub key export

# zero:task:s:gpg pub key clip
function run_pubkey_clip(){
echo "[task] gpg pub key clip"
cat "$GPG_PUB_KEY_FILE"
clip < "$GPG_PUB_KEY_FILE"
}
# zero:task:e:gpg pub key clip

function run_pubkey(){
case "$zero_app_subcmd" in
    export)
        run_pubkey_export
        exit 0
    ;;
    clip)
        run_pubkey_clip
        exit 0
    ;;
esac
}


# zero:task:s:gpg pri key export
function run_pubkey_export(){
echo "[task] gpg pri key export"
echo "[info] if prikey exsits, skip."
gpg_id_get_by_name_and_mail "$GPG_USER_NAME" "$GPG_USER_EMAIL" > /dev/null 2>&1 ;
gpg_pri_key_export "$GPG_USER_ID" "$GPG_PRI_KEY_FILE"
}
# zero:task:e:gpg pri key export
#
function run_prikey(){
case "$zero_app_subcmd" in
    import)
        gpg_pri_key_import "$GPG_PRI_KEY_FILE"
        exit 0
    ;;
    export)
        run_pubkey_export
        exit 0
    ;;
esac
}




# zero:task:s:gpg sec key export
function run_seckey_export(){
echo "[task] gpg sec key export"
echo "[info] if seckey exsits, skip."
gpg_sec_id_get_by_name_and_mail "$GPG_USER_NAME" "$GPG_USER_EMAIL"
gpg_sec_key_export "$GPG_SEC_ID" "$GPG_SEC_KEY_FILE"
}
# zero:task:e:gpg sec key export

function run_seckey(){
case "$zero_app_subcmd" in
    export)
        run_seckey_export
        exit 0
    ;;
esac
}






# zero:task:s:telling git about your signing key
function run_tel_git(){
# ns app --git --global
echo "[task] telling git about your signing key"
gpg_sec_id_get_by_name_and_mail "$GPG_USER_NAME" "$GPG_USER_EMAIL"
gpg_sec_id_to_git "$GPG_SEC_ID" "$GPG_GIT_SCOPE"
}
# zero:task:e:telling git about your signing key

function run_tel(){
case "$zero_app_subcmd" in
    git)
        run_tel_git
        exit 0
    ;;
esac
}


function run_file_encode(){
    echo "[task] gpg file encode"
    gpg_id_get_by_name_and_mail "$GPG_USER_NAME" "$GPG_USER_EMAIL" > /dev/null 2>&1
    echo "$GPG_USER_ID"
    gpg_file_encode "$GPG_USER_ID" "$GPG_ENCODE_FILE_NAME" "$GPG_ENCODE_FILE_SUFFIX"
}
function run_file_decode(){
    echo "[task] gpg file decode"
    gpg_id_get_by_name_and_mail "$GPG_USER_NAME" "$GPG_USER_EMAIL" > /dev/null 2>&1
    echo "$GPG_USER_ID"
    gpg_file_decode "$GPG_USER_ID" "$GPG_DECODE_FILE_NAME" "$GPG_DECODE_FILE_SUFFIX"
}
#gpg_file_encode "$GPG_USER_ID" "$GPG_ENCODE_FILE_NAME" "$GPG_ENCODE_FILE_SUFFIX"
#gpg_file_decode "$GPG_USER_ID" "$GPG_DECODE_FILE_NAME" "$GPG_DECODE_FILE_SUFFIX"
#gpg_file_sign "$GPG_SIGN_FILE_NAME" "$GPG_SIGN_FILE_SUFFIX" "$GPG_SIGN_FILE_TYPE"
#gpg_file_checksign "$GPG_SIGN_FILE_NAME" "$GPG_SIGN_FILE_SUFFIX" "$GPG_SIGN_FILE_TYPE"

function run_file(){
case "$zero_app_subcmd" in
    encode)
        run_file_encode
        exit 0
    ;;
    decode)
        run_file_decode
        exit 0
    ;;
    sign)
        gpg_file_sign "$GPG_SIGN_FILE_NAME" "$GPG_SIGN_FILE_SUFFIX" "$GPG_SIGN_FILE_TYPE"
        exit 0
    ;;
    checksign)
        gpg_file_checksign "$GPG_SIGN_FILE_NAME" "$GPG_SIGN_FILE_SUFFIX" "$GPG_SIGN_FILE_TYPE"
        exit 0
    ;;
esac
}



# zero_app_subns=""
# zero_app_subcmd=""
# zero_app_cmd=""

case "$zero_app_subns" in
    var)
        run_var
        exit 0
    ;;
    cnf)
        run_cnf
        exit 0
    ;;
    key)
        run_key
        exit 0
    ;;
    uid)
        run_uid
        exit 0
    ;;
    pubkey)
        run_pubkey
        exit 0
    ;;
    prikey)
        run_prikey
        exit 0
    ;;
    seckey)
        run_seckey
        exit 0
    ;;
    tel)
        run_tel
        exit 0
    ;;
    file)
        run_file
        exit 0
    ;;
esac



# topics
# ./index.sh -h
# ./index.sh -v
