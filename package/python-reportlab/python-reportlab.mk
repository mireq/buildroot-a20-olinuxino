################################################################################
#
# python-bottle
#
################################################################################

PYTHON_REPORTLAB_VERSION = 2.7
PYTHON_REPORTLAB_SOURCE = reportlab-$(PYTHON_REPORTLAB_VERSION).tar.gz
PYTHON_REPORTLAB_SITE = https://pypi.python.org/packages/source/r/reportlab/
PYTHON_REPORTLAB_DEPENDENCIES = python zlib freetype jpeg tiff host-python-setuptools

define PYTHON_REPORTLAB_BUILD_CMDS
	(cd $(@D); \
		PYTHONXCPREFIX="$(STAGING_DIR)/usr/" \
		LDFLAGS="-L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/lib" \
	$(HOST_DIR)/usr/bin/python setup.py build -x)
endef

define PYTHON_REPORTLAB_INSTALL_TARGET_CMDS
	(cd $(@D); \
	PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
	$(HOST_DIR)/usr/bin/python setup.py install \
	--single-version-externally-managed --root=/ --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
