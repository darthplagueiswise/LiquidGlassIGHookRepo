# LiquidGlassIGHook (Theos / Logos)

LiquidGlassIGHook is an arm64 iOS dynamic library built with Theos. It hooks
Instagram's internal LiquidGlass feature gates so the tab bar always uses the
LiquidGlass style when injected into the Instagram process.

## Hooked symbols

```
BOOL METAIsLiquidGlassEnabled(void);
BOOL IGIsCustomLiquidGlassTabBarEnabledForLauncherSet(void);
IGTabBarStyle IGTabBarStyleForLauncherSet(void);
```

The tweak forces:
- `METAIsLiquidGlassEnabled` → `YES`
- `IGIsCustomLiquidGlassTabBarEnabledForLauncherSet` → `YES`
- `IGTabBarStyleForLauncherSet` → LiquidGlass style (`2`)

## Building with Theos

Requirements on macOS runners (as reflected in CI):
- Xcode with iOS SDKs (tested on GitHub Actions `macos-15-arm64`).
- Homebrew packages: `ldid`, `dpkg`.
- Theos cloned with submodules.

Local build steps:

```sh
export THEOS="$HOME/theos"
export THEOS_MAKE_PATH="$THEOS/makefiles"
make clean
make package FINALPACKAGE=1
```

The resulting `LiquidGlassIGHook.dylib` will be in the `.theos` build output
(e.g., `.theos/obj/arm64/LiquidGlassIGHook.dylib`).

## Injection notes

1. Place `LiquidGlassIGHook.dylib` in `Instagram.app/Frameworks/`.
2. Add an `LC_LOAD_DYLIB` entry pointing to `@executable_path/Frameworks/LiquidGlassIGHook.dylib`.
3. Re-sign the app bundle and deploy via your preferred method.

No fishhook or MobileSubstrate runtime is bundled here; the dylib relies on
standard MobileSubstrate-style hooks provided by the target environment at
runtime.
