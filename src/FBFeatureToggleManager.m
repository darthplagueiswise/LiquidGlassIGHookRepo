// FBFeatureToggleManager.m
// Simple in-memory toggle storage used by hooks and overlay UI.

#import "FBFeatureToggleManager.h"

@interface FBFeatureToggleManager ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *storage;
@end

@implementation FBFeatureToggleManager

+ (instancetype)sharedManager {
    static FBFeatureToggleManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[self alloc] initPrivate];
    });
    return mgr;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _storage = [NSMutableDictionary dictionary];
    }
    return self;
}

// Avoid use of -init directly
- (instancetype)init {
    return [FBFeatureToggleManager sharedManager];
}

- (void)setEnabled:(BOOL)enabled forKey:(FBFeatureToggleKey)key {
    @synchronized (self) {
        self.storage[@(key)] = @(enabled);
    }
}

- (BOOL)isEnabledForKey:(FBFeatureToggleKey)key {
    @synchronized (self) {
        NSNumber *val = self.storage[@(key)];
        return val.boolValue;
    }
}

@end
