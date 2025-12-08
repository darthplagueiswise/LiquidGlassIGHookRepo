# LiquidGlassIGHook (Theos + Logos)

LiquidGlassIGHook is an arm64 iOS dynamic library built with Theos and Logos.
It injects into Instagram and forces the LiquidGlass tab bar experience by
hooking the feature-gate C functions via MobileSubstrate-style hooks.

## Runtime behavior

The tweak overrides three Instagram functions:

- `METAIsLiquidGlassEnabled` → returns `YES`
- `IGIsCustomLiquidGlassTabBarEnabledForLauncherSet` → returns `YES`
- `IGTabBarStyleForLauncherSet` → returns style `1` (LiquidGlass style)

No UI or runtime toggles are included; the hooks always enable the LiquidGlass
path so the tab bar stays active after injection.

## Source layout

- `src/IGLiquidGlassIGHook.xm` — Logos hooks for the three C functions.

## Building with Theos

Requirements on macOS runners (as reflected in CI):
- Xcode with iOS SDKs (tested on GitHub Actions `macos-15`).
- Homebrew packages: `ldid`, `dpkg`.
- Theos cloned with submodules.

Local build steps:

```sh
export THEOS="$HOME/theos"
export THEOS_MAKE_PATH="$THEOS/makefiles"
make clean
make
```

The resulting `LiquidGlassIGHook.dylib` will be in the `.theos` build output
(e.g., `.theos/obj/arm64/LiquidGlassIGHook.dylib`). The makefile runs `ldid`
automatically to sign the dylib.

## Injection notes

1. Place `LiquidGlassIGHook.dylib` in `Instagram.app/Frameworks/`.
2. Add an `LC_LOAD_DYLIB` entry pointing to
   `@executable_path/Frameworks/LiquidGlassIGHook.dylib`.
3. Re-sign the app bundle and deploy via your preferred method.

The build uses Theos directly; no fishhook clone is needed because Logos handles
hooking the required C functions.
