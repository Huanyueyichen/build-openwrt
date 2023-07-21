#!/bin/bash

# Download kernel patch to target/linux/generic/hack-5.4/
wget -P target/linux/generic/hack-5.4/ https://github.com/Paull/openwrt-fullconenat/raw/master/files/952-net-conntrack-events-support-multiple-registrant.patch

# Download firewall3 patch to package/network/config/firewall/patches/
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://github.com/Paull/openwrt-fullconenat/raw/master/files/fullconenat-fw3.patch

# Clone this repo
# git clone -b master --single-branch https://github.com/Paull/openwrt-fullconenat package/new/fullconenat
