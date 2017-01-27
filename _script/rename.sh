#!/bin/bash

# Usage
#  rename.sh <source file name> <date string> <type> <debug>
#  
#  <type> must one of the following:
#    -microMsg, output file name like microMsg-<year>-<month>.<str>.<format>

#  <debug> has two options, one is "debug", it mean print message but do not 
#   execute to actual cmd. another is "normal" which mean do actually what
#   you want.

filename=$1;
datestr=$2;
rename_type=$3;
cmd_debug=$4;
is_cover="";

. ./_script/funcs.sh;
#. ./funcs.sh;

# 检查参数
if [ "$filename" = "" -o "$datestr" = "" -o "$rename_type" = "" -o "$cmd_debug" = "" ]; then
	echo -e "\033[31mError\033[0m, one or more args are not specific.";
	exit 1;
fi

# 检查源文件是否存在
if [ ! -f $filename ]; then
	echo -e "\033[31mError\033[0m, $filename is non-exist\n";
	exit 1;
fi

# 检查时间字符串
if [ ! `echo -e "$datestr" | grep -i -P '^\d{4}-\d{2}-\d{2}$'` ]; then
	echo -e "\033[31mError\033[0m, date string is unrecognized : $datestr";
	exit 1;
fi


# 重命名操作
	get_newfilename "$filename" "$datestr" "$rename_type";
	newfilename=$ret_get_newfilename_name;
	if [ "$cmd_debug" = "normal" ]; then
		if [ -f $newfilename ]; then
			mv $filename $newfilename;  # 两文件MD5相同，覆盖操作
			is_cover="(cover origin file)"
		else
			#
			# rename not worked well in cygwin,
			# replace it by mv.
			#
			# rename 's/'$filename'/'$newfilename'/' $filename; 
			mv $filename $newfilename                           
		fi
	fi
	echo -e "$cmd_debug - $filename is rename to $newfilename $ret_get_newfilename_type $is_cover";

exit 0;

