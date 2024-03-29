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
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo && mv -n package/new/ddnsgo/*ddns-go package/new/; rm -rf package/new/ddnsgo

## Add luci-app-socat
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-socat package/new/luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/socat && mv -n package/new/socat/luci-app-socat package/new/; rm -rf package/new/socat

## Add luci-app-wechatpush
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## 修改miniupnpd
# rm -rf feeds/packages/net/miniupnpd
# rm -rf feeds/luci/applications/luci-app-upnp
# git clone -b openwrt-21.02 https://github.com/openwrt/luci package/new/luci-21.02
# mv package/new/luci-21.02/applications/luci-app-upnp package/new/luci-app-upnp
# rm -rf package/new/luci-21.02
# git clone -b openwrt-21.02 https://github.com/openwrt/packages package/new/packages-21.02
# mv package/new/packages-21.02/net/miniupnpd package/new/miniupnpd
# rm -rf package/new/packages-21.02

## clone kiddin9/openwrt-packages仓库
git clone https://github.com/kiddin9/openwrt-packages package/new/openwrt-packages

## 添加包
mv package/new/openwrt-packages/luci-app-accesscontrol package/new/luci-app-accesscontrol
mv package/new/openwrt-packages/luci-app-autoreboot package/new/luci-app-autoreboot
mv package/new/openwrt-packages/luci-app-wolplus package/new/luci-app-wolplus
mv package/new/openwrt-packages/luci-app-onliner package/new/luci-app-onliner
mv package/new/openwrt-packages/luci-app-guest-wifi package/new/luci-app-guest-wifi
# mv package/new/openwrt-packages/luci-app-wireguard package/new/luci-app-wireguard

rm -rf package/new/openwrt-packages

## luci-app-turboacc
# bash $GITHUB_WORKSPACE/scripts/turboacc_5_15.sh
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

## ssr passwall vssr bypass依赖
# git clone https://github.com/kenzok8/small package/new/small

## openclash
# bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64

## luci-app-ssr-plus
# bash $GITHUB_WORKSPACE/scripts/ssrp.sh

## zsh
# bash $GITHUB_WORKSPACE/scripts/zsh.sh
