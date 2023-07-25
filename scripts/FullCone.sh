#!/bin/bash

svn export https://github.com/immortalwrt/immortalwrt/tree/openwrt-21.02/package/network/utils/fullconenat package/new/fullconenat
wget -P target/linux/generic/hack-5.4/ https://github.com/immortalwrt/immortalwrt/blob/openwrt-21.02/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
patch -d feeds/luci -p1 -i ../../../patches/fullconenat-luci.patch
rm -rf package/network/config/firewall/patches
svn export https://github.com/immortalwrt/immortalwrt/tree/openwrt-21.02/package/network/config/firewall/patches package/network/config/firewall/patches
