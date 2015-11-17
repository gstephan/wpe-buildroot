################################################################################
#
# netflix
#
################################################################################

NETFLIX_VERSION = 9600887bb2b2ed82370bfee3aed8eb6b70feb3d0
NETFLIX_SITE = git@github.com:Metrological/netflix.git
NETFLIX_SITE_METHOD = git
NETFLIX_LICENSE = PROPRIETARY
NETFLIX_DEPENDENCIES = freetype icu jpeg libpng libmng webp harfbuzz expat openssl c-ares libcurl graphite2
NETFLIX_INSTALL_TARGET = YES
NETFLIX_SUBDIR = netflix
NETFLIX_RESOURCE_LOC = $(call qstrip,${BR2_PACKAGE_NETFLIX_RESOURCE_LOCATION})

NETFLIX_CONF_OPTS = \
	-DBUILD_DPI_DIRECTORY=$(@D)/partner/dpi \
	-DCMAKE_INSTALL_PREFIX=/netflix \
	-DBUILD_COMPILE_RESOURCES=1 \
	-DNRDP_HAS_IPV6=0 \
	-DBUILD_SHARED_LIBS=0 \
	-DGIBBON_MODE=executable \
	-DGIBBON_SCRIPT_JSC_DYNAMIC=1 \
	-DGIBBON_SCRIPT_JSC_DEBUG=0 \
	-DGIBBON_INPUT=devinput \
	-DNRDP_TOOLS="manufSSgenerator"

NETFLIX_CONF_ENV += \
	TARGET_CROSS="$(GNU_TARGET_NAME)-"

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
NETFLIX_CONF_OPTS += \
	-DGIBBON_GRAPHICS=rpi-egl \
	-DGIBBON_PLATFORM=rpi
NRD_DEPENDENCIES += rpi-userland
else ifeq ($(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_HAS_LIBGLES),yy)
NETFLIX_CONF_OPTS += \
	-DGIBBON_GRAPHICS=gles2-egl \
	-DGIBBON_PLATFORM=posix
NRD_DEPENDENCIES += libgles libegl
else ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
NETFLIX_CONF_OPTS += \
	-DGIBBON_GRAPHICS=gles2 \
	-DGIBBON_PLATFORM=posix
NRD_DEPENDENCIES += libgles
else
NETFLIX_CONF_OPTS += \
	-DGIBBON_GRAPHICS=null \
	-DGIBBON_PLATFORM=posix
endif

ifeq ($(BR2_PACKAGE_GSTREAMER1),y)
NETFLIX_CONF_OPTS += -DDPI_IMPLEMENTATION=gstreamer
NETFLIX_DEPENDENCIES += gstreamer1
else ifeq ($(BR2_PACKAGE_HAS_LIBOPENMAX),y)
NETFLIX_CONF_OPTS += \
	-DDPI_IMPLEMENTATION=reference \
	-DDPI_REFERENCE_VIDEO_DECODER=openmax-il \
	-DDPI_REFERENCE_VIDEO_RENDERER=openmax-il \
	-DDPI_REFERENCE_AUDIO_DECODER=ffmpeg \
	-DDPI_REFERENCE_AUDIO_RENDERER=openmax-il \
	-DDPI_REFERENCE_AUDIO_MIXER=none
NETFLIX_DEPENDENCIES += ffmpeg openmax
else
NETFLIX_CONF_OPTS += -DDPI_IMPLEMENTATION=reference
endif

ifeq ($(BR2_PACKAGE_PLAYREADY),y)
NETFLIX_CONF_OPTS += -DDPI_REFERENCE_DRM=playready
NETFLIX_DEPENDENCIES += playready
else ifeq ($(BR2_PACKAGE_DXDRM_EXTERNAL),y)
NETFLIX_CONF_OPTS += -DDPI_REFERENCE_DRM=playready-dxdrm
NRD_DEPENDENCIES += dxdrm
else
NETFLIX_CONF_OPTS += -DDPI_REFERENCE_DRM=none
endif

NETFLIX_CONF_OPTS += \
	-DBUILD_QA=0 \
	-DNRDP_HAS_TRACING=0 \
	-DNRDP_HAS_TEST_INSTRUMENTATION=0 \
	-DNRDP_HAS_ON_INSTRUMENTATION=0 \
	-DNRDP_HAS_DEBUG_INSTRUMENTATION=0 \
	-DNRDP_HAS_SWITCHED_INSTRUMENTATION=0 \
	-DNRDP_HAS_INSTRUMENTATION=0

ifeq ($(BR2_ENABLE_DEBUG),y)
NETFLIX_CONF_OPTS += \
	-DCMAKE_BUILD_TYPE=Debug \
	-DCMAKE_C_FLAGS_DEBUG="$(TARGET_CFLAGS)" \
	-DCMAKE_CXX_FLAGS_DEBUG="$(TARGET_CXXFLAGS)"
else
NETFLIX_CONF_OPTS += \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_FLAGS_RELEASE="$(TARGET_CFLAGS)" \
	-DCMAKE_CXX_FLAGS_RELEASE="$(TARGET_CXXFLAGS)"
endif

define NETFLIX_FIX_CONFIG_XMLS
	mkdir -p $(@D)/netflix/src/platform/gibbon/data/etc/conf
	cp -f $(@D)/netflix/resources/configuration/common.xml $(@D)/netflix/src/platform/gibbon/data/etc/conf/common.xml
	cp -f $(@D)/netflix/resources/configuration/config.xml $(@D)/netflix/src/platform/gibbon/data/etc/conf/config.xml
endef

NETFLIX_POST_EXTRACT_HOOKS += NETFLIX_FIX_CONFIG_XMLS

define NETFLIX_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/netflix/src/platform/gibbon/libJavaScriptCore.so $(TARGET_DIR)/usr/lib
	$(INSTALL) -m 755 $(@D)/netflix/src/platform/gibbon/netflix $(TARGET_DIR)/usr/bin
	mkdir -p $(TARGET_DIR)/usr/share/fonts/netflix
	$(INSTALL) -m 644 $(@D)/netflix/src/platform/gibbon/data/fonts/* $(TARGET_DIR)/usr/share/fonts/netflix/
	$(INSTALL) -m 644 $(@D)/netflix/src/platform/gibbon/resources/gibbon/fonts/LastResort.ttf $(TARGET_DIR)/usr/share/fonts/netflix/
endef

$(eval $(cmake-package))