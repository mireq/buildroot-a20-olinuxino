#############################################################
#
# U-Boot
#
#############################################################
UBOOT_SUNXI_VERSION = $(call qstrip, $(BR2_TARGET_UBOOT_SUNXI_GITHUB_TAG))
UBOOT_SUNXI_BOARD_NAME = $(call qstrip,$(BR2_TARGET_UBOOT_SUNXI_BOARDNAME))

UBOOT_SUNXI_LICENSE = GPLv2+
UBOOT_SUNXI_LICENSE_FILES = COPYING

UBOOT_SUNXI_INSTALL_IMAGES = YES

UBOOT_SUNXI_SITE    = $(call qstrip,$(BR2_TARGET_UBOOT_SUNXI_GITHUB_LOCATION))
UBOOT_SUNXI_SOURCE = $(UBOOT_SUNXI_VERSION).tar.gz

ifeq ($(BR2_TARGET_UBOOT_SUNXI_FORMAT_KWB),y)
UBOOT_SUNXI_BIN          = u-boot.kwb
UBOOT_SUNXI_MAKE_TARGET  = $(UBOOT_SUNXI_BIN)
else ifeq ($(BR2_TARGET_UBOOT_SUNXI_FORMAT_AIS),y)
UBOOT_SUNXI_BIN          = u-boot.ais
UBOOT_SUNXI_MAKE_TARGET  = $(UBOOT_SUNXI_BIN)
else ifeq ($(BR2_TARGET_UBOOT_SUNXI_FORMAT_LDR),y)
UBOOT_SUNXI_BIN          = u-boot.ldr
else ifeq ($(BR2_TARGET_UBOOT_SUNXI_FORMAT_NAND_BIN),y)
UBOOT_SUNXI_BIN          = u-boot-nand.bin
else ifeq ($(BR2_TARGET_UBOOT_SUNXI_FORMAT_IMG),y)
UBOOT_SUNXI_BIN          = u-boot.img
else
UBOOT_SUNXI_BIN          = u-boot.bin
UBOOT_SUNXI_BIN_IFT      = $(UBOOT_SUNXI_BIN).ift
endif

UBOOT_SUNXI_ARCH=$(KERNEL_ARCH)

UBOOT_SUNXI_CONFIGURE_OPTS += CONFIG_NOSOFTFLOAT=1
UBOOT_SUNXI_MAKE_OPTS += \
    CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)" \
    ARCH=$(UBOOT_SUNXI_ARCH)

# Helper function to fill the U-Boot config.h file.
# Argument 1: option name
# Argument 2: option value
# If the option value is empty, this function does nothing.
define insert_define
$(if $(call qstrip,$(2)),
    @echo "#ifdef $(strip $(1))" >> $(@D)/include/config.h
    @echo "#undef $(strip $(1))" >> $(@D)/include/config.h
    @echo "#endif" >> $(@D)/include/config.h
    @echo '#define $(strip $(1)) $(call qstrip,$(2))' >> $(@D)/include/config.h)
endef

ifneq ($(call qstrip,$(BR2_TARGET_UBOOT_SUNXI_CUSTOM_PATCH_DIR)),)
define UBOOT_SUNXI_APPLY_CUSTOM_PATCHES
    support/scripts/apply-patches.sh $(@D) $(BR2_TARGET_UBOOT_SUNXI_CUSTOM_PATCH_DIR) \
        uboot-$(UBOOT_SUNXI_VERSION)-\*.patch
endef

UBOOT_SUNXI_POST_PATCH_HOOKS += UBOOT_SUNXI_APPLY_CUSTOM_PATCHES
endif

define UBOOT_SUNXI_CONFIGURE_CMDS
    $(TARGET_CONFIGURE_OPTS) $(UBOOT_SUNXI_CONFIGURE_OPTS)  \
        $(MAKE) -C $(@D) $(UBOOT_SUNXI_MAKE_OPTS)       \
        $(UBOOT_SUNXI_BOARD_NAME)
    @echo >> $(@D)/include/config.h
    @echo "/* Add a wrapper around the values Buildroot sets. */" >> $(@D)/include/config.h
    @echo "#ifndef __BR2_ADDED_CONFIG_H" >> $(@D)/include/config.h
    @echo "#define __BR2_ADDED_CONFIG_H" >> $(@D)/include/config.h
    $(call insert_define,DATE,$(DATE))
    $(call insert_define,CONFIG_LOAD_SCRIPTS,1)
    $(call insert_define,CONFIG_IPADDR,$(BR2_TARGET_UBOOT_SUNXI_IPADDR))
    $(call insert_define,CONFIG_GATEWAYIP,$(BR2_TARGET_UBOOT_SUNXI_GATEWAY))
    $(call insert_define,CONFIG_NETMASK,$(BR2_TARGET_UBOOT_SUNXI_NETMASK))
    $(call insert_define,CONFIG_SERVERIP,$(BR2_TARGET_UBOOT_SUNXI_SERVERIP))
    $(call insert_define,CONFIG_ETHADDR,$(BR2_TARGET_UBOOT_SUNXI_ETHADDR))
    $(call insert_define,CONFIG_ETH1ADDR,$(BR2_TARGET_UBOOT_SUNXI_ETH1ADDR))
    @echo "#endif /* __BR2_ADDED_CONFIG_H */" >> $(@D)/include/config.h
endef

define UBOOT_SUNXI_BUILD_CMDS
    $(TARGET_CONFIGURE_OPTS) $(UBOOT_SUNXI_CONFIGURE_OPTS)  \
        $(MAKE) -C $(@D) $(UBOOT_SUNXI_MAKE_OPTS)       \
        $(UBOOT_SUNXI_MAKE_TARGET)
endef

define UBOOT_SUNXI_INSTALL_IMAGES_CMDS
    cp -dpf $(@D)/$(UBOOT_SUNXI_BIN) $(BINARIES_DIR)/
    $(if $(BR2_TARGET_UBOOT_SUNXI_SPL),
        cp -dpf $(@D)/spl/$(BR2_TARGET_UBOOT_SUNXI_SPL_NAME) $(BINARIES_DIR)/)
endef

$(eval $(generic-package))

ifeq ($(BR2_TARGET_UBOOT_SUNXI),y)
# we NEED a board name unless we're at make source
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(UBOOT_SUNXI_BOARD_NAME),)
$(error NO U-Boot board name set. Check your BR2_TARGET_UBOOT_SUNXI_BOARDNAME setting)
endif
endif
endif
