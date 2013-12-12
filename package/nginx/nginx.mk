################################################################################
#
# nginx
#
################################################################################

NGINX_VERSION = 1.4.3
NGINX_SOURCE = nginx-$(NGINX_VERSION).tar.gz
NGINX_SITE = http://nginx.org/download/
NGINX_INSTALL_STAGING = YES
NGINX_LICENSE = BSD
NGINX_LICENSE_FILES = COPYING
NGINX_INSTALL_STAGING = YES

PTRSIZE=4

NGINX_CONF_OPTS = --with-cc=$(TARGET_CC) \
	--with-cpp=$(TARGET_CPP) \
	--with-cc-opt="$(TARGET_CFLAGS)" \
	--with-ld-opt="$(TARGET_LDFLAGS)" \
	--prefix=/usr \
	--with-endian=little \
	--with-int=4 \
	--with-long=${PTRSIZE} \
	--with-long-long=8 \
	--with-ptr-size=${PTRSIZE} \
	--with-sig-atomic-t=${PTRSIZE} \
	--with-size-t=${PTRSIZE} \
	--with-off-t=${PTRSIZE} \
	--with-time-t=${PTRSIZE} \
	--with-sys-nerr=132 \
	--conf-path=/etc/nginx/nginx.conf \
	--http-log-path=/var/log/nginx_access.log \
	--error-log-path=/var/log/nginx_error.log \
	--pid-path=/var/run/nginx/nginx.pid \
	--crossbuild=$(GNU_TARGET_NAME)

define NGINX_CONFIGURE_CMDS
	(cd $(@D); \
		PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
		PKG_CONFIG_LIBDIR="$(STAGING_DIR)/usr/lib/pkgconfig" \
		PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)" \
		NGX_WITH_NGX_HAVE_ACCEPT4="0" \
		MAKEFLAGS="$(MAKEFLAGS) -j$(PARALLEL_JOBS)" \
		./configure \
		$(NGINX_CONF_OPTS) \
	)
endef

define NGINX_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define NGINX_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define NGINX_UNINSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) uninstall
endef

define NGINX_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define NGINX_UNINSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) uninstall
endef

$(eval $(generic-package))
