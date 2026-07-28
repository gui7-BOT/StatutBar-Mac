# Déployer l'app sur ton Mac

Deux méthodes au choix. Dans les deux cas, l'app produite s'appelle `Thaw.app`
(le nom interne du projet), mais c'est **ta** version : elle ne se met pas à
jour toute seule et ne dépend plus du repo d'origine.

> **Prérequis : macOS 26 ou plus récent** (l'app ne fonctionne pas sur les
> versions antérieures).

---

## Méthode 1 — Sans Xcode : télécharger le build GitHub Actions (recommandé)

1. Va dans l'onglet **Actions** du repo :
   <https://github.com/gui7-BOT/StatutBar-Mac/actions/workflows/build-app.yml>
2. Ouvre l'exécution la plus récente (coche verte ✅). S'il n'y en a pas,
   clique **Run workflow** → branche `main` → **Run workflow**, puis attends
   ~10‑15 min.
3. En bas de la page de l'exécution, section **Artifacts**, télécharge
   **StatutBar-Thaw-app**.
4. Décompresse le fichier : tu obtiens `Thaw.app`.
5. Glisse `Thaw.app` dans le dossier **Applications**.
6. **Important** — l'app n'est pas notariée par Apple, macOS va la bloquer au
   premier lancement. Ouvre le **Terminal** et lance :

   ```sh
   xattr -dr com.apple.quarantine /Applications/Thaw.app
   ```

   Puis ouvre l'app normalement.
7. Au premier lancement, accorde les permissions demandées dans
   **Réglages Système → Confidentialité et sécurité** :
   - **Accessibilité**
   - **Enregistrement de l'écran et audio du système**

---

## Méthode 2 — Avec Xcode : compiler sur ton Mac

1. Installe **Xcode 26** depuis l'App Store (gratuit), puis ouvre-le une fois
   pour qu'il finisse son installation.
2. Clone le repo et lance le script :

   ```sh
   git clone https://github.com/gui7-BOT/StatutBar-Mac.git
   cd StatutBar-Mac
   ./scripts/build-app.sh
   ```

3. Le script compile l'app puis propose de l'installer dans `/Applications`.
   Une app compilée localement n'est pas mise en quarantaine : pas besoin de
   la commande `xattr`.
4. Accorde les permissions comme ci-dessus (Accessibilité + Enregistrement de
   l'écran).

---

## Bon à savoir

- **Pas de mise à jour automatique** : le flux Sparkle vers le repo d'origine
  a été volontairement désactivé. Pour mettre à jour, re-télécharge un
  artefact (méthode 1) ou relance le script (méthode 2), puis remplace l'app.
- **Permissions à re-accorder** : la signature est « ad-hoc » (sans certificat
  payant Apple). À chaque nouvelle version installée, macOS peut redemander
  les permissions Accessibilité / Enregistrement de l'écran — c'est normal.
- **Désinstallation** : quitte l'app (icône de la barre de menus → Quit),
  puis supprime `/Applications/Thaw.app`.
