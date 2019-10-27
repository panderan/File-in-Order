#!/bin/bash

function show_help() {
	echo "用法: run-classify.sh [OPTION]...                                               "
	echo "分类该目录下的待分类的文件。                                                    "
	echo "                                                                                "
	echo "选项：                                                                          "
	echo "  -e            替换文件名中的特殊字符，将' '、'\`'、'@'、'\\'、'\$'、'%'、'#'、"
	echo "                '{'和'}'删除掉，将'('、')'、'['、']'、'+'、'&'、','替换为'_'。  "
	echo "  -p, --pic     分类图片类型文件，需指定参数'name'、'createdtime'、'screenshot'、"
	echo "                'wechat'和'otherpic'其中的一个。                                "
	echo "  -f, --file    分类其他类型文件，需指定参数'word'、'excel'、'pdf'、'music'、   "
	echo "                'text'、'compressionfile'和'ppt'其中的一个。                    "
	echo "      --regstr  指定正则表达式，需与 --pic createdtime 一起使用。               "
	echo "      --test    只打印输出日志，而不实际执行命令。对于需要先改名再分类的文件则该"
	echo "                选项只debug改名部分。                                           "
	echo "      --test2   只打印输出日志，而不实际执行命令。对于需要先改名再分类的文件则该"
	echo "                选项只debug分类移动部分。                                       "
	echo "  -h, --help    显示帮助信息                                                    "
	echo "                                                                                "
}

