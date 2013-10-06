#! /bin/sh
nl='
'
oifs="$IFS"
echo "FILE REMOVER"
pwd
for i in "$@"; do
        . $i
        echo "BUG: $BUG"
        IFS=$nl
        for f in $FILES; do
                echo " REMOVING: $f"
                rm -rf "$f"
        done
done
