#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#


echo -e "\\ndefine Device/nsy_g68-plus
  DEVICE_VENDOR := NSY
  DEVICE_MODEL := G68
  SOC := rk3568
  DEVICE_DTS := rockchip/rk3568-nsy-g68-plus
  SUPPORTED_DEVICES := nsy,g68-plus
  UBOOT_DEVICE_NAME := generic-rk3568
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
  DEVICE_PACKAGES := kmod-gpio-button-hotplug kmod-nvme kmod-scsi-core kmod-hwmon-pwmfan kmod-thermal kmod-switch-rtl8306 kmod-switch-rtl8366-smi kmod-switch-rtl8366rb kmod-switch-rtl8366s kmod-switch-rtl8367b swconfig kmod-swconfig kmod-r8168 kmod-mt7916-firmware
endef
TARGET_DEVICES += nsy_g68-plus" >> target/linux/rockchip/image/armv8.mk

# 复制 02_network 网络配置文件到 target/linux/rockchip/armv8/base-files/etc/board.d/ 目录下
cp -f $GITHUB_WORKSPACE/configfiles/02_network target/linux/rockchip/armv8/base-files/etc/board.d/02_network

# cp -f $GITHUB_WORKSPACE/configfiles/uboot-Makefile package/boot/uboot-rockchip/Makefile
grep -q 'seewo_sv21 \\$' package/boot/uboot-rockchip/Makefile && sed -i "s/seewo_sv21 \\\\/seewo_sv21 \\\\\n    nsy_g68-plus \\\\\n    nsy_g16-plus \\\\\n    bdy_g18-pro \\\\/g" package/boot/uboot-rockchip/Makefile || sed -i "s/seewo_sv21/seewo_sv21 \\\\\n    nsy_g68-plus \\\\\n    nsy_g16-plus \\\\\n    bdy_g18-pro/g" package/boot/uboot-rockchip/Makefile

#cp -f $GITHUB_WORKSPACE/configfiles/swconfig_install package/base-files/files/etc/init.d/swconfig_install
#chmod 755 package/base-files/files/etc/init.d/swconfig_install

cp -f $GITHUB_WORKSPACE/configfiles/rk3568-nsy-g68-plus.dts target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3568-nsy-g68-plus.dts

# 集成 nsy_g68-plus WiFi驱动
mkdir -p package/base-files/files/lib/firmware/mediatek
cp -f $GITHUB_WORKSPACE/configfiles/mt7916_eeprom.bin package/base-files/files/lib/firmware/mediatek/mt7916_eeprom.bin


# rtl8367b驱动资源包，暂时使用这样替换
# wget https://github.com/xiaomeng9597/files/releases/download/files/rtl8367b-lede.tar.gz
# tar -xvf rtl8367b-lede.tar.gz


# openwrt主线rtl8367b驱动资源包，暂时使用这样替换
wget https://github.com/xiaomeng9597/files/releases/download/files/rtl8367b-openwrt.tar.gz
tar -xvf rtl8367b-openwrt.tar.gz
# 适配机型代码结束


# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
