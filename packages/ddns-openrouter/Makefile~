#
# Copyright (C) 2014 nanpuyue <empire.x@qq.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ddns-openrouter
PKG_VERSION:=2014.03.27
PKG_RELEASE:=1
PKG_MAINTAINER:=openrouter <empire.x@qq.com>

PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_SOURCE_URL:=http://592.3322.org:592/OpenRouter/
PKG_MD5SUM:=069e71ddd98404fb452fd97170757a39


include $(INCLUDE_DIR)/package.mk

define Package/ddns-openrouter
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=Dynamic DNS Scripts openrouter
  PKGARCH:=all
endef

define Package/ddns-openrouter/description
	Dynamic DNS Scripts buy openrouter 2014.03.07
endef

define Build/Compile
endef

define Package/install
endef

$(eval $(call BuildPackage,ddns-openrouter))
