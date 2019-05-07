#!/usr/bin/awk

Begin{
}
{
	datestr=$6;
	filename=$8;
	fileclass="Excel";

	# Verify the parameters
	if (NR == 1) {
		cmd_type=$1;
		cmd_debug=$2;
		cmd_debug2=$3;
		next;
	}
	else {
		if (cmd_type != "excel") {
			printf("\033[31mError Cmd\033[0m, need \"excel\" specified.\n");
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
	if (system("echo "filename" | grep -i -P '\\.xls$|\\.xlsx$' > /dev/null")) {
		printf("\033[33mNot a Excel file\033[0m - "filename"\n");
		next;
	}

	# Rename or move picture.
	#if (!system("echo "filename" | grep -i -P '\\d{4}-\\d{2}\\.\\w{8,32}\\.xls$|\\d{4}-\\d{2}\\.\\w{8,32}\\.xlsx$' > /dev/null")) {
	#	system("./_script/mv.sh "filename" ./"fileclass" "cmd_debug);
	#}
	#else {
		name_prefix=filename;
		gsub(".xlsx","",name_prefix); gsub(".XLSX","",name_prefix);
		gsub(".xls","",name_prefix);  gsub(".XLS","",name_prefix);
		#system("./_script/rename.sh "filename" "datestr" "name_prefix" "cmd_debug);
		system("./_script/porter.sh "filename" "datestr" "name_prefix" ./"fileclass" "cmd_debug" "cmd_debug2);
	#}
}
End {
}

