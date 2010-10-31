#!/bin/sh
LOGIN_SCRIPT_URL=https://login.ruw.rutgers.edu/login.pl
http_prog=

usage () {
	echo "usage: 	"
	echo "	$0 login [username [password]]"
	echo "	$0 logout"
	echo "	$0 status"
	exit 1
}

read_pass () {
	if [ $# -ne 2 ]; then
		echo "read_pass: arg count"
		return 5
	fi

	trap "stty echo;echo ;exit 1;" INT TERM EXIT	

	stty -echo
	read -p $1 $2; echo
	stty echo

	trap - INT TERM EXIT

	return 0
}

warn () {
	printf "%s\n" "$1" >> /dev/stderr
}

contains () {
	echo "$1" | grep -q "$2"
}


check_status2 () {
	error=`echo "$1" | grep "\"error\"" \
		| cut -d'=' -f 4 | sed 's. />..' \
		| tr -d '\n'`

	case "$error" in
	"*You are already logged in*")
		warn "logged in already"
		return 1
		;;
	"*This link is not valid*")
		warn "invalid logout link"
		return 1
		;;
	"Thank you for signing in.")
		warn "successfully logged in"
		return 0
		;;
	"A valid IP address could not be determined.  Please seek help from your Systems Administrator.")
		warn "probably not on RUWireless (no valid ip)"
		return 1
		;;
	*)	
		printf "RUWireless says: "
		echo "$error"
		return 2
		;;
	esac
}

# takes 1 param: the ruwireless page.
check_status () {
	if contains "$1" "You are already logged in"; then
		warn "logged in already"
		return 1
	elif contains "$1" "This link is not valid"; then
		warn "invalid logout link"
		return 1
	elif contains "$1" "Thank you for signing in."; then
		warn "successfully logged in"
		return 0
#	elif contains "$1" "A valid IP address could not be determined.  Please seek help from your Systems Administrator."; then
#		warn "probably not on RUWireless (no valid ip)"
#		return 1
	else	
		printf "RUWireless says: "
		echo "$1" | grep "\"error\"" \
			| cut -d'=' -f 4 | sed 's. />..' \
			| tr -d '\n'
		echo
		return 2
	fi
}

ruw_login () {
	# Login
	local ru_user ru_pass

	if [ $# -eq 1 ]; then
		read -p "Username: " ru_user
		read_pass "Password:  " ru_pass
	elif [ $# -eq 2 ]; then
		ru_user=$2
		read_pass "Password:  " ru_pass
	elif [ $# -eq 3 ]; then
		ru_user=$2
		ru_pass=$3
	else
		echo "error: incorrect parameters to login"
		usage
	fi


	login_page=$(curl -k -s $LOGIN_SCRIPT_URL)
	#login_page=$(wget -q \
	#	--postdata="bs_name=$ru_user&bs_password=$ru_pass"
	#	${LOGIN_URL}'?which_form="reg";_FORM_SUBMIT="1"'
	#	)
		
	check_status "$login_page"	
	ip=`echo "$login_page" | grep -E -o \
			'([0-9]{1,3}\.){3}[0-9]{1,3}' \
	    | tr '\n' '\t' | cut -f 1`
	
	echo "your ip is : $ip"

	login_page=$(curl -k -s                         \
		--form-string bs_name="$ru_user"	\
		--form-string bs_password="$ru_pass"    \
		-F which_form="reg"	                \
		-F _FORM_SUBMIT="1"	                \
		-F error=""		                \
		-F destination=""		        \
		-F source="$ip"		                \
		$LOGIN_SCRIPT_URL	                \
		)
	
	check_status "$login_page"	
}

ruw_logout () {
	if [ $# -ne 2 ]; then
		lpop=$(curl -k -s \
			-F action="logoutPopup" \
			$LOGIN_SCRIPT_URL)
	
		lline=$(echo "$lpop" | grep 'var theUrl')
		ip=$(echo "$lline"| cut -d';' -f 2\
			| cut -d'=' -f 2)
		uid=$(echo "$lline"| cut -d';' -f 3 \
			| cut -d'=' -f 2 | sed "s/'//")
	
		
		echo "--- logout pop ---"
		echo "$lpop"
		echo "--- end logout pop ---"
	
	
		echo "ip: $ip"
		echo "uid: $uid"
	else
		echo "IP : $1"
	fi
	
# var im_blue = true;
# var theUrl = '/login.pl?action=logout;source=172.31.48.103;r=huDVz5q2725';
# var lockU = 1;
	
	logout_cmd="curl -k  \
		-F action=logout \
		-F source=$ip    \
		-F r=$uid        \
		${LOGIN_SCRIPT_URL}"
		
	echo "logout_cmd: $logout_cmd"
	
	logout_page=$(curl -k    \
     -F action=logout	     \
     -F source=$ip	         \
	 -F r=""               \
     $LOGIN_SCRIPT_URL)
	 
	echo "${LOGIN_SCRIPT_URL}"'?action=logout;source='"$ip"';r='"$uid"
	#logout_page=$(wget -q \
	#	"${LOGIN_SCRIPT_URL}?action=logout;source=$ip;r=$uid;"\
	#	-O -)
	
	echo "--- logout page ---"
	echo "$lpop"
	echo "--- end logout page ---"
	
	check_status "$logout_page"
}

get_page () {
	curl $*
}

get_ip_and_uid () {
	#local first_page=$(curl -m 1 -s $LOGIN_SCRIPT_URL)
	local first_page=$(get_page "$LOGIN_SCRIPT_URL")
	if [ -z "$first_page" ]; then
		return 2
	fi
	
	local source_ip=$(echo "\'$first_page\'" \
		| grep -E -o \
			'([0-9]{1,3}\.){3}[0-9]{1,3}' )
	
}

ruw_status () {
	local first_page source_ip
	# If not logged in: contains the login form (with 'source' IP and 'destination' URL)
	# If logged in		: contains the login form (with 'error' = "You are already logged in")
	first_page=$(get_page "$LOGIN_SCRIPT_URL")

	if [ -z "$first_page" ]; then
		echo "error: failed to get login page"
		return '1'
	fi

	source_ip=$(echo "\'$first_page\'" \
		| grep -E -o \
			'([0-9]{1,3}\.){3}[0-9]{1,3}')

	printf "%s\n" "$first_page"
	echo -n "Source IP : "
	echo $source_ip

}

find_reqs () {
	if [[ $(which "curl") ]]; then
		http_prog="curl"
		return 0
	elif [[ $(which "wget") ]]; then
		return 0
	else
		echo blah
		return 1
	fi		
}

# MAIN

if [ $# -lt 1 ]; then
	usage
fi

if ( ! find_reqs ); then
	echo "Need Curl or Wget"
	exit 2
fi

case $1 in
"logout") ruw_logout $@;;

"login")  ruw_login $@;;

"status") ruw_status;;
*)	echo "error: unrecognized action"
	usage;;
esac

exit 0


