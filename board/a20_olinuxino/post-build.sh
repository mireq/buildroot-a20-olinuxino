#!/bin/sh
#--------

BOARD_DIR="$(dirname $0)"
BOOT=$TARGET_DIR/boot/

cp -v $BOARD_DIR/script.bin $BOOT
cp -v $BOARD_DIR/uEnv.txt $BOOT
$TARGET_DIR/output/host/usr/bin/mkimage -C none -A arm -T script -d $BOARD_DIR/boot.cmd $BOARD_DIR/boot.scr
cp -v $BOARD_DIR/boot.scr $BOOT

if [ -e $BINARIES_DIR/u-boot.bin ];
then

    cp $BINARIES_DIR/u-boot.bin $BOOT

fi

if [ -e $BINARIES_DIR/u-boot.img ];
then

    cp $BINARIES_DIR/u-boot.img $BOOT

fi

if [ -e $BINARIES_DIR/sunxi-spl.bin ];
then

    cp $BINARIES_DIR/sunxi-spl.bin $BOOT

fi

if [ -e $BOARD_DIR/wpa_supplicant.conf ];
then
    cp $BOARD_DIR/wpa_supplicant.conf $TARGET_DIR/etc/wpa_supplicant.conf
fi
