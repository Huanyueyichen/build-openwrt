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




## x86机型,默认内核5.15，修改内核为6.1
sed -i 's/PATCHVER:=5.15/PATCHVER:=6.1/g' target/linux/x86/Makefile


## arm机型,默认内核5.15，修改内核为6.1
sed -i 's/PATCHVER:=5.15/PATCHVER:=6.1/g' target/linux/rockchip/Makefile

## r2c修复wan口
#rm -rf target/linux/rockchip/patches-6.1/204-rockchip-rk3328-Add-support-for-FriendlyARM-NanoPi-R.patch
#cp -f $GITHUB_WORKSPACE/patches/204-rockchip-rk3328-Add-support-for-FriendlyARM-NanoPi-R.patch target/linux/rockchip/patches-6.1/204-rockchip-rk3328-Add-support-for-FriendlyARM-NanoPi-R.patch
