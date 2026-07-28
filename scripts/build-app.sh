#!/bin/bash
#
# Construit Thaw.app en Release (signature ad-hoc, aucun certificat Apple requis)
# et propose de l'installer dans /Applications.
#
# Prérequis : macOS 26+, Xcode 26+ (App Store), lancé depuis la racine du repo :
#   ./scripts/build-app.sh
#
set -euo pipefail

cd "$(dirname "$0")/.."

APP_PATH="Build/Build/Products/Release/Thaw.app"

echo "==> Compilation (Release)…"
xcodebuild build \
    -project Thaw.xcodeproj \
    -scheme Thaw \
    -configuration Release \
    -derivedDataPath Build/ \
    -destination 'platform=macOS' \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

echo "==> Signature ad-hoc…"
codesign --force --deep --sign - "$APP_PATH"
codesign --verify --verbose=2 "$APP_PATH"

echo "==> Build terminé : $APP_PATH"

read -r -p "Installer dans /Applications ? (remplace la version existante) [o/N] " reply
if [[ "$reply" =~ ^[oOyY]$ ]]; then
    rm -rf /Applications/Thaw.app
    ditto "$APP_PATH" /Applications/Thaw.app
    echo "==> Installé : /Applications/Thaw.app"
    echo "    Au premier lancement, accorde les permissions demandées"
    echo "    (Accessibilité + Enregistrement de l'écran) dans Réglages Système."
else
    echo "==> Installation ignorée. L'app est dans : $APP_PATH"
fi
