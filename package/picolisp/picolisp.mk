#############################################################
#
# picolisp
#
#############################################################

PICOLISP_VERSION = 3.1.1
PICOLISP_SITE = http://software-lab.de/
PICOLISP_SOURCE = picoLisp-$(PICOLISP_VERSION).tgz
PICOLISP_DEPENDENCIES = ncurses

define PICOLISP_BUILD_CMDS
    $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/src \
        CC="$(TARGET_CC)" \
		STRIP="$(TARGET_CROSS)strip"
endef

define PICOLISP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/bin/picolisp $(TARGET_DIR)/usr/bin/picolisp
	$(INSTALL) -m 0755 -D $(@D)/bin/pil $(TARGET_DIR)/usr/bin/pil
	$(INSTALL) -m 0755 -D $(@D)/bin/plmod $(TARGET_DIR)/usr/bin/plmod
	$(INSTALL) -m 0755 -D $(@D)/bin/psh $(TARGET_DIR)/usr/bin/psh
	$(INSTALL) -m 0755 -D $(@D)/bin/watchdog $(TARGET_DIR)/usr/bin/watchdog

	$(INSTALL) -m 0755 -d $(TARGET_DIR)/usr/lib/picolisp
	cp -a $(@D)/lib/* $(TARGET_DIR)/usr/lib/picolisp

	$(INSTALL) -m 0755 -D $(@D)/lib.l $(TARGET_DIR)/usr/lib/picolisp/lib.l
endef

define PICOLISP_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/{picolisp, pil, plmod, psh, watchdog}
	rm -rf $(TARGET_DIR)/usr/bin/picolisp
endef

$(eval $(generic-package))
