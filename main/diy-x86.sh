#!/bin/bash

## x86机型,默认内核5.15，修改内核为6.1
# sed -i 's/PATCHVER:=5.15/PATCHVER:=6.1/g' target/linux/x86/Makefile

# 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

## alist编译环境
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

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

## Add luci-app-alist
git clone https://github.com/sbwml/luci-app-alist package/new/luci-app-alist

## Add luci-app-wechatpush
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## Add luci-app-socat
# svn export https://github.com/chenmozhijin/luci-app-socat/trunk/luci-app-socat package/new/luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/socat
mv -n package/new/socat/luci-app-socat package/new/
rm -rf package/new/socat

## Add luci-app-ddns-go
# svn export https://github.com/sirpdboy/luci-app-ddns-go/trunk/luci-app-ddns-go package/new/luci-app-ddns-go
# svn export https://github.com/sirpdboy/luci-app-ddns-go/trunk/ddns-go package/new/ddns-go
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo
mv -n package/new/ddnsgo/*ddns-go package/new/
rm -rf package/new/ddnsgo

## Add luci-app-mosdns
rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/new/luci-app-mosdns
git clone https://github.com/sbwml/v2ray-geodata package/new/v2ray-geodata


## clone kiddin9/openwrt-packages仓库
git clone https://github.com/kiddin9/openwrt-packages package/new/openwrt-packages

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

## Add luci-app-wireguard
# mv package/new/openwrt-packages/luci-app-wireguard package/new/luci-app-wireguard

## Add luci-app-irqbalance
# mv package/new/openwrt-packages/luci-app-poweroff package/new/luci-app-poweroff

## Add 
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
mv package/new/openwrt-packages/luci-app-irqbalance package/new/luci-app-irqbalance

## Add luci-app-AdguardHome
# rm -rf feeds/packages/net/adguardhome
# mv package/new/openwrt-packages/adguardhome package/new/adguardhome
mv package/new/openwrt-packages/luci-app-adguardhome package/new/luci-app-adguardhome
rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/AdGuardHome_template.yaml package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/links.txt package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
# sed -i '1,2d' package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
# sed -i 's/6h/1h/g' package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
# sed -i 's/4194304/8388608/g' package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
# sed -i "/  upstream_dns_file: ""/i\  - 2400:3200::1" package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
# sed -i "/  upstream_dns_file: ""/i\  - 114.114.114.114" package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml

## Add luci-app-qbittorrent
mv package/new/openwrt-packages/qBittorrent-Enhanced-Edition package/new/qBittorrent-Enhanced-Edition
mv package/new/openwrt-packages/luci-app-qbittorrent package/new/luci-app-qbittorrent
# svn export https://github.com/immortalwrt/packages/trunk/net/qBittorrent-Enhanced-Edition package/new/qBittorrent-Enhanced-Edition
# svn export https://github.com/immortalwrt/luci/trunk/applications/luci-app-qbittorrent package/new/luci-app-qbittorrent
## qbittorrent依赖
mv package/new/openwrt-packages/qt6tools package/new/qt6tools
mv package/new/openwrt-packages/qt6base package/new/qt6base
mv package/new/openwrt-packages/libdouble-conversion package/new/libdouble-conversion
# svn export https://github.com/immortalwrt/packages/trunk/utils/qt6tools package/new/qt6tools
# svn export https://github.com/immortalwrt/packages/trunk/libs/qt6base package/new/qt6base
# svn export https://github.com/immortalwrt/packages/trunk/libs/libdouble-conversion package/new/libdouble-conversion
rm -rf feeds/packages/libs/libtorrent-rasterbar
mv package/new/openwrt-packages/libtorrent-rasterbar package/new/libtorrent-rasterbar

## Add luci-app-fileassistant luci-app-filetransfer
mv package/new/openwrt-packages/luci-app-fileassistant package/new/luci-app-fileassistant
mv package/new/openwrt-packages/luci-app-filetransfer package/new/luci-app-filetransfer
mv package/new/openwrt-packages/luci-lib-fs package/new/luci-lib-fs

## Add luci-app-cpufreq
mv package/new/openwrt-packages/luci-app-cpufreq package/new/luci-app-cpufreq
sed -i 's/1512000/1200000/g' package/new/luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq

## Add luci-app-wrtbwmon
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wrtbwmon package/new/luci-app-wrtbwmon
# svn export https://github.com/kiddin9/openwrt-packages/trunk/wrtbwmon package/new/wrtbwmon

## Add luci-app-ramfree
mv package/new/openwrt-packages/luci-app-ramfree package/new/luci-app-ramfree

## Add luci-app-adbyby-plus
mv package/new/openwrt-packages/luci-app-adbyby-plus package/new/luci-app-adbyby-plus
mv package/new/openwrt-packages/adbyby package/new/adbyby

## Add automount
mv package/new/openwrt-packages/automount package/new/automount
mv package/new/openwrt-packages/ntfs3-mount package/new/ntfs3-mount

## Add autocore
mv package/new/openwrt-packages/autocore package/new/autocore

rm -rf package/new/openwrt-packages

## ssr passwall vssr bypass依赖
# git clone https://github.com/kenzok8/small package/new/small

## passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall package/new/openwrt-passwall
mv -n package/new/openwrt-passwall/luci-app-passwall package/new/
rm -rf package/new/openwrt-passwall
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/new/passwall

## openclash
bash $GITHUB_WORKSPACE/scripts/openclash.sh amd64

## ShellClash
# bash $GITHUB_WORKSPACE/scripts/ShellClash.sh

## zsh
bash $GITHUB_WORKSPACE/scripts/zsh.sh

## turboacc
# bash $GITHUB_WORKSPACE/scripts/turboacc_5_15.sh
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
