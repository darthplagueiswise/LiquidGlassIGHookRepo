// FBFeatureHooks.m
// fishhook-based rebinding for Instagram LiquidGlass and related UI gates.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FBFeatureToggleManager.h"
#import "FBFeatureOverlayUI.h"
#import "fishhook.h"

#pragma mark - Original symbol declarations

typedef BOOL (*IGBoolFunc)(void);
typedef int  (*IGIntFunc)(void);

static IGBoolFunc orig_METAIsLiquidGlassEnabled;
static IGBoolFunc orig_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet;

static IGIntFunc  orig_IGTabBarStyleForLauncherSet;
static IGBoolFunc orig_IGTabBarDynamicSizingEnabled;
static IGBoolFunc orig_IGTabBarIsFloatingStyle;
static IGBoolFunc orig_IGViewControllerHidesTabBar;

static IGBoolFunc orig_IGDirectAvatarPowerUpsEnabledForInstamadillo;
static IGBoolFunc orig_IGDirectPowerUpsEnabledForInstamadillo;
static IGBoolFunc orig_IGDirectNotesBubbleCustomizationEnabled;
static IGBoolFunc orig_IGDirectNotesTrayPulldownIsEnabled;
static IGBoolFunc orig_IGDirectNotesTrayScrollToFrontOnStatusBarTappedEnabled;

#pragma mark - Wrappers

static BOOL fb_METAIsLiquidGlassEnabled(void) {
    FBFeatureToggleManager *mgr = [FBFeatureToggleManager sharedManager];
    if ([mgr isEnabledForKey:FBFeatureToggleKeyLiquidGlassGlobal]) {
        return YES;
    }
    if (orig_METAIsLiquidGlassEnabled) {
        return orig_METAIsLiquidGlassEnabled();
    }
    return YES;
}

static BOOL fb_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet(void) {
    FBFeatureToggleManager *mgr = [FBFeatureToggleManager sharedManager];
    if ([mgr isEnabledForKey:FBFeatureToggleKeyLiquidGlassTabBar]) {
        return YES;
    }
    if (orig_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet) {
        return orig_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet();
    }
    return YES;
}

static int fb_IGTabBarStyleForLauncherSet(void) {
    FBFeatureToggleManager *mgr = [FBFeatureToggleManager sharedManager];
    if ([mgr isEnabledForKey:FBFeatureToggleKeyTabBarStyle1]) {
        return 1;
    }
    if (orig_IGTabBarStyleForLauncherSet) {
        return orig_IGTabBarStyleForLauncherSet();
    }
    return 0;
}

static BOOL fb_IGTabBarDynamicSizingEnabled(void) {
    FBFeatureToggleManager *mgr = [FBFeatureToggleManager sharedManager];
    if ([mgr isEnabledForKey:FBFeatureToggleKeyTabBarDynamicSizing]) {
        return YES;
    }
    if (orig_IGTabBarDynamicSizingEnabled) {
        return orig_IGTabBarDynamicSizingEnabled();
    }
    return NO;
}

static BOOL fb_IGTabBarIsFloatingStyle(void) {
    FBFeatureToggleManager *mgr = [FBFeatureToggleManager sharedManager];
    if ([mgr isEnabledForKey:FBFeatureToggleKeyTabBarFloating]) {
        return YES;
    }
    if (orig_IGTabBarIsFloatingStyle) {
        return orig_IGTabBarIsFloatingStyle();
    }
    return NO;
}

static BOOL fb_IGViewControllerHidesTabBar(void) {
    FBFeatureToggleManager *mgr = [FBFeatureToggleManager sharedManager];
    if ([mgr isEnabledForKey:FBFeatureToggleKeyTabBarAlwaysVisible]) {
        return NO;
    }
    if (orig_IGViewControllerHidesTabBar) {
        return orig_IGViewControllerHidesTabBar();
    }
    return NO;
}

