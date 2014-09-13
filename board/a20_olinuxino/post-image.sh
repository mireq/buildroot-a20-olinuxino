#!/bin/sh
#--------

BOARD_DIR="$(dirname $0)"
BOOT=$TARGET_DIR/boot/

echo ===
echo
echo To create sd image type command:
echo
echo sudo $BOARD_DIR/make-sdimg.sh $BINARIES_DIR/rootfs.tar 60 $BINARIES_DIR
echo 
echo ===


