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

rm -rf package/new
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

## Add luci-app-mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/new/luci-app-mosdns
# rm -rf feeds/packages/net/v2ray-geodata
# git clone https://github.com/sbwml/v2ray-geodata package/new/v2ray-geodata

## adguardhome
git clone -b patch-1 https://github.com/kiddin9/openwrt-adguardhome package/new/openwrt-adguardhome
mv package/new/openwrt-adguardhome/*adguardhome package/new/
rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/AdGuardHome_template.yaml package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/links.txt package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
# sed -i 's/+adguardhome/+PACKAGE_$(PKG_NAME)_INCLUDE_binary:adguardhome/g' package/new/luci-app-adguardhome/Makefile
rm -rf package/new/openwrt-adguardhome

## Add luci-app-fileassistant
git clone https://github.com/lyin888/luci-app-fileassistant package/new/luci-app-fileassistant

## Add luci-app-wolplus
git clone https://github.com/animegasan/luci-app-wolplus package/new/luci-app-wolplus

## Add luci-app-qbittorrent
git clone https://github.com/immortalwrt/luci package/new/immortalwrt-luci
mv package/new/immortalwrt-luci/applications/luci-app-qbittorrent package/new/luci-app-qbittorrent
sed -i 's/..\/..\/luci.mk/\$(TOPDIR)\/feeds\/luci\/luci.mk/' package/new/luci-app-qbittorrent/Makefile
mv package/new/immortalwrt-luci/applications/luci-app-usb-printer package/new/luci-app-usb-printer
sed -i 's/..\/..\/luci.mk/\$(TOPDIR)\/feeds\/luci\/luci.mk/' package/new/luci-app-usb-printer/Makefile
mv package/new/immortalwrt-luci/applications/luci-app-autoreboot package/new/luci-app-autoreboot
sed -i 's/..\/..\/luci.mk/\$(TOPDIR)\/feeds\/luci\/luci.mk/' package/new/luci-app-autoreboot/Makefile
rm -rf package/new/immortalwrt-luci
git clone https://github.com/immortalwrt/packages package/new/immortalwrt-packages
mv package/new/immortalwrt-packages/net/qBittorrent-Enhanced-Edition package/new/qBittorrent-Enhanced-Edition
mv package/new/immortalwrt-packages/utils/qt6tools package/new/qt6tools
mv package/new/immortalwrt-packages/libs/qt6base package/new/qt6base
mv package/new/immortalwrt-packages/libs/libdouble-conversion package/new/libdouble-conversion
mv package/new/immortalwrt-packages/libs/libtorrent-rasterbar package/new/libtorrent-rasterbar
rm -rf package/new/immortalwrt-packages

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
