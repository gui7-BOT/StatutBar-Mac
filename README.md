<div align="center">
    <img src="Resources/Icon.svg" width=200 height=200>
    <h1>StatutBar-Mac</h1>
</div>

Version personnelle du gestionnaire de barre de menus **Thaw** pour macOS 26+,
maintenue par [gui7-BOT](https://github.com/gui7-BOT). L'app masque et affiche
les icônes de la barre de menus, avec de nombreuses options (barre secondaire,
raccourcis, profils, réglages par écran…).

> [!NOTE]
> Ce repo est un fork de [Thaw](https://github.com/stonerl/Thaw) de Toni
> Förster, lui-même fork de [Ice](https://github.com/jordanbaird/Ice) de
> Jordan Baird. Licence [GNU GPLv3](LICENSE).

## Différences avec le Thaw officiel

- **Mises à jour automatiques désactivées** : l'app installée depuis ce repo
  ne se met pas à jour toute seule depuis le repo d'origine. Tu contrôles
  exactement la version qui tourne sur ton Mac.
- **Repo allégé** : les outils propres au mainteneur d'origine (Crowdin,
  SonarQube, sponsoring, triage automatique des issues…) ont été retirés.
- **Build sans certificat Apple** : le workflow [Build App](.github/workflows/build-app.yml)
  produit une app signée ad-hoc, téléchargeable depuis l'onglet Actions —
  aucun compte Apple Developer payant nécessaire.

## Installation

Voir **[DEPLOIEMENT.md](DEPLOIEMENT.md)** — deux méthodes :

1. **Sans Xcode** : télécharger le build produit par GitHub Actions
   (onglet [Actions](../../actions/workflows/build-app.yml) → artefact
   `StatutBar-Thaw-app`).
2. **Avec Xcode** : `./scripts/build-app.sh` compile et installe l'app.

Prérequis : **macOS 26+**. Au premier lancement, accorder les permissions
**Accessibilité** et **Enregistrement de l'écran** dans Réglages Système.

## Développement

- Projet Xcode : `Thaw.xcodeproj`, scheme `Thaw` (Xcode 26+ requis).
- CI : lint (SwiftLint), validation des chaînes localisées et tests unitaires
  sur chaque PR ([ci.yml](.github/workflows/ci.yml)).
- Problèmes connus de l'app : voir [FREQUENT_ISSUES.md](FREQUENT_ISSUES.md).
- Schémas d'URI `thaw://` : voir [docs/URI_SCHEMES.md](docs/URI_SCHEMES.md).

## Crédits

- [Jordan Baird](https://github.com/jordanbaird) — auteur d'Ice, le projet
  d'origine.
- [Toni Förster](https://github.com/stonerl) — auteur de Thaw
  ([soutenir son travail](https://github.com/sponsors/stonerl)).
