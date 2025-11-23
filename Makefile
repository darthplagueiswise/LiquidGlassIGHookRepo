# Theos-based build for LiquidGlassIGHook
# Targets an arm64 iOS dynamic library implementing Instagram LiquidGlass hooks.

ARCHS = arm64
TARGET := iphone:clang:latest:17.0
INSTALL_TARGET_PROCESSES = Instagram

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LiquidGlassIGHook
LiquidGlassIGHook_FILES = src/IGLiquidGlassIGHook.xm
LiquidGlassIGHook_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
