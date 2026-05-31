# win-10-clean

Script batch pour Windows 10/11 qui nettoie les fichiers temporaires, les caches, et applique des réglages système pour améliorer les performances. Nécessite les droits administrateur.

---

## Prérequis

- Windows 10 ou Windows 11
- Compte administrateur

---

## Utilisation

Clic droit sur `cleanup.bat` puis **Exécuter en tant qu'administrateur**.

---

## Ce que fait le script

### Nettoyage (étapes 1–12)

| Étape | Cible | Chemin(s) |
|-------|-------|-----------|
| 1 | Fichiers temporaires | `%TEMP%`, `C:\Windows\Temp`, `C:\Temp` |
| 2 | Cache Prefetch | `C:\Windows\Prefetch` |
| 3 | Journaux d'événements Windows | Tous les journaux via `wevtutil` |
| 4 | Fichiers récents | `%APPDATA%\Microsoft\Windows\Recent` |
| 5 | Cache miniatures et icônes | `%LOCALAPPDATA%\Microsoft\Windows\Explorer` |
| 6 | Cache DNS, table ARP, cache NetBIOS | `ipconfig`, `arp`, `nbtstat` |
| 7 | Cache de téléchargement Windows Update | `C:\Windows\SoftwareDistribution\Download` |
| 8 | Rapports d'erreurs Windows | `C:\ProgramData\Microsoft\Windows\WER` |
| 9 | Fichiers de vidage mémoire (crash dumps) | `C:\Windows\Minidump`, `MEMORY.DMP`, `%LOCALAPPDATA%\CrashDumps` |
| 10 | Index de recherche Windows | `C:\ProgramData\Microsoft\Search\Data` |
| 11 | Caches navigateurs | Chrome, Edge, Firefox (profils par défaut) |
| 12 | Historique de la barre Exécuter | Clés de registre `RunMRU`, `TypedPaths` |

### Réglages performances (étape 13)

| Réglage | Méthode | Notes |
|---------|---------|-------|
| Plan d'alimentation | `powercfg -setactive SCHEME_MIN` | Active le mode Haute performance |
| Effets visuels | Registre (`VisualFXSetting = 2`) | Réduit les animations |
| Game DVR / App Capture | Registre | Désactive l'enregistrement en arrière-plan |
| TCP auto-tuning | `netsh int tcp` | `autotuninglevel=normal`, RSS activé, chimney désactivé |
| Applications en arrière-plan | Registre (`GlobalUserDisabled = 1`) | Désactive l'activité des apps UWP en arrière-plan |
| Redémarrage d'Explorer | `taskkill /f /im explorer.exe` | Applique les changements de registre liés à l'interface |
| SysMain (Superfetch) | `sc config SysMain start= disabled` | Arrête et désactive le service |
| DiagTrack (télémétrie) | `sc config DiagTrack start= disabled` | Arrête et désactive le service |

---

## Points d'attention

**Journaux d'événements** supprimés intégralement. Si un diagnostic est en cours, exécuter le script après résolution du problème.

**Caches navigateurs** : seuls les profils par défaut sont ciblés. Les profils supplémentaires ne sont pas nettoyés.

**SysMain** (Superfetch) améliore les temps de démarrage sur HDD ; sa désactivation n'a pas d'effet mesurable sur SSD mais est sans danger.

**DiagTrack** réduit la télémétrie envoyée à Microsoft. Aucun impact sur la stabilité du système.

**Redémarrage d'Explorer** ferme et rouvre le shell bureau brièvement. Les fenêtres de l'explorateur ouvertes se ferment le temps de l'opération.

**TCP chimney offload** (`chimney=disabled`) est déprécié depuis Windows 8.1 et n'a aucun effet sur les systèmes modernes ; la commande s'exécute sans erreur mais ne fait rien.

---

## Ce que le script ne fait pas

- Ne désinstalle aucun logiciel
- Ne modifie pas les fichiers ou documents de l'utilisateur
- Ne touche pas aux paramètres du pare-feu ni à la sécurité
- Ne nettoie pas les profils navigateurs au-delà du cache (cookies, mots de passe et historique sont préservés)

---

## Auteur

[ps81frt](https://github.com/ps81frt) — [github.com/ps81frt/win-10-clean](https://github.com/ps81frt/win-10-clean)

---

## Licence

MIT — Copyright (c) 2025 ps81frt
