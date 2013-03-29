#!/bin/sh
#--------

BOARD_DIR="$(dirname $0)"
BOOT=$TARGET_DIR/boot/

cp -v $BOARD_DIR/script.bin $BOOT

if [ -e $BINARIES_DIR/u-boot.bin ];
then

    cp $BINARIES_DIR/u-boot.bin $BOOT

fi

if [ -e $BINARIES_DIR/sunxi-spl.bin ];
then

    cp $BINARIES_DIR/sunxi-spl.bin $BOOT

fi

if [ -e $BOARD_DIR/wpa_supplicant.conf ];
then
    cp $BOARD_DIR/wpa_supplicant.conf $TARGET_DIR/etc/wpa_supplicant.conf
fi
