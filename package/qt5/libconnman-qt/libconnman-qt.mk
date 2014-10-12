################################################################################
#
# qwt
#
################################################################################

LIBCONNMAN_QT_VERSION = 1.0.83
LIBCONNMAN_QT_SOURCE = $(LIBCONNMAN_QT_VERSION).tar.gz
LIBCONNMAN_QT_SITE = https://github.com/nemomobile/libconnman-qt/archive/$(LIBCONNMAN_QT_VERSION)
LIBCONNMAN_QT_INSTALL_STAGING = YES
LIBCONNMAN_QT_DEPENDENCIES = connman

define LIBCONNMAN_QT_CONFIGURE_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/qmake)
endef

define LIBCONNMAN_QT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBCONNMAN_QT_INSTALL_STAGING_CMDS
	cp $(@D)/libconnman-qt/libconnman-qt5.so.1.0.0 $(STAGING_DIR)/usr/lib/libconnman-qt5.so.1.0.0
	ln -sf libconnman-qt5.so.1.0.0 $(STAGING_DIR)/usr/lib/libconnman-qt5.so.1.0
	ln -sf libconnman-qt5.so.1.0.0 $(STAGING_DIR)/usr/lib/libconnman-qt5.so.1
	ln -sf libconnman-qt5.so.1.0.0 $(STAGING_DIR)/usr/lib/libconnman-qt5.so
	mkdir -p $(STAGING_DIR)/usr/qml/MeeGo/Connman/
	cp $(@D)/plugin/libConnmanQtDeclarative.so $(STAGING_DIR)/usr/qml/MeeGo/Connman/
	echo -e "module MeeGo.Connman\nplugin ConnmanQtDeclarative" > $(STAGING_DIR)/usr/qml/MeeGo/Connman/qmldir
endef

define LIBCONNMAN_QT_INSTALL_TARGET_CMDS
	cp $(@D)/libconnman-qt/libconnman-qt5.so.1.0.0 $(TARGET_DIR)/usr/lib/libconnman-qt5.so.1.0.0
	ln -sf libconnman-qt5.so.1.0.0 $(TARGET_DIR)/usr/lib/libconnman-qt5.so.1.0
	ln -sf libconnman-qt5.so.1.0.0 $(TARGET_DIR)/usr/lib/libconnman-qt5.so.1
	ln -sf libconnman-qt5.so.1.0.0 $(TARGET_DIR)/usr/lib/libconnman-qt5.so
	mkdir -p $(TARGET_DIR)/usr/qml/MeeGo/Connman/
	cp $(@D)/plugin/libConnmanQtDeclarative.so $(TARGET_DIR)/usr/qml/MeeGo/Connman/
	echo -e "module MeeGo.Connman\nplugin ConnmanQtDeclarative" > $(TARGET_DIR)/usr/qml/MeeGo/Connman/qmldir
endef

$(eval $(generic-package))
