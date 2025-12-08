// Hooks the LiquidGlass feature gate C functions using Logos.
// The tweak forces Instagram's LiquidGlass tab bar to stay enabled.

// Always report LiquidGlass as enabled.
%hookf BOOL METAIsLiquidGlassEnabled(void) {
    return YES;
}

// Ensure the custom LiquidGlass tab bar is enabled for the launcher set.
%hookf BOOL IGIsCustomLiquidGlassTabBarEnabledForLauncherSet(void) {
    return YES;
}

// Force the LiquidGlass tab bar style variant.
typedef int IGTabBarStyle;
%hookf IGTabBarStyle IGTabBarStyleForLauncherSet(void) {
    // Instagram uses style "1" for the LiquidGlass configuration.
    return 1;
}
