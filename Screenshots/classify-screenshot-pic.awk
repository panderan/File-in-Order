#!/usr/bin/awk

Begin{
}
{
	datestr=$6;
	filename=$8;
	fileclass="Screenshots";

	# Verify the parameters
	if (NR == 1) {
		cmd_type=$1;
		cmd_debug=$2;
		cmd_debug2=$3;
		next;
	}
	else {
		if (cmd_type != "screenshot") {
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
	if (system("echo "filename" | grep -i -P '\\.jp[e]*g$|\\.gif$|\\.png$' > /dev/null")) {
		printf("\033[33mNot a Picture file\033[0m - "filename"\n");
		next;
	}

	# Exclude pictures which have incorrect name.
	if (system("echo "filename" | grep -i -P 'screenshot' > /dev/null")) {
		printf("\033[33mNot a Screenshot Picture file\033[0m - "filename"\n");
		next;
	}
	
	# Correct name, move it. 
	#if (!system("echo "filename" | grep -i -P '^screenshot-\\d{4}-\\d{2}.\\w{8,32}\\.jp[e]*g$' > /dev/null") ||
	#	!system("echo "filename" | grep -i -P '^screenshot-\\d{4}-\\d{2}.\\w{8,32}\\.png$' > /dev/null")  ||
	#	!system("echo "filename" | grep -i -P '^screenshot-\\d{4}-\\d{2}.\\w{8,32}\\.gif$' > /dev/null")) {
	#	system("./_script/mv.sh "filename" ./"fileclass" "cmd_debug);
	#	next;
	#}

	# Carry file.
	system("./_script/porter.sh "filename" "datestr" screenshot ./"fileclass" "cmd_debug" "cmd_debug2);
	
}
End {
}
