# Structure du Projet

## Vue d'ensemble

```
project/
├── backend/                 # Backend Spring Boot
│   ├── src/
│   │   └── main/
│   │       ├── java/com/creditscoring/
│   │       │   ├── entity/          # Entités JPA
│   │       │   ├── repository/      # Repositories
│   │       │   ├── service/         # Services métier
│   │       │   ├── controller/      # Contrôleurs REST
│   │       │   ├── dto/             # DTOs
│   │       │   └── security/        # Sécurité JWT
│   │       └── resources/
│   │           └── application.properties
│   ├── pom.xml
│   └── README.md
│
├── frontend/                # Frontend Flutter
│   ├── lib/
│   │   ├── config/          # Configuration
│   │   ├── models/          # Modèles
│   │   ├── providers/       # State management
│   │   ├── screens/         # Écrans
│   │   │   ├── auth/        # Authentification
│   │   │   ├── home/        # Accueil par rôle
│   │   │   │   ├── user/    # Interface USER
│   │   │   │   ├── agent/   # Interface AGENT
│   │   │   │   └── admin/   # Interface ADMIN
│   │   │   ├── requests/    # Demandes
│   │   │   └── validation/ # Validation
│   │   └── main.dart
│   ├── pubspec.yaml
│   └── README.md
│
├── python-ai/               # Module IA Python
│   ├── app.py               # Application Flask
│   ├── train_model.py       # Entraînement modèle
│   ├── requirements.txt
│   ├── model/               # Modèles sauvegardés (généré)
│   └── README.md
│
├── database/                # Scripts SQL
│   ├── schema.sql           # Schéma de base
│   ├── demo_data.sql        # Données de démo
│   └── README.md
│
├── postman/                 # Collection Postman
│   └── Credit_Scoring_API.postman_collection.json
│
├── docs/                    # Documentation
│   └── DEVELOPER_GUIDE.md
│
├── README.md                # Documentation principale
├── INSTALLATION.md          # Guide d'installation
├── LICENSE
└── .gitignore
```

## Composants

### Backend (Spring Boot)
- **Port**: 8080
- **Technologies**: Spring Boot, Spring Security, JWT, JPA, MySQL
- **Rôles**: USER, AGENT, ADMIN avec permissions granulaires

### Frontend (Flutter)
- **Plateformes**: Android, iOS, Web, Windows
- **State Management**: Provider
- **3 Interfaces distinctes** selon le rôle

### Module IA (Python Flask)
- **Port**: 5000
- **Technologies**: Flask, scikit-learn, SHAP
- **Fonctionnalités**: Scoring, explications, confiance

### Base de Données (MySQL)
- **Base**: credit_scoring_db
- **Tables**: users, credit_requests, validation_actions, admin_audit_log, ai_explanations

## Workflow

1. **USER** soumet une demande → Statut: PENDING
2. **IA** calcule un score → Score IA + Confiance
3. **AGENT** valide/modifie → Statut: TREATED
4. **USER** consulte le résultat final
5. **ADMIN** peut tout monitorer

## Points d'Entrée

- **Backend API**: http://localhost:8080/api
- **Service IA**: http://localhost:5000
- **Frontend**: Application Flutter

## Fichiers Clés

### Configuration Backend
- `backend/src/main/resources/application.properties`

### Configuration Frontend
- `frontend/lib/config/api_config.dart`
- `frontend/lib/config/app_theme.dart`

### Base de Données
- `database/schema.sql`
- `database/demo_data.sql`

## Comptes de Démo

Tous avec mot de passe: `password123`

- **USER**: user1@example.com, user2@example.com
- **AGENT**: agent1@example.com, agent2@example.com
- **ADMIN**: admin1@example.com

