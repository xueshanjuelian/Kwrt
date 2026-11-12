#!/bin/bash

shopt -s extglob

SHELL_FOLDER=$(dirname $(readlink -f "$0"))


sed -i "s/DEVICE_MODEL := HC5962$/DEVICE_MODEL := HC5962 \/ B70/" target/linux/ramips/image/mt7621.mk


sed -i '/# start dockerd/,/# end dockerd/d' .config

sed -i "s/--max-leb-cnt=96/--max-leb-cnt=128/g" target/linux/ramips/image/mt7621.mk

# --- xray-core 26.x 的 go.mod 要求 go >= 1.27，而 25.12 的 golang 默认还是 1.26 ---
# 只把 xray-core 的构建依赖切到 golang1.27/host（feed 里已有该包），不动全树的 Go 版本
for f in feeds/kiddin9/xray-core/Makefile package/feeds/kiddin9/xray-core/Makefile; do
  if [ -f "$f" ] && grep -q '^PKG_BUILD_DEPENDS:=golang/host' "$f"; then
    sed -i 's|^PKG_BUILD_DEPENDS:=golang/host|PKG_BUILD_DEPENDS:=golang1.27/host|' "$f"
    echo "[diy] xray-core 改用 golang1.27/host -> $f"
  fi
done

# --- GCC 14 把 -Wincompatible-pointer-types 升级为 error，net-snmp 5.9.1 的
#     ieee802dot11.c 会因此编译失败；只对该包把这条错误降回警告 ---
for f in feeds/kiddin9/net-snmp-ssl/Makefile package/feeds/kiddin9/net-snmp-ssl/Makefile \
         feeds/packages/net/net-snmp/Makefile package/feeds/packages/net-snmp/Makefile; do
  if [ -f "$f" ] && ! grep -q 'Wno-error=incompatible-pointer-types' "$f"; then
    sed -i 's|^TARGET_CFLAGS += \$(FPIC)$|TARGET_CFLAGS += $(FPIC) -Wno-error=incompatible-pointer-types|' "$f"
    echo "[diy] net-snmp: 关闭 incompatible-pointer-types 报错 -> $f"
  fi
done
