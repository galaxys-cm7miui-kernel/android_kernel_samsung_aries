#!/bin/sh

echo "copying config for CAPPY"
cp arch/arm/configs/aries_captivatemtd_defconfig .config

echo "building with stock toolchain"
make -j8

echo "copying modem drivers"
cd drivers/misc/samsung_modemctl
cp built-in.o built-in.2009q3_samsung_modemctl
cd modemctl
cp built-in.o built-in.2009q3_samsung_modemctl

echo "cleaning up"
cd ../../../..
make clean
cd drivers/misc/samsung_modemctl
cp built-in.2009q3_samsung_modemctl built-in.o
cd modemctl
cp built-in.2009q3_samsung_modemctl built-in.o
cd ../../../..

echo "switching makefiles"
cp Makefile Makefile.stock
cp Makefile.toolchain Makefile
cd drivers/misc/samsung_modemctl
cp Makefile Makefile.stock
cp Makefile.toolchain Makefile
cd ../../../arch/arm
cp Makefile Makefile.stock
cp Makefile.toolchain Makefile
cd vfp
cp Makefile Makefile.stock
cp Makefile.toolchain Makefile
cd ../../..

echo "rebuilding with new toolchain"
cp arch/arm/configs/aries_captivatemtd_defconfig .config
make -j8

echo "resetting makefiles"
cp Makefile.stock Makefile
cd drivers/misc/samsung_modemctl
cp Makefile.stock Makefile
cd ../../../arch/arm
cp Makefile.stock Makefile
cd vfp
cp Makefile.stock Makefile
cd ../../..

echo "creating boot.img"
../../../device/samsung/aries-common/mkshbootimg.py release/boot.img arch/arm/boot/zImage ../../../out/target/product/captivatemtd/ramdisk.img ../../../out/target/product/captivatemtd/ramdisk-recovery.img

echo "copying modules"
cp drivers/net/wireless/bcm4329/bcm4329.ko release/system/lib/modules/bcm4329.ko
cp drivers/net/tun.ko release/system/lib/modules/tun.ko
cp drivers/staging/android/logger.ko release/system/lib/modules/logger.ko
cp fs/cifs/cifs.ko release/system/lib/modules/cifs.ko

echo "zipping"
cd release
zip -q -r kernel.zip system boot.img META-INF bml_over_mtd bml_over_mtd.sh