static BOOL fb_direct_UI_override(IGBoolFunc orig) {
    FBFeatureToggleManager *mgr = [FBFeatureToggleManager sharedManager];
    if ([mgr isEnabledForKey:FBFeatureToggleKeyDirectNotesUI]) {
        return YES;
    }
    if (orig) {
        return orig();
    }
    return NO;
}

static BOOL fb_IGDirectAvatarPowerUpsEnabledForInstamadillo(void) {
    return fb_direct_UI_override(orig_IGDirectAvatarPowerUpsEnabledForInstamadillo);
}

static BOOL fb_IGDirectPowerUpsEnabledForInstamadillo(void) {
    return fb_direct_UI_override(orig_IGDirectPowerUpsEnabledForInstamadillo);
}

static BOOL fb_IGDirectNotesBubbleCustomizationEnabled(void) {
    return fb_direct_UI_override(orig_IGDirectNotesBubbleCustomizationEnabled);
}

static BOOL fb_IGDirectNotesTrayPulldownIsEnabled(void) {
    return fb_direct_UI_override(orig_IGDirectNotesTrayPulldownIsEnabled);
}

static BOOL fb_IGDirectNotesTrayScrollToFrontOnStatusBarTappedEnabled(void) {
    return fb_direct_UI_override(orig_IGDirectNotesTrayScrollToFrontOnStatusBarTappedEnabled);
}

#pragma mark - Hook installation

static void fb_install_hooks(void) {
    struct rebinding rebs[] = {
        { "METAIsLiquidGlassEnabled", (void *)fb_METAIsLiquidGlassEnabled, (void **)&orig_METAIsLiquidGlassEnabled },
        { "IGIsCustomLiquidGlassTabBarEnabledForLauncherSet", (void *)fb_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet, (void **)&orig_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet },
        { "IGTabBarStyleForLauncherSet", (void *)fb_IGTabBarStyleForLauncherSet, (void **)&orig_IGTabBarStyleForLauncherSet },
        { "IGTabBarDynamicSizingEnabled", (void *)fb_IGTabBarDynamicSizingEnabled, (void **)&orig_IGTabBarDynamicSizingEnabled },
        { "IGTabBarIsFloatingStyle", (void *)fb_IGTabBarIsFloatingStyle, (void **)&orig_IGTabBarIsFloatingStyle },
        { "IGViewControllerHidesTabBar", (void *)fb_IGViewControllerHidesTabBar, (void **)&orig_IGViewControllerHidesTabBar },
        { "IGDirectAvatarPowerUpsEnabledForInstamadillo", (void *)fb_IGDirectAvatarPowerUpsEnabledForInstamadillo, (void **)&orig_IGDirectAvatarPowerUpsEnabledForInstamadillo },
        { "IGDirectPowerUpsEnabledForInstamadillo", (void *)fb_IGDirectPowerUpsEnabledForInstamadillo, (void **)&orig_IGDirectPowerUpsEnabledForInstamadillo },
        { "IGDirectNotesBubbleCustomizationEnabled", (void *)fb_IGDirectNotesBubbleCustomizationEnabled, (void **)&orig_IGDirectNotesBubbleCustomizationEnabled },
        { "IGDirectNotesTrayPulldownIsEnabled", (void *)fb_IGDirectNotesTrayPulldownIsEnabled, (void **)&orig_IGDirectNotesTrayPulldownIsEnabled },
        { "IGDirectNotesTrayScrollToFrontOnStatusBarTappedEnabled", (void *)fb_IGDirectNotesTrayScrollToFrontOnStatusBarTappedEnabled, (void **)&orig_IGDirectNotesTrayScrollToFrontOnStatusBarTappedEnabled },
    };

    rebind_symbols(rebs, sizeof(rebs) / sizeof(rebs[0]));
}

__attribute__((constructor))
static void fb_feature_overlay_init(void) {
    fb_install_hooks();
    [FBFeatureOverlayUI installOverlay];
}
