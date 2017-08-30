#!/bin/bash

# Usage:
#   ./mv.sh <source file name> <target directory> <debug>
#
#  <debug> has two options, one is "debug", it mean print message but do not 
#   execute to actual cmd. another is "normal" which mean do actually what
#   you want.

function fc_mv() {
filename=$1;
target_dir=$2;
cmd_debug=$3;

# 参数检查
if [ "$filename" = "" -o "$target_dir" = "" ]; then
	echo -e "\033[31mError\033[0m, one or more args are not specific.";
	exit 1;
fi

if [ "$cmd_debug" != "debug" -a "$cmd_debug" != "normal" ]; then
	echo -e "\033[31mError\033[0m, one or more args are not specific.";
	exit 1;
fi

# 检查源文件是否存在
if [ ! -f ./$filename ]; then
	echo -e "\033[mError\033[m Source file $filename is non-exist.";
	exit 1;
fi

# 检查目标文件是否存在
if [ -f ./$target_dir/$filename ]; then
	target_md5=`md5sum ./$target_dir/$filename`;
	target_md5=`echo -e $target_md5 | cut -b 1-32`;
	source_md5=`md5sum ./$filename`;
	source_md5=`echo -e $source_md5 | cut -b 1-32`;
	
	# MD5值如果相同，则直接覆盖已存在文件。如果不相同，修改源文件名，以源文件名
	# 加上MD5前8位值组成的新文件名移动保留两个文件。
	if [ "$target_md5" = "$source_md5" ]; then
		echo -e "${cmd_debug} - \033[32mMD5 equality!\033[0m $filename move to ./$target_dir/$filename";
		if [ "$cmd_debug" = "normal" ]; then
			mv $filename ./$target_dir/$filename
		fi
	else
		source_md5=`echo -e $source_md5 | cut -b 1-8`;
		echo -e "${cmd_debug} - \033[32mSave both!\033[0m ${filename} move to ./$target_dir/${filename%.*}-${source_md5}.${filename##*.}";
		if [ "$cmd_debug" = "normal" ]; then
			mv $filename ./$target_dir/${filename%.*}-${source_md5}.${filename##*.};
		fi
	fi
else
	echo -e "${cmd_debug} - ${filename} move to ./$target_dir/$filename";
	if [ "$cmd_debug" = "normal" ]; then
		mv $filename ./$target_dir/$filename;
	fi
fi

exit 0;
}

