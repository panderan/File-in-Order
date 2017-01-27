#!/usr/bin/awk

Begin{
}
{
	datestr=$6;
	filename=$8;
	fileclass="15_CompressionFiles";

	# Verify the parameters
	if (NR == 1) {
		cmd_type=$1;
		cmd_debug=$2;
		next;
	}
	else {
		if (cmd_type != "compressionfile") {
			printf("\033[31mError Cmd\033[0m, need \"conpressionfile\" specified.\n");
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
	if (system("echo "filename" | grep -i -P '\\.rar$|\\.zip$|\\.7z$|\\.tar$' > /dev/null")) {
		printf("\033[33mNot a compression file\033[0m - "filename"\n");
		next;
	}

	# Rename or move picture.
	if (!system("echo "filename" | grep -i -P '\\d{4}-\\d{2}\\.\\w{8,32}\\.rar$|\\d{4}-\\d{2}\\.\\w{8,32}\\.zip$|\\d{4}-\\d{2}\\.\\w{8,32}\\.7z$|\\d{4}-\\d{2}\\.\\w{8,32}\\.tar$' > /dev/null")) {
		system("./_script/mv.sh "filename" ./"fileclass" "cmd_debug);
	}
	else {
		name_prefix=filename;
		gsub(".rar","",name_prefix); gsub(".RAR","",name_prefix);
		gsub(".zip","",name_prefix); gsub(".ZIP","",name_prefix);
		gsub(".7z","",name_prefix);  gsub(".7Z","",name_prefix);
		gsub(".tar","",name_prefix); gsub(".TAR","",name_prefix);
		system("./_script/rename.sh "filename" "datestr" "name_prefix" "cmd_debug);
	}
}
End {
}

