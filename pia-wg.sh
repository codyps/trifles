
pia_renew() {
	WG_PRIVKEY="$1"

	PIA_HOME=/etc/pia
	: ${XDG_CONFIG_HOME:=$HOME/.config}
	if [ -f "$PIA_HOME/account" ];then
		. "$PIA_HOME/account"
	elif [ -f "$XDG_CONFIG_HOME/pia/account" ];then
		. "$XDG_CONFIG_HOME/pia/account"
	else
		>&2 echo "No PIA account file found"
		return 1
	fi

	PIA_TOKEN="$(curl -s -u "$PIA_USERNAME:$PIA_PASSWORD" \
		"https://privateinternetaccess.com/gtoken/generateToken" | jq -r '.token')"

	pia_servers="$(curl --max-time 15 'https://serverlist.piaservers.net/vpninfo/servers/v6' | head -1)"

	# remote ips
	country_json="$(printf "%s" "$pia_servers" | jq '.regions[] | select (.country == "NO")')"
	servers_json="$(printf "%s" "$country_json" | jq '.servers.wg')"
	server_json="$(printf "%s" "$servers_json" | jq '.[0]')"

	WG_PUBKEY="$(printf "%s" "$WG_PRIVKEY" | wg pubkey)"

	WG_SERVER_IP=$(printf "%s" "$server_json" | jq -r .ip)
	WG_HOSTNAME=$(printf "%s" "$server_json" | jq -r .cn)

	wireguard_json="$(curl -vv -G \
	  --connect-to "$WG_HOSTNAME::$WG_SERVER_IP:" \
	  --cacert "$PIA_HOME/ca.rsa.4096.crt" \
	  --data-urlencode "pt=${PIA_TOKEN}" \
	  --data-urlencode "pubkey=$WG_PUBKEY" \
	  "https://${WG_HOSTNAME}:1337/addKey" )"

	if [ "$(echo "$wireguard_json" | jq -r '.status')" != "OK" ];then
		>&2 echo "addKey failed: $wireguard_json"
		return 1
	fi

	WG_ADDR="$(echo "$wireguard_json" | jq -r .peer_ip)"
	WG_SERVER_PUBKEY="$(echo "$wireguard_json" | jq -r .server_key)"
	WG_SERVER_PORT="$(echo "$wireguard_json" | jq -r .server_port)"
	WG_SERVER_ENDPOINT="$WG_SERVER_IP:$WG_SERVER_PORT"

	WG_SERVER_DNS="$(echo "$wireguard_json" | jq -r '.dns_servers[0]')"
}
