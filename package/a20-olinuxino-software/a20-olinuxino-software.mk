#############################################################
#
# a20-olinuxino-software
#
#############################################################

A20_OLINUXINO_SOFTWARE_VERSION = 5f18634
A20_OLINUXINO_SOFTWARE_SITE = https://github.com/OLIMEX/OLINUXINO/tarball/master

A20_OLINUXINO_SOFTWARE__MOD_RTC__DIR = $(@D)/SOFTWARE/A20/A20-OLinuXino-Micro\ with\ MOD-RTC
A20_OLINUXINO_SOFTWARE__MOD_RTC__EXE = "mod-rtc"

#
# BUILD
#

define A20_OLINUXINO_SOFTWARE_BUILD_CMDS

# mod-rtc
$(if ($(BR2_PACKAGE_A20_OLINUXINO_SOFTWARE_MOD_RTC),y),
    $(TARGET_CONFIGURE_OPTS) $(MAKE) -C ${A20_OLINUXINO_SOFTWARE__MOD_RTC__DIR} \
         CC="$(TARGET_CC)" \
         CFLAGS+="$(TARGET_CFLAGS)" \
         EXECUTE=${A20_OLINUXINO_SOFTWARE__MOD_RTC__EXE})
endef

#
# INSTALL
#

define A20_OLINUXINO_SOFTWARE_INSTALL_TARGET_CMDS

# mod-rtc
$(if ($(BR2_PACKAGE_A20_OLINUXINO_SOFTWARE_MOD_RTC),y),
    $(INSTALL) -m 0755 -D ${A20_OLINUXINO_SOFTWARE__MOD_RTC__DIR}/${A20_OLINUXINO_SOFTWARE__MOD_RTC__EXE} $(TARGET_DIR)/usr/bin/)

endef


#
# UNINSTALL
#

define A20_OLINUXINO_SOFTWARE_UNINSTALL_TARGET_CMDS

# mod-rtc
$(if ($(BR2_PACKAGE_A20_OLINUXINO_SOFTWARE_MOD_RTC),y),
    rm -f $(TARGET_DIR)/usr/bin/${A20_OLINUXINO_SOFTWARE__MOD_RTC__EXE})

endef

$(eval $(generic-package))
