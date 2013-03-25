#! /bin/sh

warn () {
	printf -- "%s\n" "$*" >> /dev/stderr
}

usage () {
	warn "usage: $0 vars flag pkg_name"
	exit 1
}

emit_to () {
	pkg="$1"
	str="$2"

	path="/etc/portage/env/$pkg"
	mkdir -p $(dirname "$path")
	echo $str >> "$path"
}

if [ $# -ne 3 ]; then
	warn "err: usage"
	usage
fi

vars="$1"
flag="$2"
pkg_name="$3"

pos_pkgs=`eix --only-names "$pkg_name"`
actual_pkg=""

: $((i=0))
for ppkg in $pos_pkgs; do
	: $((i=i+1))
	actual_pkg="$ppkg"
done

if [ $i -gt 1 ]; then
	warn "No exact package $pkg_name was found"
	warn "Possibilities: "
	for ppkg in $pos_pkgs; do
		warn "  $ppkg"
	done
	exit 2
fi

if [ $i -lt 1 ]; then
	warn "Could not find any package matching "$pkg_name""
	exit 3
fi

filter_pre_var='%s=${%s/'"$flag"'/}'

for var in $vars; do
	emit_to $actual_pkg $(printf "$filter_pre_var" "$var" "$var")
done

