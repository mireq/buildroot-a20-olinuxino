################################################################################
#
# mali400
#
################################################################################

MALI400_VERSION = c2491fe952354ba44538064e534ed7c731cedb1e
MALI400_SOURCE = mali_$(MALI400_VERSION).tar.gz
MALI400_SITE = http://github.com/linux-sunxi/sunxi-mali/tarball/$(MALI400_VERSION)
MALI400_PROPRIETARY_VERSION = e4ced471d576708ac9aa093e41a0f91cf429862b
MALI400_PROPRIETARY_SOURCE = mali_$(MALI400_VERSION).tar.gz

MALI400_INSTALL_STAGING = YES

define MALI400_BUILD_CMDS
	wget http://github.com/linux-sunxi/sunxi-mali-proprietary/tarball/$(MALI400_PROPRIETARY_VERSION)/mali.tar.gz -O $(@D)/mali.tar.gz
	tar -xvzf $(@D)/mali.tar.gz -C $(@D)
	rm -rf $(@D)/lib/mali
	mv $(@D)/linux-sunxi-sunxi-mali-proprietary-e4ced47 $(@D)/lib/mali
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) config VERSION=r3p0 ABI=armhf EGL_TYPE=framebuffer
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)
endef

define MALI400_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) DESTDIR=$(STAGING_DIR) -C $(@D) install
endef

define MALI400_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libEGL.so* $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/lib/libGLESv1_CM.so* $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/lib/libGLESv2.so* $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/lib/libMali.so $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/lib/libUMP.so* $(TARGET_DIR)/usr/lib
endef

$(eval $(generic-package))
