#!/usr/bin/awk

Begin{
}
{
	datestr=$6;
	filename=$8;
	fileclass="Archives";

	# Verify the parameters
	if (NR == 1) {
		cmd_type=$1;
		cmd_debug=$2;
		cmd_debug2=$3;
		next;
	}
	else {
		if (cmd_type != "compressionfile") {
			printf(NR"/"total_files" \033[31mError Cmd\033[0m, need \"conpressionfile\" specified.\n");
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
	if (system("echo "filename" | grep -i -P '\\.rar$|\\.zip$|\\.7z$|\\.tar$' > /dev/null")) {
		printf(NR"/"total_files" \033[33mNot a compression file\033[0m - "filename"\n");
		next;
	}

	# Rename or move picture.
	#if (!system("echo "filename" | grep -i -P '\\d{4}-\\d{2}\\.\\w{8,32}\\.rar$|\\d{4}-\\d{2}\\.\\w{8,32}\\.zip$|\\d{4}-\\d{2}\\.\\w{8,32}\\.7z$|\\d{4}-\\d{2}\\.\\w{8,32}\\.tar$' > /dev/null")) {
	#	system("./.script/mv.sh "filename" ./"fileclass" "cmd_debug);
	#}
	#else {
		name_prefix=filename;
		gsub(".rar","",name_prefix); gsub(".RAR","",name_prefix);
		gsub(".zip","",name_prefix); gsub(".ZIP","",name_prefix);
		gsub(".7z","",name_prefix);  gsub(".7Z","",name_prefix);
		gsub(".tar","",name_prefix); gsub(".TAR","",name_prefix);
		#system("./.script/rename.sh "filename" "datestr" "name_prefix" "cmd_debug);
        printf(NR"/"total_files" ");
		system("./.script/porter.sh "filename" "datestr" "name_prefix" ./"fileclass" "cmd_debug" "cmd_debug2);
	#}
}
End {
}

