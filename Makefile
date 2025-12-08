# Build an arm64 iOS dynamic library with Logos hooks for Instagram's LiquidGlass gates.

ARCHS = arm64
TARGET := iphone:clang:latest:17.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LiquidGlassIGHook
LiquidGlassIGHook_FILES = src/IGLiquidGlassIGHook.xm
LiquidGlassIGHook_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/dylib.mk

LiquidGlassIGHook_LDFLAGS += -Wl,-install_name,@executable_path/LiquidGlassIGHook.dylib

after-build::
@echo Signing dylib...
@ldid -S $(THEOS_OBJDIR)/LiquidGlassIGHook.dylib
