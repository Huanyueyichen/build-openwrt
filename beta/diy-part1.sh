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


## ramips机型,默认内核5.4，修改内核为5.10
sed -i 's/PATCHVER:=5.4/PATCHVER:=5.10/g' target/linux/ramips/Makefile


## r2c修复wan口
#rm -rf target/linux/rockchip/patches-6.1/204-rockchip-rk3328-Add-support-for-FriendlyARM-NanoPi-R.patch
#cp -f $GITHUB_WORKSPACE/patches/204-rockchip-rk3328-Add-support-for-FriendlyARM-NanoPi-R.patch target/linux/rockchip/patches-6.1/204-rockchip-rk3328-Add-support-for-FriendlyARM-NanoPi-R.patch


## 修改R4A千兆版闪存布局为Breed直刷版
# 1.修改 mt7621_xiaomi_mir3g-v2.dts
export shanchu1=$(grep  -a -n -e '&spi0 {' target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi|cut -d ":" -f 1)
export shanchu2=$(grep  -a -n -e '&pcie {' target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi|cut -d ":" -f 1)
export shanchu2=$(expr $shanchu2 - 1)
export shanchu2=$(echo $shanchu2"d")
sed -i $shanchu1,$shanchu2 target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi
grep  -Pzo '&spi0[\s\S]*};[\s]*};[\s]*};[\s]*};' target/linux/ramips/dts/mt7621_youhua_wr1200js.dts > youhua.txt
echo "" >> youhua.txt
echo "" >> youhua.txt
export shanchu1=$(expr $shanchu1 - 1)
export shanchu1=$(echo $shanchu1"r")
sed -i "$shanchu1 youhua.txt" target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi
rm -rf youhua.txt
# 2.修改mt7621.mk
export imsize1=$(grep  -a -n -e 'define Device/xiaomi_mir3g-v2' target/linux/ramips/image/mt7621.mk|cut -d ":" -f 1)
export imsize1=$(expr $imsize1 + 2)
export imsize1=$(echo $imsize1"s")
sed -i "$imsize1/IMAGE_SIZE := .*/IMAGE_SIZE := 16064k/" target/linux/ramips/image/mt7621.mk
