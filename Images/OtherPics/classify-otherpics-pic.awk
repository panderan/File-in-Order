#!/usr/bin/awk

Begin{
}
{
	datestr=$6;
	filename=$8;
	fileclass="OtherPics";

	# Verify the parameters
	if (NR == 1) {
		cmd_type=$1;
		cmd_debug=$2;
		cmd_debug2=$3;
		next;
	}
	else {
		if (cmd_type != "otherpic") {
			printf(NR"/"total_files" \033[31mError Cmd\033[0m, need \"otherpic\" specified.\n");
			exit;
		}
	}

	# Ignore directory file
	if (system("! test -d "filename)) {
		printf(NR"/"total_files" \033[33mDirectory File or NULL\033[0m, Ignore - "filename"\n");
		next;
	}
	
	# Verify the existence of source file
	if (system("test -f "filename)) {
		printf(NR"/"total_files" \\033[33mSource file is not found\033[0m - "filename"\n");
		next;
	}

	# Exclude formats which unsupported.
	if (system("echo "filename" | grep -i -P '\\.jp[e]*g$|\\.gif$|\\.png$|\\.bmp$' > /dev/null")) {
		printf(NR"/"total_files" \033[33mNot a Picture file\033[0m - "filename"\n");
		next;
	}

	# Rename and move picture.
	system("./.script/porter.sh "filename" "datestr" otherpic ./Images/"fileclass" "cmd_debug" "cmd_debug2);

	#if (!system("echo "filename" | grep -i -P '^otherpic-\\d{4}-\\d{2}\\.\\w{8,32}' > /dev/null")) {
	#	system("./.script/mv.sh "filename" ./"fileclass" "cmd_debug);
	#}
	#else {
	#	system("./.script/rename.sh "filename" "datestr" otherpic "cmd_debug);
	#}
}
End {
}

