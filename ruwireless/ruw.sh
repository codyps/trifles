login_url=https://login.ruw.rutgers.edu/login.pl

curl -F custom_login_id=1 -F _FORM_SUBMIT=1 -F which_form=reg -Fdestination=""
-F source=$my_ip -F error="" -F bs_name=$username -F bs_password=$password $login_url
succ_login="Thank you for signing in."

