
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

