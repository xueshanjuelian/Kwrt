#!/bin/bash

shopt -s extglob

#curl -sL https://patch-diff.githubusercontent.com/raw/openwrt/openwrt/pull/24883.patch | git apply -v

rm -rf target/linux/airoha/!(patches-6.12) package/boot

git_clone_path main https://github.com/openwrt/openwrt target/linux/airoha package/boot

wget -N https://github.com/openwrt/openwrt/raw/refs/heads/openwrt-25.12/target/linux/airoha/an7581/config-6.12 -P target/linux/airoha/an7581/

sed -i "s/KERNEL_PATCHVER:=6.18/KERNEL_PATCHVER:=6.12/" target/linux/airoha/Makefile