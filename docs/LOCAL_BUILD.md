# Building & running Thaw locally (free Apple ID)

This guide explains how to build and run Thaw from source on your own Mac so
you can test changes. A **free** Apple ID is enough — no paid developer
account is required.

## Requirements

- macOS 26 or later (the app targets macOS 26+).
- **Xcode** (latest version from the Mac App Store; CI builds with Xcode 26.5).
- An **Apple ID** added to Xcode for code signing (a free personal team works).

## Steps

1. **Install Xcode** from the Mac App Store (free, large download). Let it
   finish completely before opening it the first time.
2. Open **`Thaw.xcodeproj`** in Xcode.
3. Add your Apple ID: **Xcode ▸ Settings… ▸ Accounts ▸ +** and sign in.
4. Set the signing team on **both** targets (this is the important part):
   - Select the project in the sidebar, then the **Thaw** target ▸
     **Signing & Capabilities** ▸ keep *Automatically manage signing* checked
     ▸ set **Team** to your Apple ID (Personal Team).
   - Do the same for the **MenuBarItemService** target, using the **same** team.
   - *Why both, and the same team:* the helper service only accepts
     connections from a client signed by the **same** Apple Developer Team
     (`XPCListener(..., requirement: .isFromSameTeam())`). If the app and the
     service use different teams (or one is ad‑hoc / "Sign to Run Locally"),
     the service won't connect and item features will silently fail.
5. Pick the **Thaw** scheme in the toolbar, then press **Run** (⌘R).
6. When prompted, grant **Accessibility** access
   (System Settings ▸ Privacy & Security ▸ Accessibility). The app needs it to
   manage menu bar items.

> Tip: quit any App Store / release build of Thaw (or Ice) before running your
> local build, so the two don't fight over the menu bar.

## Troubleshooting

- **"Failed to register bundle identifier" / "com.stonerl.Thaw is not
  available"** — the upstream bundle identifiers are owned by another team, so
  a free team can't reuse them. The bundle IDs are referenced in a couple of
  hard‑coded places (the XPC service name and a bundle‑ID check), so they must
  be changed together. Ask and this can be switched to a unique identifier on
  the branch; then pull and rebuild.
- **App runs but icons don't move / PID resolution fails** — double‑check that
  **both** targets are signed with the **same** team (see step 4).
