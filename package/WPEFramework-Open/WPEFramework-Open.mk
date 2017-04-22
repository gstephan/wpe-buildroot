WPEFRAMEWORK_OPEN_VERSION = be8c247499932eb1ce8e77740c4af6189407b669
WPEFRAMEWORK_OPEN_SITE_METHOD = git
WPEFRAMEWORK_OPEN_SITE = git@github.com:Metrological/webbridge.git
WPEFRAMEWORK_OPEN_INSTALL_STAGING = YES
WPEFRAMEWORK_OPEN_DEPENDENCIES = WPEFramework

WPEFRAMEWORK_OPEN_CONF_OPTS += -DBUILDREF_WPEFRAMEWORK=${WPEFRAMEWORK_OPEN_VERSION}

ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
WPEFRAMEWORK_OPEN_DEPENDENCIES = bcm-refsw
endif 

# libprovision

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_COMMANDER),y)
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMMANDER=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_DEVICEINFO),y)
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_DEVICEINFO=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_LOCATIONSYNC),y)
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_LOCATIONSYNC=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_MONITOR),y)
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_MONITOR=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_REMOTECONTROL),y)
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_REMOTECONTROL=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_SNAPSHOT),y)
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_SNAPSHOT=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_TIMESYNC),y)
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_TIMESYNC=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_TRACECONTROL),y)
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_TRACECONTROL=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_WEBKITBROWSER),y)
WPEFRAMEWORK_OPEN_DEPENDENCIES += wpewebkit 
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_WEBPROXY),y)
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBPROXY=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_WEBSERVER),y)
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBSERVER=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_OPEN_WEBSHELL),y)
WPEFRAMEWORK_OPEN_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBSHELL=ON
endif

$(eval $(cmake-package))

