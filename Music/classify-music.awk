#!/usr/bin/awk

Begin{
}
{
	datestr=$6;
	filename=$8;
	fileclass="Music";

	# Verify the parameters
	if (NR == 1) {
		cmd_type=$1;
		cmd_debug=$2;
		cmd_debug2=$3;
		next;
	}
	else {
		if (cmd_type != "music") {
			printf("\033[31mError Cmd\033[0m, need \"music\" specified.\n");
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
	if (system("echo "filename" | grep -i -P '\\.mp3$|\\.wma$|\\.m4a$' > /dev/null")) {
		printf("\033[33mNot a Music file\033[0m - "filename"\n");
		next;
	}

	# Rename or move picture.
	#if (!system("echo "filename" | grep -i -P '\\d{4}-\\d{2}\\.\\w{8,32}\\.mp3$|\\d{4}-\\d{2}\\.\\w{8,32}\\.wma$|\\d{4}-\\d{2}\\.\\w{8,32}\\.m4a$' > /dev/null")) {
	#	system("./.script/mv.sh "filename" ./"fileclass" "cmd_debug);
	#}
	#else {
		name_prefix=filename;
		gsub(".mp3","",name_prefix); gsub(".MP3","",name_prefix);
		gsub(".wma","",name_prefix); gsub(".WMA","",name_prefix);
		gsub(".m4a","",name_prefix); gsub(".M4A","",name_prefix);
		#system("./.script/rename.sh "filename" "datestr" "name_prefix" "cmd_debug);
		system("./.script/porter.sh "filename" "datestr" "name_prefix" ./"fileclass" "cmd_debug" "cmd_debug2);
	#}
}
End {
}

