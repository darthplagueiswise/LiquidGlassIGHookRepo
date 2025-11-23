Agent Instructions for LiquidGlassIGHook

Project Purpose

This repository has ONE narrow purpose:
•Build a standalone iOS arm64 dynamic library named LiquidGlassIGHook.dylib.
•This library will be injected into Instagram’s process to force-enable the internal “LiquidGlass” tab bar UI and related gates.
•The build system MUST be deterministic and fully driven by Git + GitHub Actions (no manual Xcode usage).

Everything the agent does in this repo should serve that single purpose.

⸻

Technical Requirements
•Language: Objective-C / Logos (Theos tweak style).
•Target: arm64 only (modern iOS devices such as iPhone 15 Pro/Max).
•Output:
•LiquidGlassIGHook.dylib built by Theos.
•The GitHub Actions workflow must upload the dylib as an artifact (for example: LiquidGlassIGHook-dylib).

The tweak hooks three existing C functions inside Instagram’s binary/frameworks:

BOOL METAIsLiquidGlassEnabled(void);
BOOL IGIsCustomLiquidGlassTabBarEnabledForLauncherSet(void);
IGTabBarStyle IGTabBarStyleForLauncherSet(void);

Desired runtime behavior:
•METAIsLiquidGlassEnabled → always behaves as if it returns YES.
•IGIsCustomLiquidGlassTabBarEnabledForLauncherSet → always behaves as if it returns YES.
•IGTabBarStyleForLauncherSet → always returns the LiquidGlass tab bar style, matching the configuration used when LiquidGlass is enabled server-side.

Hooking strategy:
•Use Theos + Logos and MobileSubstrate-style C function hooks, not brittle binary patching in the workflow.
•The dylib must be safe to inject via tools such as Feather or other IPA patchers (injection is handled outside this repo).

⸻

Repository Layout

The agent should maintain the repository roughly like this:
•AGENTS.md – this file with the instructions for the agent.
•README.md – short human-readable description of what the project does and how to use the produced dylib.
•Makefile – Theos tweak Makefile building an arm64 dylib.
•control – Debian control file for optional .deb packaging (not strictly required for the dylib, but allowed).
•src/IGLiquidGlassIGHook.xm – main Logos / Objective-C source implementing the hooks.
•.github/workflows/build.yml – GitHub Actions workflow that:
•installs dependencies (Theos, ldid, etc.),
•runs make clean and make package FINALPACKAGE=1 or make,
•uploads LiquidGlassIGHook.dylib as an artifact.

The agent may add small helper files if absolutely necessary, but must keep the repo minimal and focused.

⸻

Git & Branch / Pull Request Policy

This repository is managed entirely through GitHub and Codex.
1.Default branch name: main.
2.Initial setup in an empty repo:
•If the repository has NO commits yet, the agent must:
•create all required files (AGENTS.md, Makefile, src/IGLiquidGlassIGHook.xm, workflow, etc.),
•commit them directly to main (no pull request needed for the very first commit).
3.Subsequent changes:
•After main exists with at least one commit:
•Create a short-lived feature branch from main (for example feat/initial-hooks, fix/build-error, etc.).
•Commit changes to that branch.
•Open a pull request back into main.

Auto-merge Rules (IMPORTANT)

Auto-merge is enabled on this repository. The agent is expected to:
•Always open pull requests from feature branches into main.
•Ensure the PR passes the CI workflow (GitHub Actions build job).
•Enable auto-merge on the PR using the preferred strategy (for example, “squash and merge”), so that:
•Once checks pass, the PR is merged automatically,
•No manual human merge is required.

When preparing a PR, the agent may self-approve and configure auto-merge if the repository settings allow it. The user does not want to manually press the merge button.

If auto-merge cannot be enabled for any reason (permissions or settings), the agent must clearly mention this in the PR description and keep the PR ready-to-merge (green CI, no pending work).

⸻

Build Workflow Requirements

The build workflow (.github/workflows/build.yml) must:
1.Run on a macOS runner compatible with iOS SDKs (e.g. macos-15-arm64).
2.Install or clone Theos (including its submodules) in a stable way, for example:
•git clone --recursive https://github.com/theos/theos.git "$HOME/theos"
3.Export environment variables:
•THEOS="$HOME/theos"
•THEOS_MAKE_PATH="$THEOS/makefiles"
4.Run:
•make clean
•make package FINALPACKAGE=1  or make (as long as this produces the dylib in a predictable location).
5.Upload the built LiquidGlassIGHook.dylib as an artifact (for example using actions/upload-artifact@v4 with a name like LiquidGlassIGHook-dylib).

The workflow must be idempotent and should not depend on any local machine paths. All paths must work on the GitHub runner.

⸻

Coding Style & Safety
•Keep the hook implementation small, explicit and defensive:
•Check for NULL before calling original function pointers.
•Avoid any heavy work in +load or constructor attributes; keep initialization minimal.
•Comment clearly where the hooks are applied and what they do.
•Do not add unrelated features (no extra debugging UI, no logging spam, no Flex injection) unless explicitly requested.

⸻

What the Agent MUST NOT Do
•Do not change repository goals (no general-purpose tweak framework, no extra apps).
•Do not delete or rewrite AGENTS.md except to follow explicit user instructions.
•Do not add unrelated CI jobs (linting, tests for other languages, etc.) unless needed to keep the build green.
•Do not re-enable manual merge workflows; rely on auto-merge whenever possible.

⸻

Summary for the Agent

When working in this repo, always remember:
•Single purpose: build LiquidGlassIGHook.dylib (iOS, arm64) that hooks the LiquidGlass gates in Instagram.
•Use Theos + Logos to implement the hooks.
•Maintain a clean repo layout and a single macOS GitHub Actions workflow that builds and uploads the dylib.
•Use main as the default branch, feature branches + PRs afterwards.
•Always configure pull requests with auto-merge enabled, so once CI passes, changes land in main without human intervention.
