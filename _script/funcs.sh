#!/bin/bash

# Usage
#  get_newfilename <source file name> <date string> <new file name prefix>
#  output:
#    -ret_get_newfilename_name : new file name;
#    -ret_get_newfilename_type : 

ret_get_newfilename_name="";
ret_get_newfilename_type="";

function get_newfilename(){

	l_orifilename=$1;
	l_datestr=$2;
	l_prefix=$3;
	l_newfilename="";

	# 输入参数检查
	if [ "$l_orifilename" = "" -o "$l_datestr" = "" -o "$l_prefix" = "" ]; then
		echo -e "\033[31mError, get_newfilename require arguments"
		return 1;
	fi


	# 提取时间信息
	l_year=`echo -e $l_datestr | cut -b 1-4`;
	l_month=`echo -e $l_datestr | cut -b 6-7`;

	# 获取MD5值前8位
	l_orimd5str=`md5sum ./$l_orifilename`;
	l_orisub_md5str=`echo -e $l_orimd5str | cut -b 1-8`;

	# 获得新文件名
	l_newfilename="$l_prefix-$l_year-$l_month.$l_orisub_md5str.${l_orifilename##*.}";

	#  检测新文件名是否存在
	if [ -f "$l_newfilename" ]; then
		l_newmd5str=`md5sum ./$l_newfilename`;
		l_orimd5str=`md5sum ./$l_orifilename`;
		for ((i=1;i<33;i++))
		do
			tmp_new=`echo -e $l_newmd5str | cut -b 1-$i`;
			tmp_ori=`echo -e $l_orimd5str | cut -b 1-$i`;

			# 返回更长的不同于已存在目标文件的MD5子串的目标名
			if [ "$tmp_new" != "$tmp_ori" ]; then
				l_newfilename="$l_prefix-$l_year-$l_month.$tmp_ori.${l_orifilename##*.}";
				ret_get_newfilename_name=$l_newfilename;
				ret_get_newfilename_type="md5 part equal";
				return 0;
			fi
		done

		# 源文件和目的文件MD5一致，返回相同目的文件名
		ret_get_newfilename_name="$l_prefix-$l_year-$l_month.$l_orisub_md5str.${l_orifilename##*.}";
		ret_get_newfilename_type="md5 equal";
		return 0;

	else
		# 返回新文件名
		ret_get_newfilename_name=$l_newfilename;
		ret_get_newfilename_type="new";
		return 0;
	fi
}

