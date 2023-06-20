#!/bin/bash


## 修改openwrt登陆地址,把下面的192.168.11.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

## 下载主题luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile

## r2s r2c风扇脚本
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
wget -P target/linux/rockchip/armv8/base-files/etc/init.d/ https://github.com/friendlyarm/friendlywrt/blob/master-v22.03/target/linux/rockchip/armv8/base-files/etc/init.d/fa-fancontrol
wget -P target/linux/rockchip/armv8/base-files/usr/bin/ https://github.com/friendlyarm/friendlywrt/blob/master-v22.03/target/linux/rockchip/armv8/base-files/usr/bin/cputemp.sh
wget -P target/linux/rockchip/armv8/base-files/usr/bin/ https://github.com/friendlyarm/friendlywrt/blob/master-v22.03/target/linux/rockchip/armv8/base-files/usr/bin/fa-fancontrol-direct.sh
wget -P target/linux/rockchip/armv8/base-files/usr/bin/ https://github.com/friendlyarm/friendlywrt/blob/master-v22.03/target/linux/rockchip/armv8/base-files/usr/bin/fa-fancontrol.sh
