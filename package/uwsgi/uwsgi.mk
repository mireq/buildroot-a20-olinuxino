################################################################################
#
# nginx
#
################################################################################

UWSGI_VERSION = 1.4.10
UWSGI_SOURCE = uwsgi-$(UWSGI_VERSION).tar.gz
UWSGI_SITE = http://projects.unbit.it/downloads/
UWSGI_INSTALL_STAGING = YES
UWSGI_LICENSE = GPL
UWSGI_LICENSE_FILES = COPYING
UWSGI_INSTALL_STAGING = YES

define UWSGI_CONFIGURE_CMDS
	echo "[uwsgi]" > $(@D)/buildconf/buildroot.ini
	echo "xml = false" >> $(@D)/buildconf/buildroot.ini
	echo "ini = true" >> $(@D)/buildconf/buildroot.ini
	echo "yaml = false" >> $(@D)/buildconf/buildroot.ini
	echo "json = false" >> $(@D)/buildconf/buildroot.ini
	echo "sqlite3 = false" >> $(@D)/buildconf/buildroot.ini
	echo "zeromq = false" >> $(@D)/buildconf/buildroot.ini
	echo "snmp = true" >> $(@D)/buildconf/buildroot.ini
	echo "sctp = false" >> $(@D)/buildconf/buildroot.ini
	echo "spooler = true" >> $(@D)/buildconf/buildroot.ini
	echo "embedded = true" >> $(@D)/buildconf/buildroot.ini
	echo "ssl = auto" >> $(@D)/buildconf/buildroot.ini
	echo "udp = true" >> $(@D)/buildconf/buildroot.ini
	echo "multicast = true" >> $(@D)/buildconf/buildroot.ini
	echo "threading = true" >> $(@D)/buildconf/buildroot.ini
	echo "sendfile = true" >> $(@D)/buildconf/buildroot.ini
	echo "minterpreters = true" >> $(@D)/buildconf/buildroot.ini
	echo "async = true" >> $(@D)/buildconf/buildroot.ini
	echo "evdis = false" >> $(@D)/buildconf/buildroot.ini
	echo "ldap = false" >> $(@D)/buildconf/buildroot.ini
	echo "pcre = false" >> $(@D)/buildconf/buildroot.ini
	echo "routing = auto" >> $(@D)/buildconf/buildroot.ini
	echo "alarm = auto" >> $(@D)/buildconf/buildroot.ini
	echo "debug = false" >> $(@D)/buildconf/buildroot.ini
	echo "unbit = false" >> $(@D)/buildconf/buildroot.ini
	echo "plugins = " >> $(@D)/buildconf/buildroot.ini
	echo "bin_name = uwsgi" >> $(@D)/buildconf/buildroot.ini
	echo "append_version =" >> $(@D)/buildconf/buildroot.ini
	echo "plugin_dir = /usr/$lib/uwsgi" >> $(@D)/buildconf/buildroot.ini
	echo "plugin_build_dir = ${T}/plugins" >> $(@D)/buildconf/buildroot.ini
	echo "embedded_plugins =  ping, cache, rpc, corerouter, fastrouter, http, ugreen, signal, logsocket, router_uwsgi, router_redirect, router_basicauth, zergpool, redislog, mongodblog, router_rewrite, router_http, logfile, router_cache, rawrouter, python" >> $(@D)/buildconf/buildroot.ini
	echo "as_shared_library = false" >> $(@D)/buildconf/buildroot.ini
	echo "locking = auto" >> $(@D)/buildconf/buildroot.ini
	echo "event = auto" >> $(@D)/buildconf/buildroot.ini
	echo "timer = auto" >> $(@D)/buildconf/buildroot.ini
	echo "filemonitor = auto" >> $(@D)/buildconf/buildroot.ini
	echo "embed_files =" >> $(@D)/buildconf/buildroot.ini
	echo "embed_config =" >> $(@D)/buildconf/buildroot.ini
	echo "[python]" >> $(@D)/buildconf/buildroot.ini
	echo "paste = true" >> $(@D)/buildconf/buildroot.ini
	echo "web3 = true" >> $(@D)/buildconf/buildroot.ini
endef

define UWSGI_BUILD_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) \
	CC=$(TARGET_CC) \
	CPP=$(TARGET_CPP) \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	STAGING_DIR=$(STAGING_DIR) \
	$(HOST_DIR)/usr/bin/python uwsgiconfig.py --build buildroot
endef

define UWSGI_INSTALL_STAGING_CMDS
	cp $(@D)/uwsgi $(STAGING_DIR)/usr/bin/uwsgi
	cp $(@D)/uwsgidecorators.py $(STAGING_DIR)/usr/lib/python2.7/site-packages/uwsgidecorators.py
endef

define UWSGI_UNINSTALL_STAGING_CMDS
	rm -f $(STAGING_DIR)/usr/bin/uwsgi
	rm -f $(STAGING_DIR)/usr/lib/python2.7/site-packages/uwsgidecorators.py
endef

define UWSGI_INSTALL_TARGET_CMDS
	cp $(STAGING_DIR)/usr/bin/uwsgi $(TARGET_DIR)/usr/bin/uwsgi
	cp $(STAGING_DIR)/usr/lib/python2.7/site-packages/uwsgidecorators.py $(TARGET_DIR)/usr/lib/python2.7/site-packages/uwsgidecorators.py
endef

define UWSGI_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/uwsgi
	rm -f $(TARGET_DIR)/usr/lib/python2.7/site-packages/uwsgidecorators.py
endef

$(eval $(generic-package))
