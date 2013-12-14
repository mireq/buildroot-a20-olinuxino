#!/bin/sh
#--------

ARG_ROOTFS_TAR="$1"
ARG_SDIMG_MB="$2"
ARG_OUTPUT_DIR="$3"

if [ ! -f "$ARG_ROOTFS_TAR" -a ! -d "$ARG_ROOTFS_TAR" ]; then
    echo "Usage: $0 <rootfs-archive> <size in mb> <output>\n"
    exit 1
fi

[ -n "$ARG_SDIMG_MB" ] && ARG_SDIMG_MB=200
[ ! -d "$ARG_OUTPUT_DIR" ] && ARG_OUTPUT_DIR=.

ROOTFS_TAR="$ARG_ROOTFS_TAR"

SDIMG_FILE="$ARG_OUTPUT_DIR"/a13_olinuxino.sdimg
SDIMG_MB=$ARG_SDIMG_MB

echo === Create empty file ===
echo "  " $SDIMG_FILE

dd if=/dev/zero of=$SDIMG_FILE bs=1M count=$SDIMG_MB > /dev/null 2>&1

echo === Create partitions ===

PARTITION_BOOT_OFFSET=2048
PARTITION_ROOT_OFFSET=34815

fdisk $SDIMG_FILE >/dev/null 2>&1 <<EOF
n
p
1
$PARTITION_BOOT_OFFSET
$PARTITION_ROOT_OFFSET
n
p
2


w
EOF

PARTITION_BOOT_OFFSET=`parted -s $SDIMG_FILE  unit B print | tail -n3 | head -n1 | awk '{print $2}'`
PARTITION_ROOT_OFFSET=`parted -s $SDIMG_FILE  unit B print | tail -n2 | head -n1 | awk '{print $2}'`

PARTITION_BOOT_OFFSET=${PARTITION_BOOT_OFFSET%B}
PARTITION_ROOT_OFFSET=${PARTITION_ROOT_OFFSET%B}

# in bytes
PARTITION_BOOT_SIZE=`parted -s $SDIMG_FILE  unit B print | tail -n3 | head -n1 | awk '{print $4}'`
PARTITION_ROOT_SIZE=`parted -s $SDIMG_FILE  unit B print | tail -n2 | head -n1 | awk '{print $4}'`

PARTITION_BOOT_SIZE=${PARTITION_BOOT_SIZE%B}
PARTITION_ROOT_SIZE=${PARTITION_ROOT_SIZE%B}

echo === Format partitions ===
LOOP=`losetup -f`

#
# format boot partition
#

echo "  " boot

losetup $LOOP $SDIMG_FILE -o $PARTITION_BOOT_OFFSET --sizelimit $PARTITION_BOOT_SIZE
mkfs.vfat $LOOP > /dev/null 2>&1
sync
losetup -d $LOOP

#
# format root partition
#

echo "  " root

losetup $LOOP $SDIMG_FILE -o $PARTITION_ROOT_OFFSET --sizelimit $PARTITION_ROOT_SIZE
mkfs.ext3 $LOOP  > /dev/null 2>&1
sync
losetup -d $LOOP


echo === Copy files ===

echo "  " bootloader

MOUNT=`mktemp -d`

tar -xf $ROOTFS_TAR -C $MOUNT --strip=2 './boot/u-boot.bin' './boot/sunxi-spl.bin'

losetup $LOOP $SDIMG_FILE
dd if=$MOUNT/sunxi-spl.bin of=$LOOP bs=1024 seek=8  > /dev/null 2>&1
dd if=$MOUNT/u-boot.bin of=$LOOP bs=1024 seek=32  > /dev/null 2>&1
sync
losetup -d $LOOP

echo "  " boot

mount -o loop,sizelimit=$PARTITION_BOOT_SIZE,offset=$PARTITION_BOOT_OFFSET $SDIMG_FILE $MOUNT
tar -xf $ROOTFS_TAR -C $MOUNT --strip=2 --wildcards './boot/*' --exclude './boot/u-boot.bin' --exclude './boot/sunxi-spl.bin'
sync
umount $MOUNT

echo "  " root

mount -o loop,sizelimit=$PARTITION_ROOT_SIZE,offset=$PARTITION_ROOT_OFFSET $SDIMG_FILE $MOUNT
tar -xf $ROOTFS_TAR -C $MOUNT --exclude 'boot'
sync
umount $MOUNT

rm -rf $MOUNT

echo === Output ===
echo
echo "  " To install image try command like this one:
echo
echo sudo dd if=$SDIMG_FILE of=/dev/mmcblk0
echo 

# echo "  " root
