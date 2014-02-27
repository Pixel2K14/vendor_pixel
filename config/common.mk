PRODUCT_BRAND ?= pixel

SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.cyanogenmod.superuser

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/pixel/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_BOOTANIMATION := vendor/pixel/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/pixel/CHANGELOG.mkdn:system/etc/CHANGELOG-PIXEL.txt

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/pixel/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/pixel/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/pixel/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh \
    vendor/pixel/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# init.d support
PRODUCT_COPY_FILES += \
    vendor/pixel/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/pixel/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/pixel/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/pixel/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# CM-specific init file
PRODUCT_COPY_FILES += \
    vendor/pixel/prebuilt/common/etc/init.local.rc:root/init.cm.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/pixel/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/pixel/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is not CM but still!
PRODUCT_COPY_FILES += \
    vendor/pixel/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# Optimized Dalvik from Moto X
PRODUCT_COPY_FILE += \
    $(call find-copy-subdir-files,*,vendor/pixel/prebuilt/qcom,system)

# T-Mobile theme engine
include vendor/pixel/config/themes_common.mk

# Required CM packages
PRODUCT_PACKAGES += \
    Development \
    LatinIME \
    BluetoothExt
    
# PixelROM Stuff
PRODUCT_PACKAGES += \
    HALO \
    OmniSwitch \
    KitKatWhite

# Optional CM packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in CM
PRODUCT_PACKAGES += \
    libsepol \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace

PRODUCT_PACKAGES += \
    Launcher3 \
    DSPManager \
    libcyanogen-dsp \
    audio_effects.conf \
    Apollo \
    LockClock
    
# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)

PRODUCT_PACKAGES += \
    procmem \
    procrank \
    Superuser \
    su

#ROM Stats

PRODUCT_COPY_FILES +=  \
    vendor/pixel/proprietary/RomStats.apk:system/app/RomStats.apk \

# Terminal Emulator
PRODUCT_COPY_FILES +=  \
    vendor/pixel/proprietary/Term.apk:system/app/Term.apk \
    vendor/pixel/proprietary/lib/armeabi/libjackpal-androidterm4.so:system/lib/libjackpal-androidterm4.so

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=1
else

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

endif

# easy way to extend to add more packages
-include vendor/extra/product.mk

# CM Versioning
-include vendor/pixel/config/cm_version.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/pixel/overlay/dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/pixel/overlay/common

# Set PIXEL_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef PIXEL_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "PIXEL_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^PIXEL_||g')
        PIXEL_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

ifdef BUILDTYPE_NIGHTLY
        PIXEL_BUILDTYPE := NIGHTLY
endif
ifdef BUILDTYPE_AUTOTEST
        PIXEL_BUILDTYPE := AUTOTEST
endif
ifdef BUILDTYPE_EXPERIMENTAL
        PIXEL_BUILDTYPE := EXPERIMENTAL
endif
ifdef BUILDTYPE_RELEASE
        PIXEL_BUILDTYPE := RELEASE
endif

ifndef PIXEL_BUILDTYPE
        PIXEL_BUILDTYPE := UNOFFICIAL
endif

TARGET_PRODUCT_SHORT := $(TARGET_PRODUCT)
TARGET_PRODUCT_SHORT := $(subst pixel_,,$(TARGET_PRODUCT_SHORT))

# Build the final version string
ifdef BUILDTYPE_RELEASE
        PIXEL_VERSION := $(PLATFORM_VERSION)-$(TARGET_PRODUCT_SHORT)
else
ifeq ($(PIXEL_BUILDTIME_LOCAL),y)
        PIXEL_VERSION := PixelROM-$(PLATFORM_VERSION)-$(shell date -u +%Y%m%d)-$(PIXEL_BUILDTYPE)-$(PIXEL_BUILD)
else
        PIXEL_VERSION := PixelROM-$(PLATFORM_VERSION)-$(shell date -u +%Y%m%d)-$(PIXEL_BUILDTYPE)-$(PIXEL_BUILD)
endif
endif


PRODUCT_PROPERTY_OVERRIDES += \
  ro.pixel.version=$(PIXEL_VERSION) \
  ro.modversion=$(PIXEL_VERSION)

-include vendor/cm-priv/keys/keys.mk

PIXEL_DISPLAY_VERSION := $(PIXEL_VERSION)

ifneq ($(DEFAULT_SYSTEM_DEV_CERTIFICATE),)
ifneq ($(DEFAULT_SYSTEM_DEV_CERTIFICATE),build/target/product/security/testkey)
  ifneq ($(PIXEL_BUILDTYPE), UNOFFICIAL)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
      ifneq ($(PIXEL_EXTRAVERSION),)
        TARGET_VENDOR_RELEASE_BUILD_ID := $(PIXEL_EXTRAVERSION)
      else
        TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
      endif
    else
      TARGET_VENDOR_RELEASE_BUILD_ID := -$(TARGET_VENDOR_RELEASE_BUILD_ID)
    endif
    PIXEL_DISPLAY_VERSION=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
  endif
endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.pixel.display.version=$(PIXEL_DISPLAY_VERSION)

# ROMStats
PRODUCT_PROPERTY_OVERRIDES += \
  ro.romstats.url=http://stats.pixelrom.tk \
  ro.romstats.name=PixelROM \
  ro.romstats.version=-$(PIXEL_BUILDTYPE)-$(PLATFORM_VERSION) \
  ro.romstats.tframe=7

-include vendor/cyngn/product.mk
