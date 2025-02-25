#!/bin/bash

## 默认内核5.15，修改内核为6.1
# sed -i 's/PATCHVER:=5.15/PATCHVER:=6.1/g' target/linux/rockchip/Makefile

## 移除 SNAPSHOT 标签
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

# rm -rf package/new
mkdir -p package/new


## 下载主题luci-theme-argon
# rm -rf feeds/luci/themes/luci-theme-argon
# rm -rf feeds/luci/applications/luci-app-argon-config
# git clone https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
# git clone https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
# sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile
## 修改argon背景图片
rm -rf feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

## Add luci-app-wechatpush
rm -rf feeds/luci/applications/luci-app-wechatpush
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## Add luci-app-socat
# rm -rf feeds/luci/applications/luci-app-socat
# git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/chenmozhijin-socat
# mv -n package/new/chenmozhijin-socat/luci-app-socat package/new/
# rm -rf package/new/chenmozhijin-socat

## Add luci-app-ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/packages/net/ddns-go
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo
mv -n package/new/ddnsgo/*ddns-go package/new/
rm -rf package/new/ddnsgo

## Add luci-app-mihomo
# git clone https://github.com/morytyann/OpenWrt-mihomo package/new/OpenWrt-mihomo
# mv -n package/new/OpenWrt-mihomo/*mihomo package/new/
# rm -rf package/new/OpenWrt-mihomo

## adguardhome
git clone -b patch-1 https://github.com/kiddin9/openwrt-adguardhome package/new/openwrt-adguardhome
mv package/new/openwrt-adguardhome/*adguardhome package/new/
rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/AdGuardHome_template.yaml package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/links.txt package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
rm -rf package/new/openwrt-adguardhome

## clone kiddin9/openwrt-packages仓库
git clone https://github.com/kiddin9/kwrt-packages package/new/openwrt-packages

########## 添加包

## alist编译环境
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang
# rm -rf feeds/luci/applications/luci-app-alist
# rm -rf feeds/packages/net/alist
# git clone https://github.com/sbwml/luci-app-alist package/new/sbwml-alist
# mv package/new/sbwml-alist/luci-app-alist package/new/luci-app-alist
# mv package/new/sbwml-alist/alist package/new/alist
# rm -rf package/new/sbwml-alist


## Add luci-app-wolplus
# mv package/new/openwrt-packages/luci-app-wolplus package/new/luci-app-wolplus

## Add luci-app-onliner
mv package/new/openwrt-packages/luci-app-onliner package/new/luci-app-onliner

## Add luci-app-poweroff
# mv package/new/openwrt-packages/luci-app-poweroff package/new/luci-app-poweroff

## Add luci-app-fileassistant luci-app-filetransfer
# mv package/new/openwrt-packages/luci-app-fileassistant package/new/luci-app-fileassistant
# mv package/new/openwrt-packages/luci-app-filetransfer package/new/luci-app-filetransfer
# mv package/new/openwrt-packages/luci-lib-fs package/new/luci-lib-fs

## Add luci-app-irqbalance
# sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
# mv package/new/openwrt-packages/luci-app-irqbalance package/new/luci-app-irqbalance

## Add automount
# mv package/new/openwrt-packages/automount package/new/automount
# mv package/new/openwrt-packages/ntfs3-mount package/new/ntfs3-mount

## Add luci-app-partexp
# mv package/new/openwrt-packages/luci-app-partexp package/new/luci-app-partexp

## Add luci-app-diskman
# mv package/new/openwrt-packages/luci-app-diskman package/new/luci-app-diskman

## Add luci-app-smartdns
# rm -rf feeds/packages/net/smartdns
# mv package/new/openwrt-packages/smartdns package/new/smartdns
# rm -rf feeds/luci/applications/luci-app-smartdns
# mv package/new/openwrt-packages/luci-app-smartdns package/new/luci-app-smartdns

## Add luci-app-upnp
rm -rf feeds/luci/applications/luci-app-upnp
rm -rf feeds/packages/net/miniupnpd
mv package/new/openwrt-packages/miniupnpd package/new/miniupnpd
mv package/new/openwrt-packages/luci-app-upnp package/new/luci-app-upnp

## Add luci-app-mosdns
rm -rf feeds/packages/net/v2ray-geodata
mv package/new/openwrt-packages/v2ray-geodata package/new/v2ray-geodata
mv package/new/openwrt-packages/v2dat package/new/v2dat
mv package/new/openwrt-packages/mosdns package/new/mosdns
mv package/new/openwrt-packages/luci-app-mosdns package/new/luci-app-mosdns


rm -rf package/new/openwrt-packages


## openclash
rm -rf feeds/luci/applications/luci-app-openclash
bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64

## zsh
bash $GITHUB_WORKSPACE/scripts/zsh.sh

## turboacc
# curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

ls -1 package/new/
