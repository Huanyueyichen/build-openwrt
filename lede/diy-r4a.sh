#!/bin/bash
#

# 修改openwrt登陆地址
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

# rm -rf package/new
mkdir -p package/new

#删除原默认主题
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
# rm -rf feeds/package/themes/luci-theme-bootstrap
# rm -rf feeds/package/themes/luci-theme-material
# rm -rf feeds/package/themes//luci-theme-netgear
# rm -rf feeds/package/themes//luci-theme-ifit

## 下载argon主题
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
## 修改argon背景图片
rm -rf package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/bg1.jpg package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

#取消原主题luci-theme-bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# 修改 argon 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

## Add luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/socat && mv -n package/new/socat/luci-app-socat package/new/; rm -rf package/new/socat

## Add luci-app-ddns-go
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 21.x feeds/packages/lang/golang
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo && mv -n package/new/ddnsgo/*ddns-go package/new/; rm -rf package/new/ddnsgo

## clone kiddin9/openwrt-packages仓库
git clone https://github.com/kiddin9/openwrt-packages package/new/openwrt-packages

## 添加包
mv package/new/openwrt-packages/luci-app-wolplus package/new/luci-app-wolplus
mv package/new/openwrt-packages/luci-app-onliner package/new/luci-app-onliner

rm -rf package/new/openwrt-packages

ls package/new
