################################################################################
#
# Virtual package for libEGL
#
################################################################################

LIBEGL_SOURCE =

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
LIBEGL_DEPENDENCIES += rpi-userland
endif

ifeq ($(BR2_PACKAGE_MALI400),y)
LIBEGL_DEPENDENCIES += mali400
endif

ifeq ($(LIBEGL_DEPENDENCIES),)
define LIBEGL_CONFIGURE_CMDS
	echo "No libEGL implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
