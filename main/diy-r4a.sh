#!/bin/bash

## 默认开启wifi
sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

# 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

## small_flash.patch
sed -i "s/kmod-mt7603 kmod-mt76x2 -uboot-envtools/kmod-mt7603 kmod-mt76x2 -uboot-envtools wpad-mini -wpad-basic-mbedtls -coremark -htop -bash -openssh-sftp-server/g" target/linux/ramips/image/mt7621.mk
# cat target/linux/ramips/image/mt7621.mk

# rm -rf package/new
mkdir -p package/new

## set default-setting
cp -rf $GITHUB_WORKSPACE/patches/default-settings package/new/default-settings

## 下载主题luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
# sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile
## 修改argon背景图片
rm -rf package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/bg1.jpg package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

## Add luci-app-wechatpush
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## Add luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/socat
mv -n package/new/socat/luci-app-socat package/new/
rm -rf package/new/socat

## Add luci-app-fileassistant
git clone https://github.com/lyin888/luci-app-fileassistant package/new/luci-app-fileassistant

## clone kiddin9/openwrt-packages仓库
git clone https://github.com/kiddin9/kwrt-packages package/new/openwrt-packages

########## 添加包

## Add luci-app-accesscontrol
mv package/new/openwrt-packages/luci-app-accesscontrol package/new/luci-app-accesscontrol

## Add luci-app-autoreboot
mv package/new/openwrt-packages/luci-app-autoreboot package/new/luci-app-autoreboot

## Add luci-app-wolplus
mv package/new/openwrt-packages/luci-app-wolplus package/new/luci-app-wolplus

## Add luci-app-onliner
mv package/new/openwrt-packages/luci-app-onliner package/new/luci-app-onliner

## Add luci-app-guest-wifi
mv package/new/openwrt-packages/luci-app-guest-wifi package/new/luci-app-guest-wifi

## Add luci-app-dynv6
mv package/new/openwrt-packages/luci-app-dynv6 package/new/luci-app-dynv6

## Add luci-app-wireguard
# mv package/new/openwrt-packages/luci-app-wireguard package/new/luci-app-wireguard

## Add luci-app-poweroff
# mv package/new/openwrt-packages/luci-app-poweroff package/new/luci-app-poweroff

## Add luci-app-irqbalance
# sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
# mv package/new/openwrt-packages/luci-app-irqbalance package/new/luci-app-irqbalance

## Add luci-app-cpufreq
# mv package/new/openwrt-packages/luci-app-cpufreq package/new/luci-app-cpufreq
# sed -i 's/1512000/1200000/g' package/new/luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq

## Add luci-app-wrtbwmon
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wrtbwmon package/new/luci-app-wrtbwmon
# svn export https://github.com/kiddin9/openwrt-packages/trunk/wrtbwmon package/new/wrtbwmon

## Add luci-app-ramfree
# mv package/new/openwrt-packages/luci-app-ramfree package/new/luci-app-ramfree

## Add luci-app-adbyby-plus
# mv package/new/openwrt-packages/luci-app-adbyby-plus package/new/luci-app-adbyby-plus
# mv package/new/openwrt-packages/adbyby package/new/adbyby

## Add automount
# mv package/new/openwrt-packages/automount package/new/automount
# mv package/new/openwrt-packages/ntfs3-mount package/new/ntfs3-mount

## Add luci-app-partexp
# mv package/new/openwrt-packages/luci-app-partexp package/new/luci-app-partexp

## Add luci-app-diskman
# mv package/new/openwrt-packages/luci-app-diskman package/new/luci-app-diskman

## Add autocore
# mv package/new/openwrt-packages/autocore package/new/autocore

## Add luci-app-upnp
rm -rf feeds/luci/applications/luci-app-upnp
rm -rf feeds/packages/net/miniupnpd
mv package/new/openwrt-packages/miniupnpd package/new/miniupnpd
mv package/new/openwrt-packages/luci-app-upnp package/new/luci-app-upnp

## Add luci-app-usb-printer
# mv package/new/openwrt-packages/luci-app-usb-printer package/new/luci-app-usb-printer

rm -rf package/new/openwrt-packages

## luci-app-turboacc
# bash $GITHUB_WORKSPACE/scripts/turboacc_5_15.sh
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

ls -1 package/new/
