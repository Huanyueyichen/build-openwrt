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


## arm机型,默认内核5.15，修改内核为6.1
sed -i 's/PATCHVER:=5.15/PATCHVER:=6.1/g' target/linux/rockchip/Makefile


## ramips机型,默认内核5.10，修改内核为5.10
# sed -i 's/PATCHVER:=5.4/PATCHVER:=5.10/g' target/linux/ramips/Makefile

##  修改R4A千兆版闪存布局为Breed直刷版
bash $GITHUB_WORKSPACE/scripts/r4a_breed.sh
