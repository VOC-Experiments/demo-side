include $(TOPDIR)/rules.mk
PKG_NAME:=demo-side
PKG_VERSION:=@VERSION@
PKG_RELEASE:=@REVISION@
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
include $(INCLUDE_DIR)/package.mk

define Package/demo-side
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=demo-side canonical CI experiment
  DEPENDS:=+demo-core
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) $(TOPDIR)/recipes/demo-side/src/. $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -fPIC -shared $(PKG_BUILD_DIR)/side.c -ldemo-core -Wl,-soname,libdemo-side.so -o $(PKG_BUILD_DIR)/libdemo-side.so
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(PKG_BUILD_DIR)/side-main.c -L$(PKG_BUILD_DIR) -ldemo-side -o $(PKG_BUILD_DIR)/demo-side
endef

define Package/demo-side/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/demo-side $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libdemo-side.so $(1)/usr/lib/
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/side.h $(1)/usr/include/demo-side.h
	$(CP) $(PKG_BUILD_DIR)/libdemo-side.so $(1)/usr/lib/
endef

$(eval $(call BuildPackage,demo-side))
