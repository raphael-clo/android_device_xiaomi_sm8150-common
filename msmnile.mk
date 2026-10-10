#
# Copyright (C) 2021-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Shipping API
PRODUCT_SHIPPING_API_LEVEL := 30

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnel_migration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnel_migration.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

ifeq ($(PRODUCT_VIRTUAL_AB_OTA),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml
endif

# A/B
ifeq ($(TARGET_IS_VAB),true)
# Inherit virtual_ab_ota product
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

$(call soong_config_set,QTI_GPT_UTILS,USE_BSG_FRAMEWORK,false)

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script
endif

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    audio.bluetooth.default

# Audio configs
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

# Bluetooth
TARGET_USE_QTI_BT_STACK := true


# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service_64

# Configstore
PRODUCT_PACKAGES += \
    disable_configstore

# Device-specific settings
PRODUCT_PACKAGES += \
    XiaomiParts

# Display
#
# Uses the sm8150 display HAL, which matches this SoC and this kernel: its FOD
# path is gated on FOD_ZPOS (enabled via the qtidisplay.udfps Soong config
# below) and the sm8150 kernel is the one that implements PLANE_PROP_FOD,
# sde_crtc_fod_atomic_check and the fod_ui sysfs. The sm8350 tree previously
# used here provides vendor.qti.hardware.display.composer@3.0 and is disabled;
# the sm8350 kernel has no FOD support at all.
#
# sm8150 ships hwcomposer.qcom (an HWC2 module) rather than a standalone
# composer service, so the AOSP graphics.composer@2.4 service loads it. The
# HAL is declared by the tree's own VINTF fragment
# (android.hardware.graphics.composer-qti-display.xml) -- do not also declare
# it in manifest.xml or check_vintf fails with a duplicate FqInstance.
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer-qti-display.xml \
    gralloc.qcom \
    vendor.qti.hardware.memtrack-service

# Snapdragon color configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/snapdragon_color_libs_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/snapdragon_color_libs_config.xml

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

# fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Fingerprint
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.xiaomi

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

ifeq ($(TARGET_HAS_UDFPS),true)
PRODUCT_PACKAGES += \
    libudfpshandler

$(call soong_config_set,surfaceflinger,udfps_lib,libudfps_extension.xiaomi)

# Enable FOD_ZPOS cflag in the qcom-caf/sm8150 display HAL (HWComposer +
# DRM device layer). With this, SurfaceFlinger's UDFPS overlay layer gets
# tagged via FOD_PRESSED_LAYER_ZORDER on touch, HWComposer relays the bit
# to the DRM atomic plane z_order, sde_plane sets PLANE_PROP_FOD=1, and
# sde_crtc_fod_atomic_check / sde_connector_update_fod_hbm then handle
# the dim layer + HBM-FOD DSI command automatically per-frame. Without
# this Soong var, the whole pipeline is compiled out and HBM-FOD must be
# driven manually (which causes whole-screen brightening since the dim
# layer is never created).
$(call soong_config_set,qtidisplay,udfps,true)
endif
endif

# FM
ifeq ($(TARGET_HAS_FM),true)
PRODUCT_PACKAGES += \
    FM2 \
    libqcomfm_jni \
    qcom.fmradio
endif


# HotwordEnrollement app permissions
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/permissions/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml

# IFAAService
PRODUCT_PACKAGES += \
    IFAAService

# Init
$(call soong_config_set,libinit,vendor_init_lib,//$(LOCAL_PATH):init_xiaomi_msmnile)

# Input
PRODUCT_PACKAGES += \
    sm8150-tavil-snd-card_Button_Jack.kl \
    uinput-fortsense.kl \
    uinput-fpc.kl \
    uinput-goodix.kl

PRODUCT_PACKAGES += \
    uinput-fortsense.idc \
    uinput-fpc.idc \
    uinput-goodix.idc


# Kernel
PRODUCT_ENABLE_UFFD_GC := true
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.lineage

# Media configs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/media/media_codecs_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2.xml \
    $(LOCAL_PATH)/media/media_codecs_performance_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance_c2.xml

# Codec2 AVC/HEVC encoders built on the QTI V4L2 engine
# (hardware/qcom-caf/sm8150/media/c2-venc). The prebuilt QTI Codec2 encoders
# fail off the camera path: AVC cannot take composited RGBA surfaces (screen
# recording) and HEVC fails before its first frame. media_codecs_c2.xml lists
# these ahead of the QTI entries.
PRODUCT_PACKAGES += \
    sm8150-c2-venc-service

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.nxp \
    com.android.nfc_extras \
    Tag

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_nfc/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_nfc/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_nfc/android.hardware.nfc.uicc.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_nfc/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_nfc/android.hardware.se.omapi.uicc.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_nfc/com.android.nfc_extras.xml

# Overlays
PRODUCT_PACKAGES += \
    CarrierConfigOverlayCommon \
    FrameworkResOverlayCommon \
    LineageDialerOverlayCommon \
    LineageSDKOverlayCommon \
    LineageSettingsOverlayCommon \
    SettingsOverlayCommon \
    SettingsProviderOverlayCommon \
    SystemUIOverlayCommon \
    TelephonyOverlayCommon \
    WifiResourcesOverlayCommon

PRODUCT_ENFORCE_RRO_TARGETS := *

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

PRODUCT_PACKAGES += \
    vendor_bt_firmware_mountpoint \
    vendor_dsp_mountpoint \
    vendor_firmware_mnt_mountpoint

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/alarm \
    hardware/qcom/display \
    hardware/qcom/media \
    hardware/qcom/wlan/qcwcn/wpa_supplicant_8_lib


# Platform
TARGET_BOARD_PLATFORM := msmnile

# Public libraries
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# QTI fwk-detect
PRODUCT_PACKAGES += \
    libqti_vndfwk_detect.vendor


# QTI fwk-detect
PRODUCT_PACKAGES += \
    libvndfwk_detect_jni.qti.vendor # Needed by CNE app

# Rootdir
PRODUCT_PACKAGES += \
    fstab.qcom \
    fstab.qcom.ramdisk \
    fstab.qcom.vendor_ramdisk

PRODUCT_PACKAGES += \
    init.mi.btmac.sh \
    init.qti.dcvs.sh

PRODUCT_PACKAGES += \
    init.qcom.power.rc \
    init.target.rc \
    init.xiaomi.rc


# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl-xiaomi \
    android.hardware.sensors@1.0-service

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/xiaomi

# Telephony
PRODUCT_PACKAGES += \
    xiaomi-telephony-stub

PRODUCT_BOOT_JARS += \
    xiaomi-telephony-stub

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.qti


# Vendor service manager
PRODUCT_PACKAGES += \
    vndservicemanager


# Wi-Fi
PRODUCT_PACKAGES += \
    libwifi-hal-ctrl \
    libwifi-hal-qcom \
    NcmTetheringOverlay \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_PACKAGES += \
    firmware_WCNSS_qcom_cfg.ini_symlink \
    firmware_wlan_mac.bin_symlink

# QTI
TARGET_COMMON_QTI_COMPONENTS := \
    adreno \
    alarm \
    audio \
    av \
    bt \
    charging \
    display \
    gps \
    init \
    media \
    perf \
    telephony \
    usb \
    vibrator \
    wfd \
    wlan

TARGET_FWK_SUPPORTS_FULL_VALUEADDS := true
TARGET_USE_HIDL_QTI_HEALTH := false

# Inherit the proprietary files
$(call inherit-product, vendor/xiaomi/sm8150-common/sm8150-common-vendor.mk)
