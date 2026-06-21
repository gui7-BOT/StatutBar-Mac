# PRD — StatutBar‑Mac (fork de Thaw / Ice)

| | |
|---|---|
| **Produit** | StatutBar‑Mac — gestionnaire de barre de menus pour macOS |
| **Type** | Fork personnel de [Thaw](https://github.com/stonerl/Thaw) (lui‑même fork de [Ice](https://github.com/jordanbaird/Ice)) |
| **Auteur / Propriétaire** | Guillaume Gimenez |
| **Statut** | 🟡 Brouillon v0.1 — à itérer |
| **Date** | 2026‑06‑21 |
| **Cible technique** | macOS 26 (Tahoe) · Swift 6 · Xcode 26 |
| **Version actuelle du code** | 2.0.0‑rc.1 (build 47) |

> **But de ce document.** Servir de **source de vérité unique** sur ce qu'on attend de l'app. Il cadre une initiative de **fiabilisation** (pas d'ajout de fonctionnalités majeures), pour un **usage personnel**, avec 4 priorités : *icônes toujours cliquables · zéro plantage · simplicité · légèreté*. La stratégie de maintenance retenue est de **rester aligné sur le projet d'origine (Thaw)** et d'appliquer nos correctifs par‑dessus.

---

## 1. Résumé exécutif

- **Problème.** L'app masque des icônes de la barre de menus, mais quand on clique une icône cachée (dans la « Thaw Bar » flottante), elle devient régulièrement **inutilisable** ; le seul remède est de **quitter et relancer l'app**, ce qui ramène toutes les icônes.
- **Solution.** Fiabiliser le chemin *clic → afficher → cliquer → re‑cacher* pour qu'une icône cachée soit **toujours activable**, et garantir que tout blocage éventuel se **répare tout seul en quelques secondes** ou via **une commande simple en 1 clic** — sans jamais quitter l'app. En parallèle, garder l'app **légère** et l'usage **simple**.
- **Critères de succès (mesurables) :**
  1. **Taux de succès du clic** sur une icône cachée **≥ 99 %** (sur un test de 100 clics répétés, multi‑apps).
  2. **0 incident « obligé de quitter »** sur **7 jours** d'usage personnel continu.
  3. **Auto‑guérison ≤ 8 s** sans action utilisateur en cas de blocage interne ; **récupération manuelle en 1 clic efficace à 100 %**.
  4. **Empreinte mémoire stable** : **< 5 % de croissance** sur **24 h** d'usage (pas de fuite mémoire).
  5. **CPU au repos ≤ 2 %** (moyenne sur 5 min, machine inactive).

---

## 2. Expérience & fonctionnalités

### 2.1 Persona

- **« Guillaume », power‑user Mac, usage personnel.** Garde une barre de menus chargée, masque des icônes pour la garder propre, et veut **y accéder de façon fiable** sans que l'app le trahisse. Pas développeur ; veut **comprendre et régler facilement**, pas lire des logs.

### 2.2 User stories & critères d'acceptation

> Format : *En tant qu'utilisateur, je veux [action] afin de [bénéfice].* Chaque story a une **définition de « Terminé » (AC)** mesurable.

**US‑1 — Cliquer une icône cachée fonctionne toujours.**
*Je veux cliquer une icône cachée et qu'elle réagisse à tous les coups, afin de ne jamais devoir quitter l'app.*
- AC‑1.1 : Un clic gauche sur une icône de la Thaw Bar ouvre son menu/popover dans **≥ 99 %** des cas (test 100 clics).
- AC‑1.2 : Un clic droit déclenche l'action droite de l'icône avec le même taux.
- AC‑1.3 : Après l'action, l'icône **revient à sa place** (re‑cachée) sans rester bloquée à l'écran ni hors‑écran.
- AC‑1.4 : Le scénario fonctionne aussi **après une mise en veille** et sur **plusieurs écrans**.

**US‑2 — L'app se répare toute seule.**
*Je veux que, si un blocage interne survient, l'app se rétablisse seule rapidement, afin de ne pas rester coincé.*
- AC‑2.1 : Si la gestion des événements se retrouve désactivée par erreur, elle se **réactive automatiquement en ≤ 8 s**.
- AC‑2.2 : Un permis interne (sémaphore) fuité ne **bloque jamais durablement** les clics suivants.
- AC‑2.3 : Deux clics rapprochés sur la Thaw Bar ne **corrompent pas** l'état (clics sérialisés).

**US‑3 — Filet de sécurité en 1 clic.**
*Je veux une commande simple pour tout remettre d'aplomb si jamais ça coince, afin de ne pas avoir à quitter l'app.*
- AC‑3.1 : Une entrée de menu **« Restore All Menu Bar Items »** existe dans le menu de l'icône Thaw.
- AC‑3.2 : Elle est atteignable en **≤ 2 clics** et **révèle toutes les icônes** + nettoie l'état figé, **sans quitter l'app**.
- AC‑3.3 : Elle fonctionne **à 100 %**, même quand l'auto‑guérison n'a pas (encore) eu lieu.

**US‑4 — Léger et discret.**
*Je veux que l'app reste légère, afin qu'elle ne ralentisse ni n'épuise mon Mac.*
- AC‑4.1 : CPU **≤ 2 %** au repos (machine inactive, moyenne 5 min).
- AC‑4.2 : Mémoire **stable sur 24 h** (< 5 % de croissance) — la fuite connue de capture d'images (SkyLight) est corrigée.
- AC‑4.3 : Aucun impact perceptible sur la réactivité de la barre de menus du système.

**US‑5 — Simple à comprendre.**
*Je veux des réglages clairs, afin de configurer l'app sans documentation.*
- AC‑5.1 : Les réglages liés à la fiabilité (auto‑masquage, Thaw Bar, récupération) sont **regroupés et libellés en clair**.
- AC‑5.2 : Aucune action de récupération ne nécessite le Terminal ou la lecture de logs.

### 2.3 Hors‑périmètre (Non‑Goals)

Pour protéger le périmètre « fiabiliser l'existant / usage perso », **on ne fait PAS** (pour l'instant) :

- ❌ De **nouvelles fonctionnalités majeures** (widgets, nouveaux modes d'affichage, etc.).
- ❌ De **distribution publique** : pas d'App Store, pas de notarisation Apple, pas de DMG signé grand public.
- ❌ De **rebranding** (nom, icône, identité) — on garde « Thaw » tel quel en interne.
- ❌ De **nouvelles traductions** / support multi‑utilisateurs.
- ❌ de **réécriture complète** de l'architecture — on corrige de façon ciblée et réversible.
- ❌ De **divergence** d'avec l'amont Thaw : on reste aligné et on rebase nos correctifs.

---

## 3. Exigences système IA

**Non applicable.** Ce produit ne comporte aucune fonctionnalité d'IA. (Section conservée par cohérence avec le modèle de PRD.)

---

## 4. Spécifications techniques

### 4.1 Vue d'ensemble de l'architecture

L'app est une application AppKit/SwiftUI sans fenêtre principale (`LSUIElement`), pilotée par un état central `AppState` qui assemble ~14 sous‑gestionnaires. Les pièces qui comptent pour la fiabilité :

| Composant | Rôle |
|---|---|
| `MenuBarManager` | Orchestration : sections, Thaw Bar, survol, re‑masquage. |
| `MenuBarItemManager` (≈7 000 lignes) | **Cœur sensible** : déplace/clique les icônes via événements synthétiques ; cache, contextes « temporairement montrés », ledger de relocalisation. |
| `ControlItem` | Les 3 « chevrons » (visible / caché / toujours‑caché) ; masque en **élargissant** un item pour pousser les autres hors‑écran. |
| `IceBar` (Thaw Bar) | Panneau flottant affichant les icônes cachées (images capturées) et relayant les clics. |
| `HIDEventManager` | Surveillance souris/clavier ; active/désactive les moniteurs pendant les déplacements. |
| `MenuBarItemService` (XPC) | Service séparé qui résout le **vrai PID** des icônes (sous macOS 26, tout appartient à *Control Center*). |

**Mécanisme clé (et fragile).** Pour « montrer » une icône cachée, l'app **simule une souris** qui glisse l'icône à l'écran (événements `CGEvent` + API privées **SkyLight/CGS**), la clique, puis la re‑glisse à sa place. Ce chemin dépend de permissions et de timings macOS, d'où les blocages.

### 4.2 Causes racines identifiées (diagnostic)

1. **« waitForRelaunch »** : après 9 échecs de re‑masquage, l'icône est marquée et **ignorée jusqu'à ce que son identifiant de fenêtre change** → ne se débloque qu'au redémarrage de l'app propriétaire **ou de Thaw**. ⇒ *« obligé de quitter »*.
2. **`disableCount` déséquilibré** : un `startAll()` manqué laisse l'input mort ; filet de sécurité historique à **30 s**.
3. **Sémaphore d'événements** : un permis fuité bloque tous les clics suivants (deadlock déjà documenté dans le code).
4. **Clics Thaw Bar non sérialisés** : `Task {}` concurrents corrompant l'état partagé (cause intermittente).
5. **Résolution de PID macOS 26** : si le vrai PID n'est pas résolu, l'événement part vers *Control Center* et **ne fait rien** (clic « dans le vide »).
6. **Fuite mémoire** : la capture d'images via SkyLight (obligatoire sur macOS 26 pour les items hors‑écran) **fuit** à chaque appel → croissance mémoire sur longue session.

### 4.3 Points d'intégration

- **API privées Apple** : SkyLight / CoreGraphics Services (SkyLight = position/niveau/capture de fenêtres). **Non documentées, fragiles à chaque mise à jour macOS.**
- **Permissions système** : **Accessibilité** (obligatoire, pour synthétiser les clics) + **Enregistrement de l'écran** (pour capturer les images des icônes).
- **Service XPC** `com.stonerl.Thaw.MenuBarItemService` (résolution de PID).
- **Sparkle** (mises à jour), **UserDefaults** (réglages, positions, ledger de relocalisation).

### 4.4 Sécurité & confidentialité

- **Données locales uniquement.** Aucune collecte ni envoi réseau de données personnelles (hors vérif de mises à jour Sparkle). Usage perso → pas d'enjeu de conformité externe.
- **Permissions sensibles** (Accessibilité + Enregistrement d'écran) : nécessaires au fonctionnement, accordées localement par l'utilisateur. À **documenter clairement** dans l'app (pourquoi elles sont demandées).
- **Risque** : la dépendance aux API privées peut casser à une mise à jour macOS — voir risques §5.

---

## 5. Risques & feuille de route

### 5.1 Déploiement par phases

| Phase | Contenu | Statut |
|---|---|---|
| **Phase 0 — Filet de sécurité** | Récupération in‑process (`recoverFromStuckState`), commande menu **« Restore All Menu Bar Items »**, **sérialisation** des clics Thaw Bar, auto‑guérison **30 s → 8 s**. | ✅ **Fait** — PR #1, **validée en CI** (compile + tests OK sur macOS 26.5). |
| **Phase 1 — Empêcher le blocage** | Durcir la **résolution de PID macOS 26** (ne jamais cliquer « dans le vide » via Control Center) ; remplacer « abandonner jusqu'au relaunch » par une **auto‑récupération active**. | ⬜ À faire |
| **Phase 2 — Légèreté** | Corriger la **fuite mémoire SkyLight** ; réduire les **délais codés en dur** (81 `Task.sleep`) ; ajouter des **tests** sur le chemin de clic. | ⬜ À faire |
| **Phase 3 — Confort (optionnel)** | Petit **auto‑diagnostic** intégré (vérifie permissions + état, propose la récupération) ; regroupement/clarification des réglages de fiabilité. | ⬜ Optionnel |

### 5.2 Définition de « Terminé » & stratégie de test

- **CI verte obligatoire** sur chaque PR : build macOS 26 (Xcode 26.5) + tests + SwiftLint strict. *(Le check `sonarqube` échoue sur le fork faute de clé secrète — **ignoré**, sans rapport avec le code.)*
- **Tests manuels sur Mac réel** (macOS 26.4) pour chaque phase : clic d'icône cachée répété (≥100×), multi‑écrans, après veille, sous app plein écran.
- **Ajout progressif de tests automatisés** sur la logique de récupération et de résolution de PID (zones aujourd'hui non couvertes).

### 5.3 Risques techniques

| Risque | Impact | Mitigation |
|---|---|---|
| **Dépendance aux API privées** (SkyLight/CGS) | Cassure possible à chaque mise à jour macOS | Rester aligné sur l'amont Thaw (ils corrigent vite) ; isoler les appels privés. |
| **Pas de build local pour l'instant** (Xcode non installé) | Impossible de tester le comportement réel sans CI | Installer Xcode 26 ; en attendant, la CI valide la **compilation**. |
| **Permissions révoquées en cours d'usage** | Clics silencieusement inopérants | Re‑vérifier les permissions périodiquement et le signaler clairement. |
| **Correctifs « à l'aveugle »** (écrits sans compiler localement) | Régressions possibles | Chaque changement passe par la **CI** + test manuel avant fusion. |

---

## Annexe — Décisions actées

- **Ambition** : fiabiliser l'existant (pas de fonctionnalités majeures).
- **Audience** : usage personnel.
- **Priorités** : icônes toujours cliquables · zéro plantage · simplicité · légèreté.
- **Maintenance** : rester aligné sur Thaw, correctifs par‑dessus.

*Document de travail — dis‑moi ce que tu veux ajouter, retirer ou corriger, et je le fais évoluer.*
