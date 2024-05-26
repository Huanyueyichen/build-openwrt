#!/bin/bash

## rockchip机型,默认内核5.15，修改内核为6.1
sed -i 's/PATCHVER:=6.1/PATCHVER:=6.6/g' target/linux/rockchip/Makefile

## 移除 SNAPSHOT 标签
# sed -i 's,-SNAPSHOT,,g' include/version.mk
# sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

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
# cp -rf $GITHUB_WORKSPACE/patches/default-settings package/new/default-settings

## 下载主题luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
# sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/' ./feeds/luci/collections/luci/Makefile
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile
## 修改argon背景图片
# rm -rf feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
# cp -f $GITHUB_WORKSPACE/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile


## Add luci-app-wechatpush
# git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## Add luci-app-socat
rm -rf feeds/packages/net/socat
git clone https://github.com/immortalwrt/packages package/new/immortalwrt-packages
mv package/new/immortalwrt-packages/net/socat package/new/socat
rm -rf package/new/immortalwrt-packages
rm -rf feeds/luci/applications/luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/chenmozhijin-socat
mv -n package/new/chenmozhijin-socat/luci-app-socat package/new/
rm -rf package/new/chenmozhijin-socat

## Add luci-app-ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/packages/net/ddns-go
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo
mv -n package/new/ddnsgo/*ddns-go package/new/
rm -rf package/new/ddnsgo

## Add luci-app-mosdns
# rm -rf feeds/packages/net/v2ray-geodata
# git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/new/luci-app-mosdns
# git clone https://github.com/sbwml/v2ray-geodata package/new/v2ray-geodata


## clone kiddin9/openwrt-packages仓库
git clone https://github.com/kiddin9/openwrt-packages package/new/openwrt-packages

########## 添加包

## alist编译环境
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/net/alist
git clone https://github.com/sbwml/luci-app-alist package/new/sbwml-alist
mv package/new/sbwml-alist/luci-app-alist package/new/luci-app-alist
mv package/new/sbwml-alist/alist package/new/alist
rm -rf package/new/sbwml-alist

## aria2
# rm -rf feeds/luci/applications/luci-app-aria2
# rm -rf feeds/packages/net/aria2
# rm -rf feeds/packages/net/ariang
# mv package/new/openwrt-packages/aria2 package/new/aria2
# mv package/new/openwrt-packages/ariang package/new/ariang
# mv package/new/openwrt-packages/luci-app-aria2 package/new/luci-app-aria2

## aliyundrive-webdav
# mv package/new/openwrt-packages/luci-app-aliyundrive-webdav package/new/luci-app-aliyundrive-webdav
# mv package/new/openwrt-packages/aliyundrive-webdav package/new/aliyundrive-webdav

## Add luci-app-wolplus
mv package/new/openwrt-packages/luci-app-wolplus package/new/luci-app-wolplus

## Add luci-app-onliner
mv package/new/openwrt-packages/luci-app-onliner package/new/luci-app-onliner

## Add luci-app-fileassistant luci-app-filetransfer
mv package/new/openwrt-packages/luci-app-fileassistant package/new/luci-app-fileassistant
mv package/new/openwrt-packages/luci-app-filetransfer package/new/luci-app-filetransfer
mv package/new/openwrt-packages/luci-lib-fs package/new/luci-lib-fs

## Add luci-app-poweroff
# mv package/new/openwrt-packages/luci-app-poweroff package/new/luci-app-poweroff

## Add luci-app-irqbalance
# sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
# mv package/new/openwrt-packages/luci-app-irqbalance package/new/luci-app-irqbalance

## qBittorrent
rm -rf feeds/packages/net/qBittorrent-static
rm -rf feeds/packages/net/qBittorrent
rm -rf feeds/luci/applications/luci-app-qbittorrent
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

## Add luci-app-AdguardHome
rm -rf feeds/packages/net/adguardhome
mv package/new/openwrt-packages/adguardhome package/new/adguardhome
mv package/new/openwrt-packages/luci-app-adguardhome package/new/luci-app-adguardhome
sed -i '1,2d' package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
# sed -i 's/6h/1h/g' package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
# sed -i 's/4194304/8388608/g' package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
sed -i "/  upstream_dns_file: ""/i\  - 114.114.114.114" package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
sed -i "/  upstream_dns_file: ""/i\  - 119.29.29.29" package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml

rm -rf package/new/openwrt-packages

## passwall
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/net/brook
rm -rf feeds/packages/net/chinadns-ng
rm -rf feeds/packages/net/dns2socks
rm -rf feeds/packages/net/dns2tcp
rm -rf feeds/packages/net/hysteria
rm -rf feeds/packages/net/ipt2socks
rm -rf feeds/packages/net/microsocks
rm -rf feeds/packages/net/naiveproxy
rm -rf feeds/packages/net/pdnsd-alt
rm -rf feeds/packages/net/shadowsocks-rust
rm -rf feeds/packages/net/shadowsocksr-libev
rm -rf feeds/packages/net/simple-obfs
rm -rf feeds/packages/net/sing-box
rm -rf feeds/packages/net/ssocks
rm -rf feeds/packages/net/tcping
rm -rf feeds/packages/net/trojan-go
rm -rf feeds/packages/net/trojan-plus
rm -rf feeds/packages/net/trojan
rm -rf feeds/packages/net/tuic-client
rm -rf feeds/packages/net/v2ray-core
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/v2ray-plugin
rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/xray-plugin

git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall package/new/openwrt-passwall
mv -n package/new/openwrt-passwall/luci-app-passwall package/new/
rm -rf package/new/openwrt-passwall
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/new/passwall

## openclash
rm -rf feeds/luci/applications/luci-app-openclash
git clone --depth 1 https://github.com/vernesong/OpenClash package/new/OpenClash
mv -n package/new/OpenClash/luci-app-openclash package/new/
rm -rf package/new/OpenClash
# bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64

## ShellClash
# bash $GITHUB_WORKSPACE/scripts/ShellClash.sh

## zsh
# bash $GITHUB_WORKSPACE/scripts/zsh.sh

## turboacc
# bash $GITHUB_WORKSPACE/scripts/turboacc_5_15.sh
# curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

ls -1 package/new/
