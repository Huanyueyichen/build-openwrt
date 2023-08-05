#!/bin/bash

cp -rf $GITHUB_WORKSPACE/patches/BBRv2-2203/kernel/* ./target/linux/generic/hack-5.10/
cp -rf $GITHUB_WORKSPACE/patches/BBRv2-2203/openwrt/package/kernel/linux/files/sysctl-tcp-bbr2.conf package/kernel/linux/files/sysctl-tcp-bbr2.conf
wget -qO - https://github.com/openwrt/openwrt/commit/7db9763.patch | patch -p1
