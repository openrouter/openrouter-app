include $(TOPDIR)/rules.mk

LUCI_TOPDIR=..

PKG_NAME:=luci-openrouter
PKG_RELEASE:=1

PKG_BUILD_PARALLEL:=0

PKG_VERSION:=$(shell $(LUCI_TOPDIR)/build/mkrevision.sh 2>/dev/null || echo unknow)

PKG_BUILD_DEPENDS:=$(if $(STAGING_DIR_ROOT),lua/host)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

LUA_TARGET:=source
LUCI_CFLAGS:=
LUCI_BUILD_PACKAGES:=
LUCI_SELECTED_MODULES:=

ifeq ($(BOARD),brcm-2.4)
  MAKE_FLAGS += CRAP="1"
endif


### Templates ###
define Package/luci/install/template
	$(CP) -a $(PKG_BUILD_DIR)/$(2)/dist/* $(1)/ -R
	$(CP) -a $(PKG_BUILD_DIR)/$(2)/ipkg/* $(1)/CONTROL/ 2>/dev/null || true
endef

### Applications ###
define application
  define Package/luci-app-$(1)
    SECTION:=luci
    CATEGORY:=LuCI
    TITLE:=LuCI - Lua Configuration Interface
    URL:=https://github.com/openrouter/openrouter-app/
    MAINTAINER:=openrouter <empire.x@qq.com>
    PKGARCH:=all
    SUBMENU:=3. Applications
    TITLE:=$(if $(2),$(2),LuCI $(1) application)
	DEPENDS:=$(3)
  endef

  define Package/luci-app-$(1)/install
	$(call Package/luci/install/template,$$(1),applications/luci-$(1))
  endef

  ifneq ($(CONFIG_PACKAGE_luci-app-$(1)),)
    LUCI_SELECTED_MODULES+=applications/luci-$(1)
  endif

  LUCI_BUILD_PACKAGES += luci-app-$(1)
endef

define Package/luci-app-aria2/conffiles
/etc/config/aria2
endef

$(eval $(call application,aria2,LuCI Support for Aria2,\
	+PACKAGE_luci-app-aria2:aria2 \
	+PACKAGE_luci-app-aria2:yaaw))

$(eval $(call application,nwan,nwan configuration module,\
	 +PACKAGE_luci-app-nwan:ip +kmod-macvlan +iptables +iptables-mod-conntrack +iptables-mod-conntrack-extra +iptables-mod-ipopt))

$(eval $(call application,vsftpd,vsftpd configuration module,\
	 +PACKAGE_luci-app-vsftpd:vsftpd))

$(eval $(call application,pptpd,pptpd configuration module,\
	 +PACKAGE_luci-app-pptpd:pptpd))

$(eval $(call application,cron-openrouter,LuCI Support for cron-openrouter,\
	+PACKAGE_luci-app-cron-openrouter:cron-openrouter))

$(eval $(call application,ddns-scripts-openrouter,LuCI Support for ddns-openrouter,\
	+PACKAGE_luci-app-ddns-scripts-openrouter:ddns-openrouter))

$(eval $(call application,DNS-Filter,DNS-Filter configuration module,\
	 +PACKAGE_luci-app-DNS-Filter:libc +bash +screen +wget))

$(eval $(call application,webcam,webcam configuration module,\
	 +PACKAGE_luci-webcam:webcam +mjpg-streamer))

$(eval $(call application,qos_gargoyle,qos_gargoyle configuration module,\
        +PACKAGE_luci-app-qos_gargoyle:qos-gargoyle))

### Compile ###
PKG_CONFIG_DEPENDS=$(patsubst %,CONFIG_PACKAGE_%,$(LUCI_BUILD_PACKAGES))

include $(INCLUDE_DIR)/package.mk

define Build/Prepare
	@if [ ! -x $(LUCI_TOPDIR)/build/mkrevision.sh ]; then \
		echo "*** Repository layout changed!" >&2; \
		echo "*** Please change the LuCI url in feeds.conf to http://svn.luci.subsignal.org/luci/trunk and reinstall the feed with" >&2; \
		echo "*** ./scripts/feeds update luci; ./scripts/feeds install -a -p luci" >&2; \
		exit 1; \
	fi
	mkdir -p $(PKG_BUILD_DIR)
	$(TAR) c -C $(LUCI_TOPDIR) . \
		--exclude=.pc --exclude=.svn --exclude=.git \
		--exclude='boa-0*' --exclude='*.o' --exclude='*.so' \
		--exclude=dist | \
			tar x -C $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef

MAKE_FLAGS += \
	MODULES="$(LUCI_SELECTED_MODULES)" \
	LUA_TARGET="$(LUA_TARGET)" \
	LUA_SHLIBS="-llua -lm -ldl -lcrypt" \
	CFLAGS="$(TARGET_CFLAGS) $(LUCI_CFLAGS) -I$(STAGING_DIR)/usr/include" \
	LDFLAGS="$(TARGET_LDFLAGS) -L$(STAGING_DIR)/usr/lib" \
	NIXIO_TLS="$(NIXIO_TLS)" OS="Linux"


$(foreach b,$(LUCI_BUILD_PACKAGES),$(eval $(call BuildPackage,$(b))))
