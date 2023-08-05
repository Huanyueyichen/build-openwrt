#!/bin/bash

cp -rf $GITHUB_WORKSPACE/patches/BBRv2/kernel/* ./target/linux/generic/hack-5.10/
cp -rf $GITHUB_WORKSPACE/patches/BBRv2/openwrt/package ./
wget -qO - https://github.com/openwrt/openwrt/commit/7db9763.patch | patch -p1
