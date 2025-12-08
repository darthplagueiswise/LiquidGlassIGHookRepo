# Targets an arm64 iOS dynamic library implementing Instagram LiquidGlass hooks
# with fishhook-based rebinding and a lightweight toggle overlay.

ARCHS = arm64
TARGET := iphone:clang:latest:17.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LiquidGlassIGHook
LiquidGlassIGHook_FILES = \
    src/FBFeatureToggleManager.m \
    src/FBFeatureOverlayUI.m \
    src/FBFeatureHooks.m \
    src/fishhook.c
LiquidGlassIGHook_CFLAGS = -fobjc-arc
LiquidGlassIGHook_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/dylib.mk

LiquidGlassIGHook_LDFLAGS += -Wl,-install_name,@executable_path/LiquidGlassIGHook.dylib

after-build::
	@echo Signing dylib...
	@ldid -S $(THEOS_OBJDIR)/LiquidGlassIGHook.dylib
