#!/bin/bash


## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

## requires golang 1.19.x or latest version 
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 20.x feeds/packages/lang/golang

#############################################################################################################

# rm -rf package/new
mkdir -p package/new

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

## Add luci-app-wechatpush
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## Add autoreboot
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-autoreboot package/new/luci-app-autoreboot

## Add luci-app-poweroff
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-poweroff package/new/luci-app-poweroff

## Add luci-app-wolplus
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wolplus package/new/luci-app-wolplus

## Add luci-app-onliner
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-onliner package/new/luci-app-onliner

## Add luci-app-irqbalance
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-irqbalance package/new/luci-app-irqbalance

## Add luci-app-AdguardHome
# svn export https://github.com/kiddin9/openwrt-packages/trunk/adguardhome package/new/adguardhome
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adguardhome package/new/luci-app-adguardhome

## Add luci-app-lucky
# svn export https://github.com/kiddin9/openwrt-packages/trunk/lucky package/new/lucky
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-lucky package/new/luci-app-lucky

## Add luci-app-qbittorrent
# svn export https://github.com/kiddin9/openwrt-packages/trunk/qBittorrent-Enhanced-Edition package/new/qBittorrent-Enhanced-Edition
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-qbittorrent package/new/luci-app-qbittorrent

## qbittorrent依赖
# svn export https://github.com/kiddin9/openwrt-packages/trunk/qt6tools package/new/qt6tools
# svn export https://github.com/kiddin9/openwrt-packages/trunk/qt6base package/new/qt6base
# svn export https://github.com/kiddin9/openwrt-packages/trunk/libdouble-conversion package/new/libdouble-conversion

## Add luci-app-fileassistant luci-app-filetransfer
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-fileassistant package/new/luci-app-fileassistant
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-filetransfer package/new/luci-app-filetransfer
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-lib-fs package/new/luci-lib-fs

## Add luci-app-cpufreq
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-cpufreq package/new/luci-app-cpufreq

## Add luci-app-wrtbwmon
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wrtbwmon package/new/luci-app-wrtbwmon
# svn export https://github.com/kiddin9/openwrt-packages/trunk/wrtbwmon package/new/wrtbwmon

## Add luci-app-ramfree
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ramfree package/new/luci-app-ramfree

## Add luci-app-guest-wifi
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-guest-wifi package/new/luci-app-guest-wifi

## Add luci-app-easymesh
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-easymesh package/new/luci-app-easymesh

## Add luci-app-socat
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-socat package/new/luci-app-socat
svn export https://github.com/chenmozhijin/luci-app-socat/trunk/luci-app-socat package/new/luci-app-socat

## Add luci-app-ddns
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ddns package/new/luci-app-ddns
svn export https://github.com/kiddin9/openwrt-packages/trunk/ddns-scripts package/new/ddns-scripts

## Add luci-app-adbyby-plus
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adbyby-plus package/new/luci-app-adbyby-plus
svn export https://github.com/kiddin9/openwrt-packages/trunk/adbyby package/new/adbyby

## Add luci-app-ddns-go
# svn export https://github.com/sirpdboy/luci-app-ddns-go/trunk/luci-app-ddns-go package/new/luci-app-ddns-go
# svn export https://github.com/sirpdboy/luci-app-ddns-go/trunk/ddns-go package/new/ddns-go

## Add automount
# svn export https://github.com/kiddin9/openwrt-packages/trunk/automount package/new/automount
# svn export https://github.com/kiddin9/openwrt-packages/trunk/ntfs3-mount package/new/ntfs3-mount
# svn export https://github.com/kiddin9/openwrt-packages/trunk/lua-neturl package/new/lua-neturl

## Add autocore
# svn export https://github.com/kiddin9/openwrt-packages/trunk/autocore package/new/autocore
# svn export https://github.com/kiddin9/openwrt-packages/trunk/mhz package/new/mhz

## Add luci-app-wireguard
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wireguard package/new/luci-app-wireguard

## Add luci-app-turboacc
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-turboacc package/new/luci-app-turboacc
# svn export https://github.com/kiddin9/openwrt-packages/trunk/dnsforwarder package/new/dnsforwarder
# svn export https://github.com/kiddin9/openwrt-packages/trunk/shortcut-fe package/new/shortcut-fe
# svn export https://github.com/kiddin9/openwrt-packages/trunk/fullconenat package/new/fullconenat
# svn export https://github.com/kiddin9/openwrt-packages/trunk/pdnsd-alt package/new/pdnsd-alt

## openclash
# bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64

## luci-app-ssr-plus
bash $GITHUB_WORKSPACE/scripts/ssrp.sh

## zsh
# bash $GITHUB_WORKSPACE/scripts/zsh.sh
