#!/bin/bash

svn export https://github.com/immortalwrt/immortalwrt/branches/openwrt-21.02/package/network/utils/fullconenat package/new/fullconenat
wget -P target/linux/generic/hack-5.4/ https://github.com/immortalwrt/immortalwrt/blob/openwrt-21.02/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
patch -d feeds/luci -p1 -i $GITHUB_WORKSPACE/patches/fullconenat-luci.patch
svn export https://github.com/immortalwrt/immortalwrt/branches/openwrt-21.02/package/network/config/firewall/patches package/network/config/firewall/patches
