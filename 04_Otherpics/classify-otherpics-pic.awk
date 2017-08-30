#!/usr/bin/awk

Begin{
}
{
	datestr=$6;
	filename=$8;
	fileclass="04_OtherPics";

	# Verify the parameters
	if (NR == 1) {
		cmd_type=$1;
		cmd_debug=$2;
		cmd_debug2=$3;
		next;
	}
	else {
		if (cmd_type != "otherpic") {
			printf("\033[31mError Cmd\033[0m, need \"wechat\" specified.\n");
			exit;
		}
	}

	# Ignore directory file
	if (system("! test -d "filename)) {
		printf("\033[33mDirectory File or NULL\033[0m, Ignore - "filename"\n");
		next;
	}
	
	# Verify the existence of source file
	if (system("test -f "filename)) {
		printf("\033[33mSource file is not found\033[0m - "filename"\n");
		next;
	}

	# Exclude formats which unsupported.
	if (system("echo "filename" | grep -i -P '\\.jp[e]*g$|\\.gif$|\\.png$|\\.bmp$' > /dev/null")) {
		printf("\033[33mNot a Picture file\033[0m - "filename"\n");
		next;
	}

	# Rename and move picture.
	system("./_script/porter.sh "filename" "datestr" otherpic ./"fileclass" "cmd_debug" "cmd_debug2);

	#if (!system("echo "filename" | grep -i -P '^otherpic-\\d{4}-\\d{2}\\.\\w{8,32}' > /dev/null")) {
	#	system("./_script/mv.sh "filename" ./"fileclass" "cmd_debug);
	#}
	#else {
	#	system("./_script/rename.sh "filename" "datestr" otherpic "cmd_debug);
	#}
}
End {
}

