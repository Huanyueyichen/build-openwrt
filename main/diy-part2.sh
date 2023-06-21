#!/bin/bash


## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate


## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile

## 下载主题luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

## alist
# git clone https://github.com/sbwml/luci-app-alist package/luci-app-alist

## Add wechatpush
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/luci-app-wechatpush

## autoreboot
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-autoreboot package/luci-app-autoreboot

## Add luci-app-poweroff
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-poweroff package/luci-app-poweroff

## Add luci-app-wolplus
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wolplus package/luci-app-wolplus

## Add luci-app-onliner (need luci-app-nlbwmon)
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-onliner package/luci-app-onliner

## Add luci-app-irqbalance by QiuSimons https://github.com/QiuSimons/OpenWrt-Add
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-irqbalance package/luci-app-irqbalance

## AdguardHome
svn export https://github.com/kiddin9/openwrt-packages/trunk/adguardhome package/adguardhome
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adguardhome package/luci-app-adguardhome

## luci-app-lucky
svn export https://github.com/kiddin9/openwrt-packages/trunk/lucky package/lucky
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-lucky package/luci-app-lucky

## qbittorrent
# svn export https://github.com/kiddin9/openwrt-packages/trunk/qBittorrent-Enhanced-Edition package/qBittorrent-Enhanced-Edition
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-qbittorrent package/luci-app-qbittorrent

## file
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-fileassistant package/luci-app-fileassistant
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-filetransfer package/luci-app-filetransfer

## cpufreq
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-cpufreq package/luci-app-cpufreq

## wrtbwmon
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wrtbwmon package/luci-app-wrtbwmon
svn export https://github.com/kiddin9/openwrt-packages/trunk/wrtbwmon package/wrtbwmon

## ramfree
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ramfree package/luci-app-ramfree

## luci-app-fileassistant依赖
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-lib-fs package/luci-lib-fs

## ssr passwall vssr bypass依赖
git clone https://github.com/kenzok8/small package/new/small

# svn export https://github.com/kiddin9/openwrt-packages/trunk/qt6tools package/qt6tools
# svn export https://github.com/kiddin9/openwrt-packages/trunk/qt6base package/qt6base
