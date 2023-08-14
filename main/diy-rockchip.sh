#!/bin/bash

## rockchip机型,默认内核5.15，修改内核为6.1
# sed -i 's/PATCHVER:=5.15/PATCHVER:=6.1/g' target/linux/rockchip/Makefile

## 移除 SNAPSHOT 标签
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

## alist编译环境
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 20.x feeds/packages/lang/golang

## r2s r2c风扇脚本
# wget -P target/linux/rockchip/armv8/base-files/etc/init.d/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3328/base-files/etc/init.d/fa-rk3328-pwmfan
# wget -P target/linux/rockchip/armv8/base-files/usr/bin/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3328/base-files/usr/bin/start-rk3328-pwm-fan.sh
mkdir -p target/linux/rockchip/armv8/base-files/etc/init.d
mkdir -p target/linux/rockchip/armv8/base-files/usr/bin
chmod +x $GITHUB_WORKSPACE/patches/fa-rk3328-pwmfan
chmod +x $GITHUB_WORKSPACE/patches/start-rk3328-pwm-fan.sh
cp -f -p $GITHUB_WORKSPACE/patches/fa-rk3328-pwmfan target/linux/rockchip/armv8/base-files/etc/init.d/fa-rk3328-pwmfan
cp -f -p $GITHUB_WORKSPACE/patches/start-rk3328-pwm-fan.sh target/linux/rockchip/armv8/base-files/usr/bin/start-rk3328-pwm-fan.sh

## 添加rtl8821cu驱动
svn export https://github.com/immortalwrt/immortalwrt/trunk/package/kernel/rtl8821cu package/kernel/rtl8821cu

## 添加 luci 界面 cpu 温度，cpu 使用率
rm -rf feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
wget -P feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/ https://github.com/immortalwrt/luci/raw/master/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
sed -i "/target : '')/target : '') + (tempinfo || '')/" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.j
sed -i "/description + ' /description : ''/" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.j
sed -i "/\/ ' : '') + (luciversion || '')/)/" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.j
cat feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

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
git clone https://github.com/sbwml/luci-app-alist package/new/luci-app-alist

## Add luci-app-wechatpush
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## Add autoreboot
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-autoreboot package/new/luci-app-autoreboot

## Add luci-app-accesscontrol
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-accesscontrol package/new/luci-app-accesscontrol

## Add luci-app-poweroff
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-poweroff package/new/luci-app-poweroff

## Add luci-app-wolplus
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wolplus package/new/luci-app-wolplus

## Add luci-app-onliner
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-onliner package/new/luci-app-onliner

## Add luci-app-irqbalance
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-irqbalance package/new/luci-app-irqbalance

## Add luci-app-AdguardHome
svn export https://github.com/kiddin9/openwrt-packages/trunk/adguardhome package/new/adguardhome
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adguardhome package/new/luci-app-adguardhome
sed -i '1,2d' package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
# sed -i 's/6h/1h/g' package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
sed -i 's/4194304/8388608/g' package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
sed -i "/  upstream_dns_file: ""/i\  - 114.114.114.114" package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
sed -i "/  upstream_dns_file: ""/i\  - 119.29.29.29" package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml

## Add luci-app-lucky
# svn export https://github.com/kiddin9/openwrt-packages/trunk/lucky package/new/lucky
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-lucky package/new/luci-app-lucky

## Add luci-app-qbittorrent
svn export https://github.com/kiddin9/openwrt-packages/trunk/qBittorrent-Enhanced-Edition package/new/qBittorrent-Enhanced-Edition
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-qbittorrent package/new/luci-app-qbittorrent
## qbittorrent依赖
svn export https://github.com/kiddin9/openwrt-packages/trunk/qt6tools package/new/qt6tools
svn export https://github.com/kiddin9/openwrt-packages/trunk/qt6base package/new/qt6base
svn export https://github.com/kiddin9/openwrt-packages/trunk/libdouble-conversion package/new/libdouble-conversion

## Add luci-app-fileassistant luci-app-filetransfer
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-fileassistant package/new/luci-app-fileassistant
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-filetransfer package/new/luci-app-filetransfer
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-lib-fs package/new/luci-lib-fs

## Add luci-app-cpufreq
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-cpufreq package/new/luci-app-cpufreq
sed -i 's/1512000/1200000/g' package/new/luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq

## Add luci-app-wrtbwmon
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wrtbwmon package/new/luci-app-wrtbwmon
# svn export https://github.com/kiddin9/openwrt-packages/trunk/wrtbwmon package/new/wrtbwmon

## Add luci-app-ramfree
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ramfree package/new/luci-app-ramfree

## Add luci-app-guest-wifi
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-guest-wifi package/new/luci-app-guest-wifi

## Add luci-app-socat
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-socat package/new/luci-app-socat
svn export https://github.com/chenmozhijin/luci-app-socat/trunk/luci-app-socat package/new/luci-app-socat

## Add luci-app-ddns
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ddns package/new/luci-app-ddns
# svn export https://github.com/kiddin9/openwrt-packages/trunk/ddns-scripts package/new/ddns-scripts

## Add luci-app-mosdns
rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/new/luci-app-mosdns
git clone https://github.com/sbwml/v2ray-geodata package/new/v2ray-geodata

## Add luci-app-adbyby-plus
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adbyby-plus package/new/luci-app-adbyby-plus
svn export https://github.com/kiddin9/openwrt-packages/trunk/adbyby package/new/adbyby

## Add luci-app-ddns-go
svn export https://github.com/sirpdboy/luci-app-ddns-go/trunk/luci-app-ddns-go package/new/luci-app-ddns-go
svn export https://github.com/sirpdboy/luci-app-ddns-go/trunk/ddns-go package/new/ddns-go

## Add automount
svn export https://github.com/kiddin9/openwrt-packages/trunk/automount package/new/automount
svn export https://github.com/kiddin9/openwrt-packages/trunk/ntfs3-mount package/new/ntfs3-mount
# svn export https://github.com/kiddin9/openwrt-packages/trunk/lua-neturl package/new/lua-neturl

## Add autocore
svn export https://github.com/kiddin9/openwrt-packages/trunk/autocore package/new/autocore

## Add luci-app-wireguard
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wireguard package/new/luci-app-wireguard

# Boost 通用即插即用
rm -rf feeds/packages/net/miniupnpd
svn export https://github.com/immortalwrt/packages/trunk/net/miniupnpd feeds/packages/net/miniupnpd

## ssr passwall vssr bypass依赖
git clone https://github.com/kenzok8/small package/new/small

## openclash
bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64

## ShellClash
# bash $GITHUB_WORKSPACE/scripts/ShellClash.sh

## zsh
bash $GITHUB_WORKSPACE/scripts/zsh.sh

## turboacc
bash $GITHUB_WORKSPACE/scripts/turboacc_5_15.sh
