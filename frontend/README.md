# Frontend Flutter - Credit Scoring App

## Description

Application Flutter avec trois interfaces distinctes selon le rôle de l'utilisateur:
- **USER**: Interface simplifiée pour soumettre et consulter ses demandes
- **AGENT**: Interface optimisée pour la validation des demandes
- **ADMIN**: Interface complète pour la gestion du système

## Installation

1. Installer Flutter SDK (3.0+)
2. Installer les dépendances:
```bash
flutter pub get
```

3. Configurer l'URL du backend dans `lib/config/api_config.dart`

4. Lancer l'application:
```bash
flutter run
```

## Structure

- `lib/config/`: Configuration (thème, API)
- `lib/models/`: Modèles de données
- `lib/providers/`: State management (Provider)
- `lib/screens/`: Écrans de l'application
  - `auth/`: Authentification
  - `home/`: Écrans d'accueil par rôle
  - `requests/`: Gestion des demandes
  - `validation/`: Validation (Agent)

## Comptes de Test

- USER: user1@example.com / password123
- AGENT: agent1@example.com / password123
- ADMIN: admin1@example.com / password123

## Build

### Android
```bash
flutter build apk
```

### iOS
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

