#!/bin/bash

## 默认开启wifi
# sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

# 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

## small_flash.patch
# sed -i "s/kmod-mt7603 kmod-mt76x2 -uboot-envtools/kmod-mt7603 kmod-mt76x2 -uboot-envtools wpad-mini -wpad-basic-mbedtls -coremark -htop -bash -openssh-sftp-server/g" target/linux/ramips/image/mt7621.mk
# cat target/linux/ramips/image/mt7621.mk

## 修改miniupnpd
# sed -i "s/ipv6_disable 0/ipv6_disable 1/g" feeds/packages/net/miniupnpd/files/miniupnpd.init
# cat feeds/packages/net/miniupnpd/files/miniupnpd.init

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 21.x feeds/packages/lang/golang

#############################################################################################################

# rm -rf package/new
mkdir -p package/new

## set default-setting
# cp -rf $GITHUB_WORKSPACE/patches/default-settings package/new/default-settings

## 下载主题luci-theme-argon
rm -rf feeds/luci/applications/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
git clone https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
# sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/g' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci-light/Makefile
## 修改argon背景图片
rm -rf package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/bg1.jpg package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

## Add luci-app-alist
# git clone https://github.com/sbwml/luci-app-alist package/new/luci-app-alist

## Add luci-app-ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/packages/net/ddns-go
# git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo && mv -n package/new/ddnsgo/*ddns-go package/new/; rm -rf package/new/ddnsgo
# sed -i 's/chown ddns-go/chmod 777/g' feeds/packages/net/ddns-go/files/ddns-go.init
# cat feeds/packages/net/ddns-go/files/ddns-go.init

## Add luci-app-socat
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-socat package/new/luci-app-socat
rm -rf feeds/luci/applications/luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/socat && mv -n package/new/socat/luci-app-socat package/new/; rm -rf package/new/socat

## Add luci-app-wechatpush
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## clone kiddin9/openwrt-packages仓库
git clone https://github.com/kiddin9/openwrt-packages package/new/openwrt-packages

## 添加包
mv package/new/openwrt-packages/luci-app-wolplus package/new/luci-app-wolplus
mv package/new/openwrt-packages/luci-app-onliner package/new/luci-app-onliner
mv package/new/openwrt-packages/luci-app-ddns-go package/new/luci-app-ddns-go
mv package/new/openwrt-packages/ddns-go package/new/ddns-go

rm -rf package/new/openwrt-packages

## luci-app-turboacc
# bash $GITHUB_WORKSPACE/scripts/turboacc_5_15.sh
# curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

## ssr passwall vssr bypass依赖
# git clone https://github.com/kenzok8/small package/new/small

## openclash
# bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64

## luci-app-ssr-plus
# bash $GITHUB_WORKSPACE/scripts/ssrp.sh

## zsh
# bash $GITHUB_WORKSPACE/scripts/zsh.sh
