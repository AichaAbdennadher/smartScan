# SmartScan

> Assistant Flutter multilingue pour scanner du texte, identifier sa langue, le traduire hors ligne et le lire à voix haute.

[![Flutter](https://img.shields.io/badge/Flutter-stable-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.10%2B-0175C2?logo=dart)](https://dart.dev/)
[![License](https://img.shields.io/badge/license-not%20specified-lightgrey)](#licence)

## Sommaire

- [Présentation](#présentation)
- [Fonctionnalités](#fonctionnalités)
- [Stack technique](#stack-technique)
- [Architecture](#architecture)
- [Installation](#installation)
- [Exécution](#exécution)
- [Configuration](#configuration)
- [Qualité](#qualité)
- [Aperçu](#aperçu)
- [Roadmap](#roadmap)
- [Licence](#licence)

## Présentation

SmartScan est une application Flutter qui transforme une image contenant du texte en résultat exploitable. L’application combine OCR, détection de langue, traduction embarquée, synthèse vocale et historique local dans une interface disponible en français, anglais et arabe.

## Fonctionnalités

- Capture depuis la caméra ou sélection d’une image.
- Reconnaissance de texte avec Google ML Kit.
- Détection automatique de la langue.
- Traduction sur l’appareil vers plusieurs langues prises en charge.
- Lecture audio du texte original ou traduit.
- Historique local des scans et suppression sélective.
- Thème clair/sombre, vibration et préférences persistées.
- Interface localisée en français, anglais et arabe.

## Stack technique

| Domaine | Technologies |
| --- | --- |
| Interface | Flutter, Material 3 |
| Langage | Dart |
| État | Provider |
| OCR et NLP | Google ML Kit |
| Stockage local | SharedPreferences |
| Entrées multimédias | Camera, Image Picker |
| Audio et accessibilité | Flutter TTS, AudioPlayers, Vibration |
| Plateformes | Android, Web, Windows |

## Architecture

```mermaid
flowchart TD
    UI[Écrans Flutter] --> P[Providers]
    P --> S[Services]
    S --> OCR[Google ML Kit]
    S --> Local[Stockage local]
    S --> Media[Caméra, audio et vibration]
    UI --> L10n[Localisations ARB]
```

Le code applicatif est organisé par responsabilité :

```text
lib/
├── l10n/        # Ressources et classes de localisation générées
├── providers/   # État partagé de l’application
├── screens/     # Écrans et flux de navigation
├── services/    # OCR, traduction, stockage et retours multimédias
├── widgets/     # Composants d’interface réutilisables
├── main.dart    # Point d’entrée et composition de l’application
└── types.dart   # Types partagés
```

## Installation

Prérequis :

- Flutter stable compatible avec Dart `^3.10.7`.
- Android Studio et un SDK Android pour la cible Android.
- Un émulateur ou appareil compatible avec la caméra pour tester le scan.

```bash
git clone https://github.com/AichaAbdennadher/smartScan.git
cd smartScan
flutter pub get
```

## Exécution

```bash
flutter devices
flutter run
```

Vérifications locales :

```bash
flutter analyze
flutter test
```

## Configuration

Aucune clé API ni variable d’environnement n’est actuellement requise. Le fichier [`.env.example`](.env.example) documente cette situation et sert de point de départ pour de futures intégrations. Ne commitez jamais un fichier `.env` réel.

Les modèles de traduction Google ML Kit sont utilisés sur l’appareil et peuvent nécessiter un téléchargement initial selon la plateforme et la langue.

## Qualité

Chaque push et chaque pull request vers `main` déclenche automatiquement `flutter analyze` et `flutter test` via GitHub Actions.

## Aperçu

1. Onboarding

<p align="center">
  <img src="https://github.com/user-attachments/assets/3bea7fc7-a5f9-4c66-bb39-a50d01ac8b05" width="259" height="400" alt="01 - Welcome" />
  <img src="https://github.com/user-attachments/assets/a1d760f3-7957-4ce4-b006-6240fae41efe" width="259" height="400" alt="02 - Languages" />
  <img src="https://github.com/user-attachments/assets/b9fb5fce-4aa0-47a3-8056-2a4dccecaaff" width="259" height="400" alt="03 - Camera Translation" />
  <img src="https://github.com/user-attachments/assets/35b118f4-4743-4f66-881f-5ddbc8a81b87" width="259" height="400" alt="04 - Voice Reading" />
  <img src="https://github.com/user-attachments/assets/8495e51a-7b8e-40ba-9413-7c426cf2cb6a" width="259" height="400" alt="05 - Offline Translation" />
</p>

2. Main Interface

<p align="center">
  <img src="https://github.com/user-attachments/assets/1306db20-eac5-4b8d-a4fe-6047ce4c0e26" width="259" height="400" alt="06 - Home" />
  <img src="https://github.com/user-attachments/assets/ae6b55bf-c2eb-436d-97b3-80c055c05ae5" width="259" height="400" alt="07 - About" />
  <img src="https://github.com/user-attachments/assets/cd4597f1-07d0-4100-99ca-7e0dc03c095b" width="259" height="400" alt="12 - Settings" />
</p>

3. Scanner & Translation Results

<p align="center">
  <img src="https://github.com/user-attachments/assets/e80841f4-b908-4a42-9958-8ec4a5ad3a23" width="259" height="400" alt="08 - Scanner" />
  <img src="https://github.com/user-attachments/assets/acc2889b-566a-4d1c-98e5-849ad6220199" width="259" height="400" alt="09 - Scan Results" />
</p>
