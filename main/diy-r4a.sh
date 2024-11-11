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

## set default-setting
cp -rf $GITHUB_WORKSPACE/patches/default-settings package/new/default-settings

## 下载主题luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
# sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile

## golang编译环境
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

## Add luci-app-ddns-go
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo
mv -n package/new/ddnsgo/*ddns-go package/new/
rm -rf package/new/ddnsgo

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

## Add luci-app-ramfree
# mv package/new/openwrt-packages/luci-app-ramfree package/new/luci-app-ramfree

## Add luci-app-upnp
# rm -rf feeds/luci/applications/luci-app-upnp
# rm -rf feeds/packages/net/miniupnpd
# mv package/new/openwrt-packages/miniupnpd package/new/miniupnpd
# mv package/new/openwrt-packages/luci-app-upnp package/new/luci-app-upnp

## Add luci-app-wechatpush
mv package/new/openwrt-packages/luci-app-wechatpush package/new/luci-app-wechatpush


rm -rf package/new/openwrt-packages
#################################

## openclash
# bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64

## turboacc
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh --no-sfe

ls -1 package/new/
