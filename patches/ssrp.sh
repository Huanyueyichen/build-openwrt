#!/bin/bash

echo 'ssrp'

## Add luci-app-ssr-plus
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ssr-plus package/new/luci-app-ssr-plus
## ssr-plus依赖
svn export https://github.com/kiddin9/openwrt-packages/trunk/dns2socks package/new/dns2socks
svn export https://github.com/kiddin9/openwrt-packages/trunk/dns2tcp package/new/dns2tcp
svn export https://github.com/kiddin9/openwrt-packages/trunk/lua-neturl package/new/lua-neturl
svn export https://github.com/kiddin9/openwrt-packages/trunk/tcping package/new/tcping
svn export https://github.com/kiddin9/openwrt-packages/trunk/shadowsocksr-libev package/new/shadowsocksr-libev
svn export https://github.com/kiddin9/openwrt-packages/trunk/chinadns-ng package/new/chinadns-ng
svn export https://github.com/kiddin9/openwrt-packages/trunk/hysteria package/new/hysteria
svn export https://github.com/kiddin9/openwrt-packages/trunk/ipt2socks package/new/ipt2socks
svn export https://github.com/kiddin9/openwrt-packages/trunk/naiveproxy package/new/naiveproxy
svn export https://github.com/kiddin9/openwrt-packages/trunk/redsocks2 package/new/redsocks2
svn export https://github.com/kiddin9/openwrt-packages/trunk/shadowsocks-rust package/new/shadowsocks-rust
svn export https://github.com/kiddin9/openwrt-packages/trunk/simple-obfs package/new/simple-obfs
svn export https://github.com/kiddin9/openwrt-packages/trunk/v2ray-plugin package/new/v2ray-plugin
svn export https://github.com/kiddin9/openwrt-packages/trunk/trojan package/new/trojan
svn export https://github.com/kiddin9/openwrt-packages/trunk/gn package/new/gn
