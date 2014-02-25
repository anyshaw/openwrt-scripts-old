#!/bin/sh

#apt-get install g++ libncurses5-dev zlib1g-dev bison flex unzip autoconf gawk make gettext gettext texinfo sharutils gcc binutils ncurses-term patch bzip2 libbz2-dev libz-dev asciidoc subversion sphinxsearch libtool git git-core curl

cd ~/openwrt

git clone git://git.openwrt.org/openwrt.git barrier_breaker
git clone git://github.com/sancome/openwrt-plus.git

cp ./barrier_breaker/feeds.conf.default ./barrier_breaker/feeds.conf

./barrier_breaker/scripts/feeds update -a
./barrier_breaker/scripts/feeds install -a

#operating package directory
#package install
cp -rf ./openwrt-plus/package/* ./barrier_breaker/package/

#patch openssl
patch -p0 ./barrier_breaker/package/libs/openssl/Makefile < ./barrier_breaker/package/libs/openssl/Makefile.diff
rm -rf ./barrier_breaker/package/libs/openssl/Makefile.diff

#operating update directory
#remove old packages
rm -rf ./barrier_breaker/feeds/packages/multimedia/gst-plugins-bad
rm -rf ./barrier_breaker/feeds/packages/multimedia/gst-plugins-base
rm -rf ./barrier_breaker/feeds/packages/multimedia/gst-plugins-good
rm -rf ./barrier_breaker/feeds/packages/multimedia/gst-plugins-ugly
rm -rf ./barrier_breaker/feeds/packages/multimedia/gstreamer

#copy new packages
cp -rf ./openwrt-plus/feeds/* ./barrier_breaker/feeds/

#patch luci
patch -p0 ./barrier_breaker/feeds/luci/contrib/package/luci/Makefile < ./barrier_breaker/feeds/luci/contrib/package/luci/Makefile.diff
rm -rf ./barrier_breaker/feeds/luci/contrib/package/luci/Makefile.diff

#patch luci config
patch -p0 ./barrier_breaker/feeds/luci/libs/web/root/etc/config/luci < ./barrier_breaker/feeds/luci/libs/web/root/etc/config/luci.diff
rm -rf ./barrier_breaker/feeds/luci/libs/web/root/etc/config/luci.diff

#operating fils directory
#copy config files
cp -rf ./openwrt-plus/files ./barrier_breaker/

#delete openwrt-plus
rm -rf ./openwrt-plus

#save dl files to dl-barrier_breaker
if [ ! -d dl-barrier_breaker ]; then
    mkdir ~/openwrt/dl-barrier_breaker
fi

#make
cd ~/openwrt/barrier_breaker
# create symbolic link to download directory
if [ ! -d dl ]; then
    ln -s ~/openwrt/dl-barrier_breaker dl
fi

#cp ~/openwrt/openwrt_scripts/config.db120 ./.config
#make defconfig
#make menuconfig
#make V=99
