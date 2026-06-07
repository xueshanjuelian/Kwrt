#!/bin/bash

shopt -s extglob

sed -i 's/Os/O2/g' include/target.mk

git_clone_path istoreos-24.10 https://github.com/istoreos/istoreos target/linux/amlogic package/boot/uboot-amlogic-prebuilt

mv -f target/linux/amlogic/patches-6.6 target/linux/amlogic/patches-6.12
rm -rf target/linux/amlogic/patches-6.12/001-dts-s905d-fix-high-load.patch
mv -f target/linux/amlogic/meson/config-6.6 target/linux/amlogic/meson/config-6.12

sed -i "s/KERNEL_PATCHVER:=6.6/KERNEL_PATCHVER:=6.12/" target/linux/amlogic/Makefile

rm -rf package/kernel/r81*



