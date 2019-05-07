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
		cmd_debug2=$3;
		next;
	}
	else {
		if (cmd_type != "name") {
			printf("\033[31mError Cmd\033[0m, need \"name\" specified.\n");
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

	# Filename type 1: "IMG_20130810_123456"
	if (!system("echo "filename" | grep -i -P '^IMG_\\d{8}_\\d{6}' >/dev/null")) {
		year=substr(filename,5,4);
		month=substr(filename,9,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}

	# Filename type 1: "IMG20130810"
	else if (!system("echo "filename" | grep -i -P '^IMG\\d{8}' > /dev/null")) {
		year=substr(filename,4,4);
		month=substr(filename,8,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}

	# Filename type 2: "IMG0001A.JPG"
	else if (!system("echo "filename" | grep -i -P '^IMG\\w{5,10}' > /dev/null")) {
		year=substr($6,1,4);
		month=substr($6,6,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}

	# Filename type 3: "VID_20140826_123456"
	else if (!system("echo "filename" | grep -i -P '^VID_\\d{8}_\\d{6}' > /dev/null")) {
		year=substr(filename,5,4);
		month=substr(filename,9,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}

	# Filename type 4: "PANO_20140826_123456"
	else if (!system("echo "filename" | grep -i -P '^PANO_\\d{8}_\\d{6}' > /dev/null")) {
		year=substr(filename,6,4);
		month=substr(filename,10,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}

	# Filename type 5: "MYXJ_20140826_123456"
	else if (!system("echo "filename" | grep -i -P '^MYXJ_\\d{8}_\\d{6}' > /dev/null")) {
		year=substr(filename,6,4);
		month=substr(filename,10,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}

	# Filename type 6: "2015-09-09_1441762472509"
	else if (!system("echo "filename" | grep -i -P '^\\d{4}-\\d{2}-\\d{2}_\\d*' > /dev/null")) {
		year=substr(filename,1,4);
		month=substr(filename,6,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}

	# Filename type 7: "2015_09_09_14_41_76.jpg"
	else if (!system("echo "filename" | grep -i -P '^\\d{4}_\\d{2}_\\d{2}_\\d{2}_\\d{2}_\\d{2}' > /dev/null")) {
		year=substr(filename,1,4);
		month=substr(filename,6,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}

	# Filename type 8: "20150101123.jpg"
	else if (!system("echo "filename" | grep -i -P '^\\d{8,16}\\.jpg' > /dev/null")) {
		year=substr(filename,1,4);
		month=substr(filename,5,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}

	# Filename type 9: "MTXX_20160101123456.JPG"
	else if (!system("echo "filename" | grep -i -P '^MTXX_\\d{14}\\.jpg' > /dev/null")) {
		year=substr(filename,6,4);
		month=substr(filename,10,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}

	# Filename type 10: "DSC00449.JPG"
	else if (!system("echo "filename" | grep -i -P '^DSC\\d{5,10}\\.jpg' > /dev/null")) {
		year=substr($6,1,4);
		month=substr($6,6,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}

	# Filename type 11: "wx_camera_1234567898765.jpg"
	else if (!system("echo "filename" | grep -i -P '^wx_camera_\\d{13}\\.jpg' > /dev/null")) {
		year=substr($6,1,4);
		month=substr($6,6,2);
		#printf("\033[32m"fileclass"\033[0m:"filename", "year"年"month"月\n");
	}
	else {
		printf("\033[35mNot match\033[0m - "filename"\n");
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
End{
}
