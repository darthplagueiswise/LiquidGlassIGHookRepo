// FBFeatureOverlayUI.m
// Presents a floating button that opens a toggle panel for LiquidGlass gates.

#import "FBFeatureOverlayUI.h"
#import "FBFeatureToggleManager.h"

@interface FBFeatureOverlayButtonWindow : UIWindow
@end

@implementation FBFeatureOverlayButtonWindow
- (instancetype)init {
    self = [super initWithFrame:CGRectMake(8, 120, 44, 44)];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = NO;
    }
    return self;
}
@end

@interface FBFeatureOverlayViewController : UITableViewController
@end

@implementation FBFeatureOverlayViewController

- (NSArray<NSNumber *> *)allKeys {
    return @[
        @(FBFeatureToggleKeyLiquidGlassGlobal),
        @(FBFeatureToggleKeyLiquidGlassTabBar),
        @(FBFeatureToggleKeyTabBarStyle1),
        @(FBFeatureToggleKeyTabBarDynamicSizing),
        @(FBFeatureToggleKeyTabBarFloating),
        @(FBFeatureToggleKeyTabBarAlwaysVisible),
        @(FBFeatureToggleKeyDirectNotesUI),
    ];
}

- (NSString *)titleForKey:(FBFeatureToggleKey)key {
    switch (key) {
        case FBFeatureToggleKeyLiquidGlassGlobal:
            return @"METAIsLiquidGlassEnabled";
        case FBFeatureToggleKeyLiquidGlassTabBar:
            return @"IGIsCustomLiquidGlassTabBarEnabledForLauncherSet";
        case FBFeatureToggleKeyTabBarStyle1:
            return @"IGTabBarStyleForLauncherSet → style=1";
        case FBFeatureToggleKeyTabBarDynamicSizing:
            return @"IGTabBarDynamicSizingEnabled";
        case FBFeatureToggleKeyTabBarFloating:
            return @"IGTabBarIsFloatingStyle";
        case FBFeatureToggleKeyTabBarAlwaysVisible:
            return @"IGViewControllerHidesTabBar = NO";
        case FBFeatureToggleKeyDirectNotesUI:
            return @"Direct/Instamadillo – Notes/PowerUps UI";
        default:
            return @"(unknown)";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FB Feature Toggles";
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FBFeatureToggleKey key = self.allKeys[indexPath.row].integerValue;
    cell.textLabel.text = [self titleForKey:key];

    UISwitch *sw = (UISwitch *)cell.accessoryView;
    if (![sw isKindOfClass:UISwitch.class]) {
        sw = [[UISwitch alloc] init];
        [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
    }
    sw.tag = key;
    sw.on = [[FBFeatureToggleManager sharedManager] isEnabledForKey:key];

    return cell;
}

- (void)switchChanged:(UISwitch *)sender {
    FBFeatureToggleKey key = (FBFeatureToggleKey)sender.tag;
    [[FBFeatureToggleManager sharedManager] setEnabled:sender.isOn forKey:key];
}

@end

@implementation FBFeatureOverlayUI

+ (void)installOverlay {
    dispatch_async(dispatch_get_main_queue(), ^{
        static FBFeatureOverlayButtonWindow *buttonWindow;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            buttonWindow = [[FBFeatureOverlayButtonWindow alloc] init];

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = buttonWindow.bounds;
            button.layer.cornerRadius = 22;
            button.clipsToBounds = YES;
            button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [button setTitle:@"FG" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button addTarget:self action:@selector(showPanel) forControlEvents:UIControlEventTouchUpInside];
            [buttonWindow addSubview:button];

            buttonWindow.hidden = NO;
        });
    });
}

+ (void)showPanel {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) return;

    UIViewController *root = keyWindow.rootViewController;
    if (!root) return;

    FBFeatureOverlayViewController *vc = [[FBFeatureOverlayViewController alloc] initWithStyle:UITableViewStyleInsetGrouped];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationPageSheet;

    [root presentViewController:nav animated:YES completion:nil];
}

@end
