################################################################################
#
# kodi-pvr-vdr-vnsi
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_VDR_VNSI_VERSION = 0b90a42df48b953562fab4958134219f96b244c3
KODI_PVR_VDR_VNSI_SITE = $(call github,kodi-pvr,pvr.vdr.vnsi,$(KODI_PVR_VDR_VNSI_VERSION))
KODI_PVR_VDR_VNSI_LICENSE = GPLv2+
KODI_PVR_VDR_VNSI_LICENSE_FILES = src/client.h
KODI_PVR_VDR_VNSI_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
