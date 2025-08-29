#!/bin/bash

# mkdir -p package/new

## Add luci-app-nikki
git clone https://github.com/nikkinikki-org/OpenWrt-nikki package/new/OpenWrt-nikki
mv package/new/OpenWrt-nikki/nikki package/new/nikki
mv package/new/OpenWrt-nikki/luci-app-nikki package/new/luci-app-nikki
rm -rf package/new/OpenWrt-nikki

mkdir -p package/new/luci-app-nikki/root/etc/nikki/run

GEOIP_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb"
GEOSITE_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat"

wget -qO- $GEOIP_URL > package/new/luci-app-nikki/root/etc/nikki/run/geoip.metadb
wget -qO- $GEOSITE_URL > package/new/luci-app-nikki/root/etc/nikki/run/geosite.dat
