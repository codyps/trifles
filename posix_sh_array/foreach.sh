#! /bin/sh

getarray() {
	echo "${1}" | awk -f ./array.awk
}

foreach() {
	local func arrname
	arrname=${1}
	func=${2}

	# Pass max 4 arguments to the func.
	local addarga addargb addargc addargd
	addarga=${3}
	addargb=${4}
	addargc=${5}
	addargd=${6}

	local isarray arrtest

	# Maybe it's an bash-alike array?
	arrtest=$(declare -p ${arrname} 2>/dev/null)

	case "${arrtest}" in
		'declare -a'*)
			isarray=1
			;;
		*)
			isarray=0
	esac

	if [ ${isarray} -eq 1 ]; then
		eval set -- '"${'${arrname}'[@]}"'
	else
		eval set -- "$(eval getarray '"${'${arrname}'}"')"
	fi

	while [ ${#} -gt 0 ]; do
		"${func}" "${1}" "${addarga}" "${addargb}" "${addargc}" "${addargd}" || break
		shift
	done
}

x='/x
/a
/g
/hh'


foreach x echo Hi