function corrent_filename() {
	l_path=$1
	
	l_IFS_OLD=$IFS
	IFS=$'\n';
	for l_item in `find $l_path -maxdepth 1`
	do
		if [ -d $l_item ]; then
			continue;
		fi
		l_filename=$l_item;
		l_filename=${l_filename//\`/};
		l_filename=${l_filename//@/};
		l_filename=${l_filename//\$/};
		l_filename=${l_filename//%/};
		l_filename=${l_filename//#/};
		l_filename=${l_filename//\{/};
		l_filename=${l_filename//\}/};
		l_filename=${l_filename//\'/};
	
		l_filename=${l_filename// /_};
		l_filename=${l_filename//\(/_};
		l_filename=${l_filename//\)/_};
		l_filename=${l_filename//\[/_};
		l_filename=${l_filename//\]/_};
		l_filename=${l_filename//\+/_};
		l_filename=${l_filename//\&/_};
		l_filename=${l_filename//,/_};
		
	if [ ! "$l_item" = "$l_filename" ]; then
		echo "$cmd_debug_test1 : filename $l_item change to $l_filename"
		if [ "$cmd_debug_test1" = "normal" ]; then
			mv $l_item $l_filename;
		fi
	else
		echo "$cmd_debug_test1 : filename $l_item do not need change"
	fi

	done
	IFS=$l_IFS_OLD
}

ARG_CMD=`getopt -o ep:f:h -l file:,pic:,regstr:,test,test2,help -n "run-classify.sh" -- "$@"`;
eval set -- "$ARG_CMD"

cmd_debug_test1="";
cmd_debug_test2="";
cmd_regstr="";
file_type="";
file_sub_type="";

while true
do
	case "$1" in
		-p | --pic)
			file_type="pic";
			if [ "$2" != "name" -a   "$2" != "createdtime" -a \
				 "$2" != "screenshot" -a \
			     "$2" != "wechat" -a "$2" != "otherpic" ]; then  
				echo -e "\033[31mError\033[0m --pic argument, must be one of \"name\",\"createdtime\",\"screenshot\",\"wechat\" and \"otherpic\".";
				exit 1;
			fi
			file_sub_type=$2;
			shift 2;
			;;
		-f | --file)
			file_type="file";
			if [ "$2" != "word" -a "$2" != "excel" -a "$2" != "pdf" -a \
			   	 "$2" != "compressionfile" -a "$2" != "music" -a \
				 "$2" != "text" -a "$2" != "ppt" ]; then
				echo -e "\033[31mError\033[0m --file argument, must be one of \"word\",\"excel\",\"pdf\",\"compressionfile\",\"music\",\"text\",\"ppt\".";
				exit 1;
			fi
			file_sub_type=$2;
			shift 2;
			;;
		--regstr)
			cmd_regstr=$2;
			shift 2;
			;;
		--test)
			cmd_debug_test1="debug";
			shift;
			;;
		--test2)
			cmd_debug_test2="debug";
			shift;
			;;
		-e)
			file_type="e";
			file_sub_type="e";
			shift;
			;;
		-h | --help)
			show_help;
			exit;
			;;
		--)
			shift;
			break;
			;;
		*)
			exit 1;
			;;
	esac
done

if [ "$file_type" = "" -o "$file_sub_type" = "" ]; then
	echo -e "\033[31mError\033[0m,Need options!"
	exit 1;
fi

if [ "$file_type" = "pic" -a "$file_sub_type" = "createdtime" -a "$cmd_regstr" = "" ]; then
	echo -e "\033[31mError\033[0m, createdtime option need regular expression string!";
	exit 1;
fi

if [ "$cmd_debug_test1" = "" ]; then 
	cmd_debug_test1="normal";
fi
if [ "$cmd_debug_test2" = "" ]; then 
	cmd_debug_test2="normal";
fi

echo $file_type - $file_sub_type - $cmd_debug_test1 - $cmd_debug_test2;
echo $file_sub_type $cmd_debug_test1 $cmd_debug_test2 $cmd_regstr> ./pics.data;
ls -l --time-style long-iso | sed -r "/^total [0-9]*$|\
^d[ 0-9a-zA-Z\:\-]*Archives$|\
^d[ 0-9a-zA-Z\:\-]*Images$|\
^d[ 0-9a-zA-Z\:\-]*Manual$|\
^d[ 0-9a-zA-Z\:\-]*Music$|\
^d[ 0-9a-zA-Z\:\-]*Offices$|\
^d[ 0-9a-zA-Z\:\-]*Texts$|\
^d[ 0-9a-zA-Z\:\-]*Unclassification$|\
^d[ 0-9a-zA-Z\:\-]*.git$|\
^d[ 0-9a-zA-Z\:\-]*.script$|\
run-classify.sh$|\
pics.data$/d" >> ./pics.data;

case "$file_type" in
	pic)
		case $file_sub_type in 
			name)
				awk -f ./Images/Camera/classify-photo-by-name.awk ./pics.data;
				;;
			createdtime)
				awk -f ./Images/Camera/classify-photo-by-createdtime.awk ./pics.data;
				;;
			wechat)
				awk -f ./Images/WeiXin/classify-wechat-pic.awk ./pics.data;
				;;
			screenshot)
				awk -f ./Images/Screenshots/classify-screenshot-pic.awk ./pics.data;
				;;
			otherpic)
				awk -f ./Images/OtherPics/classify-otherpics-pic.awk ./pics.data;
				;;
			*)
				;;
		esac
		;;
	file)
		case $file_sub_type in
			word)
				awk -f ./Offices/Word/classify-word.awk ./pics.data;
				;;
			excel)
				awk -f ./Offices/Excel/classify-excel.awk ./pics.data;
				;;
			ppt)
				awk -f ./Offices/PPT/classify-ppt.awk ./pics.data;
				;;
			pdf)
				awk -f ./Offices/PDF/classify-pdf.awk ./pics.data;
				;;
			music)
				awk -f ./Music/classify-music.awk ./pics.data;
				;;
			compressionfile)
				awk -f ./Archives/classify-compressionfile.awk ./pics.data;
				;;
			text)
				awk -f ./Texts/classify-text.awk ./pics.data;
				;;
			*)
				;;
		esac
		;;
	e)
		#rename 's/ |`|@|\$|%|#|{|}//g' *;
		#rename 's/\(|\)|\[|\]|\+|\&|,/_/g' *;
		#rename 's/'\''/_/g' *;
		corrent_filename "." "$cmd_debug_test1"
		;;
	*)
		;;
esac

if [ -f ./pics.data ]; then
	rm ./pics.data
fi

exit 0;






