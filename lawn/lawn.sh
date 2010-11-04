#! /bin/sh

logout_url='https://login.cs.rutgers.edu/wireless/servlet/logout.jsp'
form_url='https://login.cs.rutgers.edu/wireless/jsp/login.jsp'
post_url='https://login.cs.rutgers.edu/wireless/servlet/Submit'

error() {
	printf $* >> /dev/stderr
	printf "\n" >> /dev/stderr
	exit 1
}

get_page() {
	`curl -b lawn.cookies -c lawn.cookies -D lawn.header $*`
}

page=`get_page $post_url`

not_on_lawn_str='You do not appear to be on a trusted LAWN wireless network'

if printf "%s" "$page" | grep -q "$not_on_lawn_str"; then
	error "Not on a lawn network"
fi

if [ $# -eq 1 ]; then
	read -p "User domain"
	read -p "Username: " username
	read_pass "Password " password
fi

page=`get_page -F action=login \
	--form-string community="$community" \
	--form-string username="$username"   \
	--form-string password="$password"   \
	$post_url`

echo $page
