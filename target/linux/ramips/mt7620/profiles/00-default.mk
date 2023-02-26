#
# Copyright (C) 2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/Default
	NAME:=Default Profile
	PACKAGES:= kmod-usb-core kmod-usb2 kmod-usb-ohci kmod-usb-ledtrig-usbport
	PRIORITY:=1
endef

define Profile/Default/Description
	Default package set compatible with most boards.
endef
Default_UBIFS_OPTS:="-m 2048 -e 124KiB -c 1024"
Default_UBI_OPTS:="-m 2048 -p 128KiB -s 2048"
$(eval $(call Profile,Default))
