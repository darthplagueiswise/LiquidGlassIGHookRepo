// FBFeatureOverlayUI.h
// Minimal overlay UI to toggle LiquidGlass feature gates at runtime.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBFeatureOverlayUI : NSObject

+ (void)installOverlay;

@end

NS_ASSUME_NONNULL_END
