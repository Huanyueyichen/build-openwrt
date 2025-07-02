#!/bin/bash

## rockchip机型,默认内核5.15，修改内核为6.1
# sed -i 's/PATCHVER:=5.15/PATCHVER:=6.1/g' target/linux/rockchip/Makefile

## 移除 SNAPSHOT 标签
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

## 启用 luci-app-irqbalance
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

# rm -rf package/new
mkdir -p package/new

## 下载主题luci-theme-argon
# git clone https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
# git clone https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
# sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile
## 修改argon背景图片
rm -rf feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

## golang编译环境
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

## Add luci-app-ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/packages/net/ddns-go
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo
mv -n package/new/ddnsgo/*ddns-go package/new/
rm -rf package/new/ddnsgo

## adguardhome
git clone -b patch-1 https://github.com/kiddin9/openwrt-adguardhome package/new/openwrt-adguardhome
mv package/new/openwrt-adguardhome/*adguardhome package/new/
rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/AdGuardHome_template.yaml package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/links.txt package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
# sed -i 's/+adguardhome/+PACKAGE_$(PKG_NAME)_INCLUDE_binary:adguardhome/g' package/new/luci-app-adguardhome/Makefile
rm -rf package/new/openwrt-adguardhome

## Add luci-app-mosdns
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/new/v2ray-geodata
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/new/sbwml-mosdns
mv -n package/new/sbwml-mosdns/*mosdns package/new/
mv -n package/new/sbwml-mosdns/v2dat package/new/
rm -rf package/new/sbwml-mosdns

## Add luci-app-wolplus
# git clone https://github.com/animegasan/luci-app-wolplus package/new/luci-app-wolplus

## Add luci-app-socat
rm -rf feeds/packages/net/socat
git clone https://github.com/immortalwrt/packages package/new/immortalwrt-packages
mv package/new/immortalwrt-packages/net/socat package/new/socat
rm -rf package/new/immortalwrt-packages
rm -rf feeds/luci/applications/luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/chenmozhijin-socat
mv -n package/new/chenmozhijin-socat/luci-app-socat package/new/
rm -rf package/new/chenmozhijin-socat

####################################
## clone kiddin9/openwrt-packages仓库
git clone https://github.com/kiddin9/kwrt-packages package/new/openwrt-packages

## Add luci-app-autoreboot
mv package/new/openwrt-packages/luci-app-autoreboot package/new/luci-app-autoreboot

## Add luci-app-onliner
mv package/new/openwrt-packages/luci-app-onliner package/new/luci-app-onliner

## Add luci-app-qbittorrent
mv package/new/openwrt-packages/qBittorrent-Enhanced-Edition package/new/qBittorrent-Enhanced-Edition
mv package/new/openwrt-packages/luci-app-qbittorrent package/new/luci-app-qbittorrent
## qbittorrent依赖
mv package/new/openwrt-packages/qt6tools package/new/qt6tools
mv package/new/openwrt-packages/qt6base package/new/qt6base
mv package/new/openwrt-packages/libdouble-conversion package/new/libdouble-conversion
rm -rf feeds/packages/libs/libtorrent-rasterbar
mv package/new/openwrt-packages/libtorrent-rasterbar package/new/libtorrent-rasterbar

## Add luci-app-partexp
# mv package/new/openwrt-packages/luci-app-partexp package/new/luci-app-partexp

## Add luci-app-diskman
# mv package/new/openwrt-packages/luci-app-diskman package/new/luci-app-diskman

## Add luci-app-fileassistant
rm -rf feeds/luci/applications/luci-app-fileassistant
mv package/new/openwrt-packages/luci-app-fileassistant package/new/luci-app-fileassistant

## Add luci-app-wolplus
mv package/new/openwrt-packages/luci-app-wolplus package/new/luci-app-wolplus

rm -rf package/new/openwrt-packages
#################################

## openclash
rm -rf feeds/luci/applications/luci-app-openclash
bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64
# bash $GITHUB_WORKSPACE/scripts/openclash-dev.sh arm64


## zsh
bash $GITHUB_WORKSPACE/scripts/zsh.sh

ls -1 package/new/
