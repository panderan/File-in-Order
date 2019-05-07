#!/usr/bin/awk

Begin{
}
{
	year="";
	month="";
	filename=$8;
	fileclass="Camera";

	# Verify the parameters
	if (NR == 1) {
		cmd_type=$1;
		cmd_debug=$2;
		cmd_regstr=$4;
		next;
	}
	else {
		if (cmd_type != "createdtime") {
			printf("\033[31mError Cmd\033[0m, need \"createdtime\" specified.\n");
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
	if (!system("echo "filename" | grep -i '\\.jpg$' > /dev/null") || 
		!system("echo "filename" | grep -i '\\.3gp$' > /dev/null") ||
		!system("echo "filename" | grep -i '\\.mov$' > /dev/null") ||
		!system("echo "filename" | grep -i '\\.mp4$' > /dev/null") ||
		!system("echo "filename" | grep -i '\\.avi$' > /dev/null")) {
		year=substr($6,1,4);
		month=substr($6, 6,2);
	}
	else {
		printf("\033[33mNot a Camera file\033[0m : "filename"\n")
		next;
	}
	
	# Verify the file name.
	if (system("echo "filename" | grep -i -P '"cmd_regstr"' > /dev/null")) {
		printf("\033[33mFile name is not match the regular expression \033[0m : "filename" - /"cmd_regstr"/\n")
		next;
	}

	# Verify the date of current picture. 
	if (year < 0 || year > 3000 || month < 0 || month > 13) {
		printf("\033[31mError Time\033[0m :"year"年"month"月\n");
		next;
	}
	
	# Verify the existence of target directory 
	dir_name="./Images/"fileclass"/"year"年"month"月";
	if (system("test -d ./"dir_name)) {
		if (cmd_debug == "normal") {
			system("mkdir ./"dir_name);
		}
	}
	
	system("./.script/fc_mv.sh "filename" "dir_name" "cmd_debug);
}
End {
}
