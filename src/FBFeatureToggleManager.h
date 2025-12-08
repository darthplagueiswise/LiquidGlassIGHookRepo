// FBFeatureToggleManager.h
// Lightweight feature toggle storage for LiquidGlassIGHook.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FBFeatureToggleKey) {
    FBFeatureToggleKeyLiquidGlassGlobal = 0,
    FBFeatureToggleKeyLiquidGlassTabBar,
    FBFeatureToggleKeyTabBarStyle1,
    FBFeatureToggleKeyTabBarDynamicSizing,
    FBFeatureToggleKeyTabBarFloating,
    FBFeatureToggleKeyTabBarAlwaysVisible,
    FBFeatureToggleKeyDirectNotesUI,
};

@interface FBFeatureToggleManager : NSObject

+ (instancetype)sharedManager;

// Read/write the state of a toggle
- (void)setEnabled:(BOOL)enabled forKey:(FBFeatureToggleKey)key;
- (BOOL)isEnabledForKey:(FBFeatureToggleKey)key;

@end

NS_ASSUME_NONNULL_END
