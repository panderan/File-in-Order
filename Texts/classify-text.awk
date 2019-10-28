#!/usr/bin/awk

Begin{
}
{
	datestr=$6;
	filename=$8;
	fileclass="Texts";

	# Verify the parameters
	if (NR == 1) {
		cmd_type=$1;
		cmd_debug=$2;
		cmd_debug2=$3;
		next;
	}
	else {
		if (cmd_type != "text") {
			printf(NR"/"total_files" \033[31mError Cmd\033[0m, need \"text\" specified.\n");
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
		printf(NR"/"total_files" \033[33mSource file is not found\033[0m - "filename"\n");
		next;
	}

	# Exclude formats which unsupported.
	if (system("echo "filename" | grep -i -P '\\.txt$|\\.md$' > /dev/null")) {
		printf(NR"/"total_files" \033[33mNot a text file\033[0m - "filename"\n");
		next;
	}

	# Rename or move picture.
	#if (!system("echo "filename" | grep -i -P '\\d{4}-\\d{2}\\.\\w{8,32}\\.txt$' > /dev/null")) {
	#	system("./.script/mv.sh "filename" ./"fileclass" "cmd_debug);
	#}
	#else {
		name_prefix=filename;
		gsub(".txt","",name_prefix); gsub(".TXT","",name_prefix);
		gsub(".md","",name_prefix); gsub(".MD","",name_prefix);
		#system("./.script/rename.sh "filename" "datestr" "name_prefix" "cmd_debug);
        printf(NR"/"total_files" ");
		system("./.script/porter.sh "filename" "datestr" "name_prefix" ./"fileclass" "cmd_debug" "cmd_debug2);
	#}
}
End {
}

