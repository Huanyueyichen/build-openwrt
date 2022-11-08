#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#




## x86机型,默认内核5.15，修改内核为6.0
sed -i 's/PATCHVER:=5.15/PATCHVER:=6.0/g' target/linux/x86/Makefile


## 修改Alist支持
rm -rf feeds/packages/lang/golang
svn export https://github.com/sbwml/packages_lang_golang/trunk feeds/packages/lang/golang
