#!/bin/bash


## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate


## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile

#############################################################################################################

## 下载主题luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config

## alist
# git clone https://github.com/sbwml/luci-app-alist package/new/luci-app-alist

## Add wechatpush
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## autoreboot
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-autoreboot package/new/luci-app-autoreboot

## Add luci-app-poweroff
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-poweroff package/new/luci-app-poweroff

## Add luci-app-wolplus
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wolplus package/new/luci-app-wolplus

## Add luci-app-onliner (need luci-app-nlbwmon)
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-onliner package/new/luci-app-onliner

## Add luci-app-irqbalance by QiuSimons https://github.com/QiuSimons/OpenWrt-Add
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-irqbalance package/new/luci-app-irqbalance

## AdguardHome
svn export https://github.com/kiddin9/openwrt-packages/trunk/adguardhome package/new/adguardhome
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adguardhome package/new/luci-app-adguardhome

## luci-app-lucky
svn export https://github.com/kiddin9/openwrt-packages/trunk/lucky package/new/lucky
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-lucky package/new/luci-app-lucky

## qbittorrent
svn export https://github.com/kiddin9/openwrt-packages/trunk/qBittorrent-Enhanced-Edition package/new/qBittorrent-Enhanced-Edition
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-qbittorrent package/new/luci-app-qbittorrent

## qbittorrent依赖
svn export https://github.com/kiddin9/openwrt-packages/trunk/qt6tools package/new/qt6tools
svn export https://github.com/kiddin9/openwrt-packages/trunk/qt6base package/new/qt6base
svn export https://github.com/kiddin9/openwrt-packages/trunk/libdouble-conversion package/new/libdouble-conversion

## file
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-fileassistant package/new/luci-app-fileassistant
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-filetransfer package/new/luci-app-filetransfer

## fileassistant依赖
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-lib-fs package/new/luci-lib-fs

## cpufreq
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-cpufreq package/new/luci-app-cpufreq

## wrtbwmon
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wrtbwmon package/new/luci-app-wrtbwmon
svn export https://github.com/kiddin9/openwrt-packages/trunk/wrtbwmon package/new/wrtbwmon

## ramfree
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ramfree package/new/luci-app-ramfree

## guest-wifi
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-guest-wifi package/new/luci-app-guest-wifi

## socat
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-socat package/new/luci-app-socat

## ssr-plus
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ssr-plus package/new/luci-app-ssr-plus

## ssr-plus依赖
svn export https://github.com/kiddin9/openwrt-packages/trunk/dns2socks package/new/dns2socks
svn export https://github.com/kiddin9/openwrt-packages/trunk/dns2tcp package/new/dns2tcp
svn export https://github.com/kiddin9/openwrt-packages/trunk/lua-neturl package/new/lua-neturl
svn export https://github.com/kiddin9/openwrt-packages/trunk/tcping package/new/tcping
svn export https://github.com/kiddin9/openwrt-packages/trunk/shadowsocksr-libev package/new/shadowsocksr-libev
svn export https://github.com/kiddin9/openwrt-packages/trunk/chinadns-ng package/new/chinadns-ng
svn export https://github.com/kiddin9/openwrt-packages/trunk/hysteria package/new/hysteria
svn export https://github.com/kiddin9/openwrt-packages/trunk/ipt2socks package/new/ipt2socks
svn export https://github.com/kiddin9/openwrt-packages/trunk/naiveproxy package/new/naiveproxy
svn export https://github.com/kiddin9/openwrt-packages/trunk/redsocks2 package/new/redsocks2
svn export https://github.com/kiddin9/openwrt-packages/trunk/shadowsocks-rust package/new/shadowsocks-rust
svn export https://github.com/kiddin9/openwrt-packages/trunk/simple-obfs package/new/simple-obfs
svn export https://github.com/kiddin9/openwrt-packages/trunk/v2ray-plugin package/new/v2ray-plugin
svn export https://github.com/kiddin9/openwrt-packages/trunk/trojan package/new/trojan
svn export https://github.com/kiddin9/openwrt-packages/trunk/gn package/new/gn

## openclash
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-openclash package/new/luci-app-openclash

## ddns
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ddns package/new/luci-app-ddns
svn export https://github.com/kiddin9/openwrt-packages/trunk/ddns-scripts package/new/ddns-scripts

## adbyby-plus
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adbyby-plus package/new/luci-app-adbyby-plus
svn export https://github.com/kiddin9/openwrt-packages/trunk/adbyby package/new/adbyby

## ddns-go
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ddns-go package/new/luci-app-ddns-go
svn export https://github.com/kiddin9/openwrt-packages/trunk/ddnsgo package/new/ddnsgo

## automount
svn export https://github.com/kiddin9/openwrt-packages/trunk/automount package/new/automount
svn export https://github.com/kiddin9/openwrt-packages/trunk/ntfs3-mount package/new/ntfs3-mount
# svn export https://github.com/kiddin9/openwrt-packages/trunk/lua-neturl package/new/lua-neturl
