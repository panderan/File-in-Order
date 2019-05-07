#!/usr/bin/awk

Begin{
}
{
	datestr=$6;
	filename=$8;
	fileclass="WeiXin";

	# Verify the parameters
	if (NR == 1) {
		cmd_type=$1;
		cmd_debug=$2;
		cmd_debug2=$3;
		next;
	}
	else {
		if (cmd_type != "wechat") {
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
	if (system("echo "filename" | grep -i -P '\\.jp[e]*g$|\\.gif$|\\.png$|\\.mp4$' > /dev/null")) {
		printf("\033[33mNot a Picture or Video file\033[0m - "filename"\n");
		next;
	}

	# Exclude pictures which have incorrect name.
	if (system("echo "filename" | grep -i -P '^microMsg|^mmexport|^wx_camera' > /dev/null")) {
		printf("\033[33mNot a Wechat Picture file\033[0m - "filename"\n");
		next;
	}

	# Correct name, move it. 
	#if (!system("echo "filename" | grep -i -P '^microMsg-\\d{4}-\\d{2}\\.\\w{8,32}\\.jp[e]?g$' > /dev/null")) {
	#	system("./.script/mv.sh "filename" ./"fileclass" "cmd_debug);
	#	next;
	#}
	#if (!system("echo "filename" | grep -i -P '^mmexport-\\d{4}-\\d{2}\\.\\w{8,32}\\.jp[e]?g$|^mmexport-\\d{4}-\\d{2}\\.\\w{8,32}\\.gif$' > /dev/null")) {
	#	system("./.script/mv.sh "filename" ./"fileclass" "cmd_debug);
	#	next;
	#}
	
	# Carry file
	if (!system("echo "filename" | grep -i -P '^microMsg[a-z0-9A-Z._\\-]*\\.jp[e]?g$' > /dev/null")) {
		system("./.script/porter.sh "filename" "datestr" microMsg ./Images/"fileclass" "cmd_debug" "cmd_debug2);
	}
	else if (!system("echo "filename" | grep -i -P '^mmexport[a-z0-9A-Z._\\-]*\\.jp[e]?g$|^mmexport[a-z0-9A-Z._\\-]*\\.gif$' > /dev/null")) {
		system("./.script/porter.sh "filename" "datestr" mmexport ./Images/"fileclass" "cmd_debug" "cmd_debug2);
	}
	else if (!system("echo "filename" | grep -i -P '^wx_camera[a-z0-9A-Z._\\-]*\\.mp4$' > /dev/null")) {
		system("./.script/porter.sh "filename" "datestr" wx_camera ./Images/"fileclass" "cmd_debug" "cmd_debug2);
	}
	else {
		printf("Not Match - "filename"\n");
		}

}
End{
}


