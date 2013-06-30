################################################################################
#
# Virtual package for libGLES
#
################################################################################

LIBGLES_SOURCE =

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
LIBGLES_DEPENDENCIES += rpi-userland
endif

ifeq ($(BR2_PACKAGE_MALI400),y)
LIBGLES_DEPENDENCIES += mali400
endif

ifeq ($(LIBGLES_DEPENDENCIES),)
define LIBGLES_CONFIGURE_CMDS
	echo "No libGLES implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
