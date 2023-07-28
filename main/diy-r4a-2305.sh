#!/bin/bash

## 默认开启wifi
sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

## 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate


rm -rf package/new
mkdir -p package/new

## 下载主题luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile
## 修改argon背景图片
# rm -rf package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
# cp -f $GITHUB_WORKSPACE/bg1.jpg package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg


## Add luci-app-wechatpush
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## Add autoreboot
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-autoreboot package/new/luci-app-autoreboot

## Add luci-app-accesscontrol
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-accesscontrol package/new/luci-app-accesscontrol

## Add luci-app-onliner
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-onliner package/new/luci-app-onliner

## Add luci-app-guest-wifi
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-guest-wifi package/new/luci-app-guest-wifi

## Add luci-app-socat
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-socat package/new/luci-app-socat
svn export https://github.com/chenmozhijin/luci-app-socat/trunk/luci-app-socat package/new/luci-app-socat

## Add autocore
svn export https://github.com/kiddin9/openwrt-packages/trunk/autocore package/new/autocore

## Add luci-app-wireguard
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wireguard package/new/luci-app-wireguard

## turboacc_5_15
bash $GITHUB_WORKSPACE/scripts/turboacc_5_15.sh
