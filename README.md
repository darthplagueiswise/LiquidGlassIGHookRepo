# LiquidGlassIGHook (fishhook-based iOS dylib)

LiquidGlassIGHook is an arm64 iOS dynamic library built with Theos. It injects
into Instagram and uses fishhook to rebind LiquidGlass-related feature gates.
A small in-app overlay exposes toggles so you can force-enable behaviors
without relying on Substrate APIs.

## Runtime behavior

Hooks are installed via a constructor and can defer to the original functions
unless a toggle is enabled. The overlay exposes switches for:

- `METAIsLiquidGlassEnabled`
- `IGIsCustomLiquidGlassTabBarEnabledForLauncherSet`
- `IGTabBarStyleForLauncherSet` (forces style `1`)
- `IGTabBarDynamicSizingEnabled`
- `IGTabBarIsFloatingStyle`
- `IGViewControllerHidesTabBar` (forces NO when enabled)
- Direct/Instamadillo Notes & PowerUps UI gates (`IGDirect*` functions)

A floating **FG** button appears near the status bar; tapping it opens the
panel of switches. When a switch is OFF the original Instagram behavior is
preserved.

## Source layout

- `src/FBFeatureToggleManager.{h,m}` — in-memory toggle storage.
- `src/FBFeatureOverlayUI.{h,m}` — floating button + toggle panel UI.
- `src/FBFeatureHooks.m` — fishhook wrappers that consult the toggles.
- `src/fishhook.{c,h}` — vendored from Facebook's fishhook.

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
(e.g., `.theos/obj/arm64/LiquidGlassIGHook.dylib`). Sign the dylib (ldid is
invoked automatically in the makefile).

## Injection notes

1. Place `LiquidGlassIGHook.dylib` in `Instagram.app/Frameworks/`.
2. Add an `LC_LOAD_DYLIB` entry pointing to
   `@executable_path/Frameworks/LiquidGlassIGHook.dylib`.
3. Re-sign the app bundle and deploy via your preferred method.

fishhook is bundled in this repo; no MobileSubstrate runtime is required.
