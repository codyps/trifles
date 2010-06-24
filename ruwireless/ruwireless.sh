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
		return '-1'
	fi

	trap "stty echo;echo ;exit 1;" INT TERM EXIT	

	stty -echo
	read -p $1 $2; echo
	stty echo

	trap - INT TERM EXIT

	return 0
}

# takes 1 param: the ruwireless page.
check_status () {
	if echo "$1" \
		| grep "You are already logged in" \
		> /dev/null ; then
		echo "logged in already"
	fi
	
	if echo "$1" \
		| grep "This link is not valid" \
		> /dev/null; then
		echo "invalid logout link"
	fi
	
	if echo "$1" \
		| grep "Thank you for signing in." \
		> /dev/null; then
		echo "successfully logged in"
	fi
	
	echo "$1" | grep "\"error\"" \
		| cut -d'=' -f 4 | sed 's. />..' \
		| tr -d '\n'
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

	login_page=$(wget -q \
		--postdata="bs_name=$ru_user&bs_password=$ru_pass"
		${LOGIN_URL}'?which_form="reg";_FORM_SUBMIT="1"'
		)
		
	#login_page=$(curl -k -s                 \
		--form-string bs_name="$ru_user"	\
		--form-string bs_password="$ru_pass"\
		-F which_form="reg"	                \
		-F _FORM_SUBMIT="1"	                \
		-F error=""		                    \
		-F destination=""		            \
		-F source=""		                \
		$LOGIN_SCRIPT_URL	                \
		)
	
	echo -n "your ip is : "
    echo "$login_page" \
		| grep -E -o \
			'([0-9]{1,3}\.){3}[0-9]{1,3}' \
	    | tr '\n' '\t' | cut -f 1
	
	check_status "$login_page"	
}

ruw_logout () {
	if [ $# -ne 2 ]; then
		lpop=$( curl -k -s \
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
	if [ $http_prog = "curl" ]; then
		curl -k -m 1 -s $1
	elif [ $http_prog = "wget"]; then
		wget -T 1 -q -O - $1
	else
		echo "wat"
	fi		
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
	echo -n "Source IP : "
	echo $source_ip
}

find_reqs () {
	if [[ $(which "curl") ]]; then
		http_prog="curl"
		return 1
	elif [[ $(which "wget") ]]; then
		return 1
	else
		return 0
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
*)echo "error: unrecognized action"
	usage;;
esac

exit 0


#--- OLD CODE ---

if [ $1 = "login" ]; then  
	# Login
  local ru_user ru_pass login_page uids
	
	if [ $# = 1 ]; then
		read -p "Username: " ru_user
		stty -echo
		read -p "Password: " ru_pass; echo
		stty echo
	elif [ $# = 2 ]; then
		ru_user=$2
		#read in password
		stty -echo
		read -p "Password: " ru_pass; echo
		stty echo
	elif [ $# = 3 ]; then
		ru_user=$2
		ru_pass=$3
	else
		echo "error: incorrect parameters to login"
		usage
	fi
  
  login_page=$(curl -s	\
   -F _FORM_SUBMIT="1"	\
   -F which_form="reg"	\
   -F destination=""	\
   -F source=""		\
   -F error=""		\
   -F bs_name=$ru_user	\
   -F bs_password=$ru_pass \
   -c ruwireless.cookies \
   $LOGIN_SCIPRT_URL)
  
  if echo $login_page | grep -q "action=logout"; then
    echo "login successful"

    echo -n "your ip is : "
    echo $login_page | grep -E -o '([0-9]{1,3}\.){3}[0-9]{1,3}'\
	| cut -d $new_line -f 1

    echo "your uid(s) is(are) : "
    uids=$(echo $login_page | grep -E -o 'r=[[:alnum:]]{11}'\
	| cut -d = -f 2)
    echo -n "\t"
    echo uids | cut -d $new_line -f 1
    echo -n "\t"
    echo uids | cut -d $new_line -f 2

  elif echo $login_page | grep -q "already logged in"; then
    echo " you are already logged in"
    echo $login_page > ruwireless.alreadyin
  else
    local tmp
    tmp=$(tempfile)
    echo $login_page > tmp
    echo " login parse failed, wrote login page to $tmp"
  fi
  # End login
elif test $# = 1; then
  if test $1 = "info"; then
    # Check Status
    echo " info unimplimented"
    # End status
  else
    # Logout
    local id ip logout_page logoutPopup_page
    
    logoutPopup_page=$(
      curl -s \
        -F action="logoutPopup" \
 	$URL)

    ip=$(echo $logoutPopup_page | grep -E -o '([0-9]{1,3}\.){3}[0-9]{1,3}')
    id=$(echo $logoutPopup_page | grep -E -o 'r=[[:alnum:]]{11}'\
        | cut -d'='  -f 2)

    ip=`echo $ip | cut -d $new_line -f 1`
    id=`echo $id | cut -d $new_line -f 1`

    echo $ip
    echo $id

    logout_page=$(curl -s \
     -F action="logout"	\
     -F source="$ip"	\
     -F r="$id"	\
     $URL)

    echo $logout_page > ruwireless.logout
    echo $logoutPopup_page > ruwireless.popup

    if echo $logout_page | grep -q "This link is not valid for your current session."; then
      echo " invalid logout link"
    fi

    if test $1 = "logout"; then
      echo $logout_page
    elif test $1 = "popup"; then
      echo $logoutPopup_page
    fi
    # End logout
  fi
else
  # Usage
  echo "usage:"
  echo "  login>  $0 <user> <pass>"
  echo "  logout> $0 <login_id>"
fi

