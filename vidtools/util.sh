strip_leading_zeros() {
	local t="$1"
	local n

	while true; do
		n="${t#0}"
		if [ "$n" = "$t" ]; then
			echo "$n"
			break
		fi
		t="$n"
	done
}

# $1 = [H[H]:][[M]M:]SS[.N[N[N]]]
time_to_sec() {
	local t="$1"
	# split of subsecs
	case "$t" in
	*.*)
		local subsecs="${t##*.}"
		local t="${t%.*}"
		;;
	*)   local subsecs=0 ;;
	esac

	local secs=0

	# parse colons in reverse order
	#      secs/min min/hr hr/day
	local mults=(60 60 24)
	local mult=1
	local c=1
	local go=true
	while true; do
		case "$t" in
		*:*)	# have colon sep
			local n="${t##*:}"
			local t="${t%:*}"
			# strip leading zeros
			local t="$(strip_leading_zeros "$t")"
			: $((secs = secs + n * mult))
			;;
		*)	# no colon sep
			local t="$(strip_leading_zeros "$t")"
			: $((secs = secs + t * mult))
			break
			;;
		esac
		: $((c = c + 1))
		if [ $c -gt 3 ]; then
			>&2 echo "parse fail: c=$c, n=$n, mult=$mult"
			return 1
		fi
		: $((mult = mult * 60))
	done

	echo "$secs"
}
