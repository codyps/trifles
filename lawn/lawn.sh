#! /bin/sh

logout_url='https://login.cs.rutgers.edu/wireless/servlet/logout.jsp'
form_url='https://login.cs.rutgers.edu/wireless/jsp/login.jsp'
post_url='https://login.cs.rutgers.edu/wireless/servlet/Submit'

page=`curl -b lawn.cookies -c lawn.cookies -D lawn.header $post_url`

not_on_lawn_str='You do not appear to be on a trusted LAWN wireless network'

if printf "%s" "$page" | grep -q "$not_on_lawn_str"; then
	echo "Not on a lawn network" >> /dev/stderr
	exit 1
fi

echo $page
