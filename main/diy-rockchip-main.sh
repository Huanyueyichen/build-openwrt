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

## r2s r2c风扇脚本
mkdir -p target/linux/rockchip/armv8/base-files/etc/init.d
mkdir -p target/linux/rockchip/armv8/base-files/usr/bin
cp -f $GITHUB_WORKSPACE/patches/fa-rk3328-pwmfan target/linux/rockchip/armv8/base-files/etc/init.d/fa-rk3328-pwmfan
cp -f $GITHUB_WORKSPACE/patches/start-rk3328-pwm-fan.sh target/linux/rockchip/armv8/base-files/usr/bin/start-rk3328-pwm-fan.sh
chmod +x target/linux/rockchip/armv8/base-files/etc/init.d/fa-rk3328-pwmfan
chmod +x target/linux/rockchip/armv8/base-files/usr/bin/start-rk3328-pwm-fan.sh

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

## golang编译环境
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

## Add luci-app-ddns-go
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

## Add luci-app-wolplus
git clone https://github.com/animegasan/luci-app-wolplus package/new/luci-app-wolplus

####################################
## clone kiddin9/openwrt-packages仓库
git clone https://github.com/kiddin9/kwrt-packages package/new/openwrt-packages

## Add luci-app-accesscontrol
mv package/new/openwrt-packages/luci-app-accesscontrol package/new/luci-app-accesscontrol

## Add luci-app-autoreboot
mv package/new/openwrt-packages/luci-app-autoreboot package/new/luci-app-autoreboot

## Add luci-app-onliner
mv package/new/openwrt-packages/luci-app-onliner package/new/luci-app-onliner

## Add luci-app-fileassistant
mv package/new/openwrt-packages/luci-app-fileassistant package/new/luci-app-fileassistant

## Add luci-app-wireguard
# mv package/new/openwrt-packages/luci-app-wireguard package/new/luci-app-wireguard

## Add luci-app-poweroff
# mv package/new/openwrt-packages/luci-app-poweroff package/new/luci-app-poweroff

## Add luci-app-qbittorrent
mv package/new/openwrt-packages/qBittorrent-Enhanced-Edition package/new/qBittorrent-Enhanced-Edition
mv package/new/openwrt-packages/luci-app-qbittorrent package/new/luci-app-qbittorrent
## qbittorrent依赖
mv package/new/openwrt-packages/qt6tools package/new/qt6tools
mv package/new/openwrt-packages/qt6base package/new/qt6base
mv package/new/openwrt-packages/libdouble-conversion package/new/libdouble-conversion
rm -rf feeds/packages/libs/libtorrent-rasterbar
mv package/new/openwrt-packages/libtorrent-rasterbar package/new/libtorrent-rasterbar

## Add luci-app-ramfree
mv package/new/openwrt-packages/luci-app-ramfree package/new/luci-app-ramfree

## Add luci-app-partexp
mv package/new/openwrt-packages/luci-app-partexp package/new/luci-app-partexp

## Add luci-app-diskman
mv package/new/openwrt-packages/luci-app-diskman package/new/luci-app-diskman

## Add autocore
# mv package/new/openwrt-packages/autocore package/new/autocore

## Add luci-app-upnp
rm -rf feeds/luci/applications/luci-app-upnp
rm -rf feeds/packages/net/miniupnpd
mv package/new/openwrt-packages/miniupnpd package/new/miniupnpd
mv package/new/openwrt-packages/luci-app-upnp package/new/luci-app-upnp

## Add luci-app-mosdns
mv package/new/openwrt-packages/luci-app-mosdns package/new/luci-app-mosdns
mv package/new/openwrt-packages/mosdns package/new/mosdns
rm -rf feeds/packages/net/v2ray-geodata
mv package/new/openwrt-packages/v2ray-geodata package/new/v2ray-geodata
mv package/new/openwrt-packages/v2dat package/new/v2dat

## luci-app-homeproxy
mv package/new/openwrt-packages/luci-app-homeproxy package/new/luci-app-homeproxy
mv package/new/openwrt-packages/chinadns-ng package/new/chinadns-ng

rm -rf package/new/openwrt-packages
#################################

## Add autocore
git clone https://github.com/immortalwrt/immortalwrt package/new/immortalwrt
mv package/new/immortalwrt/package/emortal/autocore package/new/autocore
mv package/new/immortalwrt/package/emortal/automount package/new/automount
rm -rf package/new/immortalwrt

## openclash
bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64

## turboacc
# bash $GITHUB_WORKSPACE/scripts/turboacc_5_15.sh
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

ls -1 package/new/
