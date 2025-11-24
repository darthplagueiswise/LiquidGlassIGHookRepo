# Targets an arm64 iOS dynamic library implementing Instagram LiquidGlass hooks.

ARCHS = arm64
TARGET := iphone:clang:latest:17.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LiquidGlassIGHook
LiquidGlassIGHook_FILES = src/IGLiquidGlassIGHook.xm
LiquidGlassIGHook_CFLAGS = -fobjc-arc

LiquidGlassIGHook_LIBRARIES =

include $(THEOS_MAKE_PATH)/dylib.mk

LiquidGlassIGHook_LDFLAGS += -Wl,-install_name,@executable_path/LiquidGlassIGHook.dylib

after-build::
	@echo Signing dylib...
	@ldid -S $(THEOS_OBJDIR)/LiquidGlassIGHook.dylib
