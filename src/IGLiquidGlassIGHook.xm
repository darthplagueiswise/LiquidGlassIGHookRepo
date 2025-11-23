// IGLiquidGlassIGHook.xm
//
// Theos / Logos implementation that forces Instagram's LiquidGlass-related
// feature gates on at runtime by hooking C-level functions.

#import <Foundation/Foundation.h>
#import <substrate.h>

// Tab bar style enum alias derived from Instagram reverse engineering.
typedef NSInteger IGTabBarStyle;
static const IGTabBarStyle kIGTabBarStyleLiquidGlass = 2;

// Original function pointers resolved by MobileSubstrate.
static BOOL (*orig_METAIsLiquidGlassEnabled)(void);
static BOOL (*orig_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet)(void);
static IGTabBarStyle (*orig_IGTabBarStyleForLauncherSet)(void);

// Global LiquidGlass gate: force enabled.
static BOOL hooked_METAIsLiquidGlassEnabled(void) {
    // Return the forced value; avoid invoking the original to keep the gate pinned on.
    (void)orig_METAIsLiquidGlassEnabled; // Silence unused warnings when not calling.
    return YES;
}

// Tab bar-specific LiquidGlass gate: force enabled.
static BOOL hooked_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet(void) {
    (void)orig_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet;
    return YES;
}

// Tab bar style resolver: always select LiquidGlass style.
static IGTabBarStyle hooked_IGTabBarStyleForLauncherSet(void) {
    (void)orig_IGTabBarStyleForLauncherSet;
    return kIGTabBarStyleLiquidGlass;
}

%ctor {
    @autoreleasepool {
        // Defensive null checks before using orig pointers are implicit since we do not call them.
        MSHookFunction((void *)&METAIsLiquidGlassEnabled,
                       (void *)&hooked_METAIsLiquidGlassEnabled,
                       (void **)&orig_METAIsLiquidGlassEnabled);

        MSHookFunction((void *)&IGIsCustomLiquidGlassTabBarEnabledForLauncherSet,
                       (void *)&hooked_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet,
                       (void **)&orig_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet);

        MSHookFunction((void *)&IGTabBarStyleForLauncherSet,
                       (void *)&hooked_IGTabBarStyleForLauncherSet,
                       (void **)&orig_IGTabBarStyleForLauncherSet);
    }
}
