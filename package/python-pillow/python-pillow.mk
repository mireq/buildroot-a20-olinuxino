################################################################################
#
# python-bottle
#
################################################################################

PYTHON_PILLOW_VERSION = 2.1.0
PYTHON_PILLOW_SOURCE = Pillow-$(PYTHON_PILLOW_VERSION).zip
PYTHON_PILLOW_SITE = https://pypi.python.org/packages/source/P/Pillow/
PYTHON_PILLOW_DEPENDENCIES = python zlib freetype jpeg tiff host-python-setuptools host-python-distutilscross

define PYTHON_PILLOW_EXTRACT_CMDS
	(unzip $(DL_DIR)/$(PYTHON_PILLOW_SOURCE) -d $(BUILD_DIR); \
	mv $(BUILD_DIR)/Pillow-$(PYTHON_PILLOW_VERSION)/* $(@D))
endef

define PYTHON_PILLOW_BUILD_CMDS
	(cd $(@D); \
		PYTHONXCPREFIX="$(STAGING_DIR)/usr/" \
		LDFLAGS="-L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/lib" \
	$(HOST_DIR)/usr/bin/python setup.py build -x build_ext --disable-lcms --disable-webp)
endef

define PYTHON_PILLOW_INSTALL_TARGET_CMDS
	(cd $(@D); \
	PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
	$(HOST_DIR)/usr/bin/python setup.py install \
	--single-version-externally-managed --root=/ --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
