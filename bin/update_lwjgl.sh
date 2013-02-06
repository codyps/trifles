#!/usr/bin/env bash

echo "Determining OS..."

if [[ "$(uname -s)" == "Linux" ]]; then
    mcdir="$HOME/.minecraft/"
    downloader="wget --no-check-certificate -q -O"
    os="linux"
    natives="libjinput-linux libjinput-linux64 liblwjgl liblwjgl64 libopenal libopenal64"
elif [[ "$(uname -s)" == "Darwin" ]]; then
    mcdir="$HOME/Library/Application\ Support/minecraft/"
    downloader="curl -o"
    os="macosx"
    natives="libjinput-osx.jnilib liblwjgl.jnilib openal.dylib"
else
    echo "OS not supported.  Exploding..."
    exit 1
fi

echo "Determining installed LWJGL version..."

installed="$(unzip -p $mcdir/bin/lwjgl.jar | strings | grep  '^[0-9]*\.[0-9]*\.[0-9]*')"

echo "LWJGL $installed installed"

echo "Determining latest online version..."

latest=$(${downloader%%-o} - http://lwjgl.org/download.php |\
        grep -oE  "https?:\/\/sourceforge.net\/projects\/java-game-lib\/files\/Official%20Releases\/LWJGL%20[0-9|\.]*")

echo "Found version ${latest##*%20}"

if [[ "${latest##*%20}" == "$installed" ]]; then
    echo "LWJGL already at current version."
    if [[ "$1" == "-force" ]]; then
        echo "Updating anyways..."
    else
        exit 0
    fi
fi

echo "Determining download URL..."

dlurl=$(${downloader%%-o} - "$latest" |\
        grep -oE -m1 "https?://sourceforge.net/projects/java-game-lib/files/Official%20Releases/LWJGL%20[0-9|\.]*/lwjgl-[0-9|\.]*.zip")

echo "Checking if ~./cache/ exists..."

if [[ ! -d "$HOME/.cache/" ]]; then
    echo "~/.cache/ did not exist.  Creating..."
    mkdir "$HOME/.cache/"
fi

echo "Downloading latest LWJGL..."

$downloader "$HOME/.cache/lwjgl.zip" "$dlurl"

echo "Extracting zip file..."

unzip -qqo "$HOME/.cache/lwjgl.zip" -d "$HOME/.cache/"

lwjgldir=$(find "$HOME/.cache" -maxdepth 1 -type d -name "*lwjgl*" -print)

echo "Copying files..."

for i in "jinput" "lwjgl" "lwjgl_util"; do
    echo "Copying $i..."
    cp "$lwjgldir/jar/$i.jar" "$mcdir/bin/"
done
for i in $natives; do
    echo "Copying $i..."
    cp "$lwjgldir/native/$os/$i.so" "$mcdir/bin/natives/"
done

echo "Deleting cache..."

rm -rf "$lwjgldir"
