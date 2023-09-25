#!/bin/bash

## 默认开启wifi
sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

# 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

# DDNS
sed -i "s/动态 DNS(DDNS)/动态 DNS/g" feeds/luci/applications/luci-app-ddns/po/zh_Hans/ddns.po
sed -i "s/动态 DNS(DDNS)/动态 DNS/g" package/feeds/luci/applications/luci-app-ddns/po/zh_Hans/ddns.po
cat feeds/luci/applications/luci-app-ddns/po/zh_Hans/ddns.po | tail -n +207 | head -n 2
sed -i '5,8d' feeds/packages/net/ddns-scripts/files/etc/init.d/ddns
sed -i '5,8d' package/feeds/packages/net/ddns-scripts/files/etc/init.d/ddns
cat feeds/packages/net/ddns-scripts/files/etc/init.d/ddns

## small_flash.patch
sed -i "s/kmod-mt7603 kmod-mt76x2 -uboot-envtools/kmod-mt7603 kmod-mt76x2 -uboot-envtools wpad-mini -wpad-basic-mbedtls -coremark -htop -bash -openssh-sftp-server/g" target/linux/ramips/image/mt7621.mk
cat target/linux/ramips/image/mt7621.mk

# Boost 通用即插即用
# rm -rf feeds/packages/net/miniupnpd
# svn export https://github.com/immortalwrt/packages/trunk/net/miniupnpd feeds/packages/net/miniupnpd

#############################################################################################################

# rm -rf package/new
mkdir -p package/new

## set default-setting
cp -rf $GITHUB_WORKSPACE/patches/default-settings package/new/default-settings

## 下载主题luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config

## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile

## 修改argon背景图片
rm -rf package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/bg1.jpg package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

## Add luci-app-alist
# git clone https://github.com/sbwml/luci-app-alist package/new/luci-app-alist

## Add luci-app-ddns-go
# svn export https://github.com/sirpdboy/luci-app-ddns-go/trunk/luci-app-ddns-go package/new/luci-app-ddns-go
# svn export https://github.com/sirpdboy/luci-app-ddns-go/trunk/ddns-go package/new/ddns-go
svn export https://github.com/kenzok8/small-package/trunk/luci-app-ddns-go package/new/luci-app-ddns-go
svn export https://github.com/kenzok8/small-package/trunk/ddns-go package/new/ddns-go

## Add luci-app-wechatpush
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## Add luci-app-accesscontrol
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-accesscontrol package/new/luci-app-accesscontrol

## Add luci-app-autoreboot
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-autoreboot package/new/luci-app-autoreboot

## Add luci-app-poweroff
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-poweroff package/new/luci-app-poweroff

## Add luci-app-wolplus
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wolplus package/new/luci-app-wolplus

## Add luci-app-onliner
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-onliner package/new/luci-app-onliner

## Add luci-app-fileassistant luci-app-filetransfer
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-fileassistant package/new/luci-app-fileassistant
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-filetransfer package/new/luci-app-filetransfer
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-lib-fs package/new/luci-lib-fs

## Add luci-app-ramfree
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ramfree package/new/luci-app-ramfree

## Add luci-app-guest-wifi
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-guest-wifi package/new/luci-app-guest-wifi

## Add luci-app-easymesh
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-easymesh package/new/luci-app-easymesh

## Add luci-app-socat
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-socat package/new/luci-app-socat
svn export https://github.com/chenmozhijin/luci-app-socat/trunk/luci-app-socat package/new/luci-app-socat

## Add luci-app-adbyby-plus
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adbyby-plus package/new/luci-app-adbyby-plus
# svn export https://github.com/kiddin9/openwrt-packages/trunk/adbyby package/new/adbyby

## Add luci-app-wireguard
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wireguard package/new/luci-app-wireguard

## luci-app-turboacc
bash $GITHUB_WORKSPACE/scripts/turboacc_5_15.sh

## ssr passwall vssr bypass依赖
# git clone https://github.com/kenzok8/small package/new/small

## openclash
# bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64

## luci-app-ssr-plus
# bash $GITHUB_WORKSPACE/scripts/ssrp.sh

## zsh
# bash $GITHUB_WORKSPACE/scripts/zsh.sh
