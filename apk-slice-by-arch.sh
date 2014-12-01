#!/bin/bash

which zipalign &>/dev/null || echo "zipalign must be into your PATH. It's probably within the adt build tools"
which aminc &>/dev/null || echo "you need to download and compile aminc (https://github.com/gregko/aminc/blob/master/AndyManMod/aminc.cpp) and put it in your PATH"
which jarsigner &>/dev/null || echo "jarsigner must be into your PATH. It's probably within the java standard tools"

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] ; then
	echo "Slices an APK into several smaller ones based on arch dependant libraries found inside"
	echo "Usage: $0 <originalfile.apk> <keystore> <keyname> <keypass>"
	echo "Outputs several files named originalfile-<arch>.apk"
	exit 1
fi

ORIGINAL_APK=$1
KEYSTORE="$2"
KEYPASS=$4
KEYNAME=$3
TMPDIR=`tempfile`
APKNAME="$(echo $ORIGINAL_APK | sed 's/\.apk$//')"

shopt -s extglob # Needed

i=1
for ARCH in armeabi armeabi-v7a mips x86; do

	echo "Building $ARCH package..."
	
	# Extracting everything into place
	rm -rf $TMPDIR
	mkdir $TMPDIR
	unzip -qq $ORIGINAL_APK -d $TMPDIR
	rm -rf $TMPDIR/META-INF
	cd $TMPDIR/lib && rm -rf !($ARCH)
	cd - &>/dev/null

	# Modifying the version code
	aminc $TMPDIR/AndroidManifest.xml $((1000*$i))

	# Packaging again
	cd $TMPDIR
	zip --quiet -r $APKNAME-$ARCH.apk *
	cd - &> /dev/null
	mv $TMPDIR/$APKNAME-$ARCH.apk .
	
	# Signing
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore "$KEYSTORE" -storepass "$KEYPASS" $APKNAME-$ARCH.apk "$KEYNAME"
	zipalign 4 $APKNAME-$ARCH.apk $APKNAME-$ARCH-aligned.apk
	mv $APKNAME-$ARCH-aligned.apk $APKNAME-$ARCH.apk

	# Cleanup
	rm -rf $TMPDIR

	i=$(($i+1))
done

