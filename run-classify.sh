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
	echo "      --debug   只打印输出日志，而不实际执行命令。                              "
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
		echo "$cmd_debug : filename $l_item change to $l_filename"
		if [ "$cmd_debug" = "normal" ]; then
			mv $l_item $l_filename;
		fi
	else
		echo "$cmd_debug : filename $l_item do not need change"
	fi

	done
	IFS=$l_IFS_OLD
}

ARG_CMD=`getopt -o ep:f:h -l file:,pic:,regstr:,debug,help -n "run-classify.sh" -- "$@"`;
eval set -- "$ARG_CMD"

cmd_debug="";
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
		--debug)
			cmd_debug="debug";
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

if [ "$cmd_debug" = "" ]; then 
	cmd_debug="normal";
fi

echo $file_type - $file_sub_type - $cmd_debug;
echo $file_sub_type $cmd_debug $cmd_regstr> ./pics.data;
ls -l --time-style long-iso | sed -r "/^total [0-9]*$|\
^d[ 0-9a-zA-Z\:\-]*01_Camera$|\
^d[ 0-9a-zA-Z\:\-]*02_Screenshots$|\
^d[ 0-9a-zA-Z\:\-]*03_WeiXin$|\
^d[ 0-9a-zA-Z\:\-]*04_Otherpics$|\
^d[ 0-9a-zA-Z\:\-]*10_Word$|\
^d[ 0-9a-zA-Z\:\-]*11_Excel$|\
^d[ 0-9a-zA-Z\:\-]*12_PPT$|\
^d[ 0-9a-zA-Z\:\-]*13_PDF$|\
^d[ 0-9a-zA-Z\:\-]*14_Music$|\
^d[ 0-9a-zA-Z\:\-]*15_CompressionFiles$|\
^d[ 0-9a-zA-Z\:\-]*16_Text|98_Manual$|\
^d[ 0-9a-zA-Z\:\-]*99_Unclassification$|\
^d[ 0-9a-zA-Z\:\-]*_script$|\
run-classify.sh$|\
pics.data$/d" >> ./pics.data;

case "$file_type" in
	pic)
		case $file_sub_type in 
			name)
				awk -f ./01_Camera/classify-photo-by-name.awk ./pics.data;
				;;
			createdtime)
				awk -f ./01_Camera/classify-photo-by-createdtime.awk ./pics.data;
				;;
			wechat)
				awk -f ./03_WeiXin/classify-wechat-pic.awk ./pics.data;
				;;
			screenshot)
				awk -f ./02_Screenshots/classify-screenshot-pic.awk ./pics.data;
				;;
			otherpic)
				awk -f ./04_OtherPics/classify-otherpics-pic.awk ./pics.data;
				;;
			*)
				;;
		esac
		;;
	file)
		case $file_sub_type in
			word)
				awk -f ./10_Word/classify-word.awk ./pics.data;
				;;
			excel)
				awk -f ./11_Excel/classify-excel.awk ./pics.data;
				;;
			ppt)
				awk -f ./12_PPT/classify-ppt.awk ./pics.data;
				;;
			pdf)
				awk -f ./13_PDF/classify-pdf.awk ./pics.data;
				;;
			music)
				awk -f ./14_Music/classify-music.awk ./pics.data;
				;;
			compressionfile)
				awk -f ./15_CompressionFiles/classify-compressionfile.awk ./pics.data;
				;;
			text)
				awk -f ./16_Text/classify-text.awk ./pics.data;
				;;
			*)
				;;
		esac
		;;
	e)
		#rename 's/ |`|@|\$|%|#|{|}//g' *;
		#rename 's/\(|\)|\[|\]|\+|\&|,/_/g' *;
		#rename 's/'\''/_/g' *;
		corrent_filename "." "$cmd_debug"
		;;
	*)
		;;
esac

if [ -f ./pics.data ]; then
	rm ./pics.data
fi

exit 0;






