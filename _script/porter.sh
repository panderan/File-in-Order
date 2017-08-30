#!/bin/bash

. ./_script/rename.sh
. ./_script/mv.sh

filename=$1;
datestr=$2;
rename_type=$3;
fileclass=$4
cmd_debug_rename=$5;
cmd_debug_mv=$6;

fc_rename $filename $datestr $rename_type $cmd_debug_rename;
porter_newfilename=$fc_rename_newfilename;

if [ "$cmd_debug_rename" = "debug" ];then 
	exit 0;
fi

if [ -z $porter_newfilename ]; then 
	echo -e "Failed to get new file name\n";
else
	fc_mv $porter_newfilename $fileclass $cmd_debug_mv;
fi

