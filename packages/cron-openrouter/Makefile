#
# Copyright (C) 2014 nanpuyue <empire.x@qq.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cron-openrouter
PKG_VERSION:=2014.03.10
PKG_RELEASE:=1
PKG_MAINTAINER:=openrouter <empire.x@qq.com>

PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_SOURCE_URL:=http://592.3322.org:592/OpenRouter/
PKG_MD5SUM:=56b85a251ae2d7341b40449d6419f020


include $(INCLUDE_DIR)/package.mk

define Package/cron-openrouter
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=cron-openrouter
  PKGARCH:=all
endef

define Package/cron-openrouter/description
	Dynamic DNS Scripts buy openrouter 2014.03.07
endef

define Build/Compile
endef

define Package/cron-openrouter/conffiles
/etc/config/cron
/etc/config/ucitrack
endef

define Package/cron-openrouter/install
	$(INSTALL_DIR) $(1)
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,cron-openrouter))
