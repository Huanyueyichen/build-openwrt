#!/bin/bash

## Add luci-app-openclash
git clone --depth 1 https://github.com/vernesong/OpenClash package/new/OpenClash && mv -n package/new/OpenClash/luci-app-openclash package/new/; rm -rf package/new/OpenClash

mkdir -p package/new/luci-app-openclash/root/etc/openclash/core

# CLASH_DEV_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-${1}.tar.gz"
# CLASH_TUN_URL=$(curl -fsSL https://api.github.com/repos/vernesong/OpenClash/contents/master/premium\?ref\=core | grep download_url | grep $1 | awk -F '"' '{print $4}' | grep -v "v3" )
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-${1}.tar.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

# wget -qO- $CLASH_DEV_URL | tar xOvz > package/new/luci-app-openclash/root/etc/openclash/core/clash
# wget -qO- $CLASH_TUN_URL | gunzip -c > package/new/luci-app-openclash/root/etc/openclash/core/clash_tun
wget -qO- $CLASH_META_URL | tar xOvz > package/new/luci-app-openclash/root/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > package/new/luci-app-openclash/root/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > package/new/luci-app-openclash/root/etc/openclash/GeoSite.dat

chmod +x package/new/luci-app-openclash/root/etc/openclash/core/clash*
