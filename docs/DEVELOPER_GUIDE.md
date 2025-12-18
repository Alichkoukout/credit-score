# Guide du Développeur

## Architecture du Projet

### Backend (Spring Boot)

Structure:
```
backend/
├── src/main/java/com/creditscoring/
│   ├── entity/          # Entités JPA
│   ├── repository/      # Repositories Spring Data
│   ├── service/         # Logique métier
│   ├── controller/      # Contrôleurs REST
│   ├── dto/             # Data Transfer Objects
│   └── security/        # Configuration sécurité
└── src/main/resources/
    └── application.properties
```

### Frontend (Flutter)

Structure:
```
frontend/
├── lib/
│   ├── config/          # Configuration
│   ├── models/          # Modèles de données
│   ├── providers/       # State management
│   ├── screens/         # Écrans de l'application
│   │   ├── auth/        # Authentification
│   │   ├── home/        # Écrans d'accueil par rôle
│   │   ├── requests/    # Gestion des demandes
│   │   └── validation/  # Validation (Agent)
│   └── main.dart
└── pubspec.yaml
```

### Module IA (Python)

Structure:
```
python-ai/
├── app.py              # Application Flask
├── train_model.py      # Script d'entraînement
├── model/              # Modèles sauvegardés
└── requirements.txt
```

## Workflow de Développement

### 1. Backend

**Créer une nouvelle entité:**
1. Créer la classe dans `entity/`
2. Créer le repository dans `repository/`
3. Créer le service dans `service/`
4. Créer le DTO dans `dto/`
5. Créer le contrôleur dans `controller/`

**Ajouter un endpoint:**
1. Définir dans le contrôleur approprié
2. Ajouter la logique dans le service
3. Tester avec Postman

### 2. Frontend

**Créer un nouvel écran:**
1. Créer le fichier dans `screens/`
2. Ajouter la route si nécessaire
3. Créer le provider si besoin de state management
4. Tester la navigation

**Ajouter une fonctionnalité:**
1. Créer/modifier le provider
2. Créer/modifier l'écran
3. Tester le flux complet

### 3. Module IA

**Modifier le modèle:**
1. Modifier `train_model.py`
2. Réentraîner: `python train_model.py`
3. Tester avec `app.py`

## Tests

### Backend
```bash
cd backend
mvn test
```

### Frontend
```bash
cd frontend
flutter test
```

### IA
```bash
cd python-ai
python -m pytest tests/
```

## Bonnes Pratiques

1. **Sécurité:**
   - Toujours valider les entrées
   - Utiliser les annotations de validation
   - Vérifier les permissions dans les services

2. **Code:**
   - Suivre les conventions de nommage
   - Commenter le code complexe
   - Gérer les erreurs proprement

3. **Base de données:**
   - Utiliser les transactions pour les opérations critiques
   - Indexer les colonnes fréquemment interrogées
   - Logger les actions importantes

4. **API:**
   - Retourner des codes HTTP appropriés
   - Fournir des messages d'erreur clairs
   - Documenter les endpoints

## Débogage

### Backend
- Vérifier les logs dans `logs/application.log`
- Activer le mode debug dans `application.properties`
- Utiliser Postman pour tester les endpoints

### Frontend
- Utiliser Flutter DevTools
- Vérifier la console pour les erreurs
- Tester sur différentes plateformes

### IA
- Vérifier `app.log`
- Tester avec curl ou Postman
- Vérifier que le modèle est chargé

## Déploiement

### Backend
1. Build: `mvn clean package`
2. Lancer: `java -jar target/credit-scoring-backend-1.0.0.jar`

### Frontend
1. Build: `flutter build apk` (Android) ou `flutter build ios` (iOS)
2. Installer sur l'appareil

### IA
1. Installer les dépendances
2. Entraîner le modèle
3. Lancer avec gunicorn pour la production

