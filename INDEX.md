# 📑 INDEX DE RESSOURCES - Credit Scoring Application

## 🎯 DÉMARRAGE RAPIDE

### Pour Lancer l'Application
1. Double-cliquez: **[START_ALL.bat](START_ALL.bat)** (batch script)
2. Ou exécutez: **[START_ALL.ps1](START_ALL.ps1)** (PowerShell script)

### Guide de Démarrage Recommandé
Consultez: **[README_SETUP.md](README_SETUP.md)** ← Commencez ici! 🌟

---

## 📚 DOCUMENTATION COMPLÈTE

### Configuration & Environnement
- **[GETTING_STARTED.md](GETTING_STARTED.md)** - Guide complet de démarrage
- **[ENVIRONMENT_SETUP_COMPLETE.md](ENVIRONMENT_SETUP_COMPLETE.md)** - Détails techniques
- **[INSTALLATION.md](INSTALLATION.md)** - Installation détaillée
- **[.env.local](.env.local)** - Variables de configuration
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Structure du projet

### Documentation des Services
- **[backend/README.md](backend/README.md)** - Backend Spring Boot
- **[frontend/README.md](frontend/README.md)** - Frontend Flutter
- **[python-ai/README.md](python-ai/README.md)** - Service Python-AI
- **[database/README.md](database/README.md)** - Configuration MySQL

### Ressources Additionnelles
- **[LICENSE](LICENSE)** - Licence du projet
- **[DEVELOPER_GUIDE.md](docs/DEVELOPER_GUIDE.md)** - Guide développeur

---

## 🛠️ SCRIPTS DE DÉMARRAGE

| Script | Type | Usage | Description |
|--------|------|-------|-------------|
| [START_ALL.bat](START_ALL.bat) | Batch | Double-clic ou `START_ALL.bat` | Menu interactif pour Windows |
| [START_ALL.ps1](START_ALL.ps1) | PowerShell | `.\START_ALL.ps1` | Menu interactif pour Windows (recommandé) |

### Options du Menu
1. **Backend** - Lancer Spring Boot API (port 8080)
2. **Frontend** - Lancer Flutter App
3. **Python-AI** - Lancer Service ML (port 5000)
4. **All Services** - Lancer tous les services en parallèle
5. **Build** - Compiler Backend avec Maven

---

## 📦 STRUCTURE DE L'APPLICATION

```
project/
│
├── 📄 FICHIERS RACINE
│   ├── README.md                         ← Vue d'ensemble
│   ├── README_SETUP.md                   ← 🌟 COMMENCER ICI
│   ├── GETTING_STARTED.md                ← Guide complet
│   ├── INSTALLATION.md                   ← Installation détaillée
│   ├── ENVIRONMENT_SETUP_COMPLETE.md     ← Détails techniques
│   ├── PROJECT_STRUCTURE.md              ← Structure du projet
│   ├── LICENSE                           ← Licence
│   ├── .env.local                        ← Configuration
│   │
│   └── 🚀 SCRIPTS DE DÉMARRAGE
│       ├── START_ALL.bat                 ← Menu Windows (Batch)
│       └── START_ALL.ps1                 ← Menu Windows (PowerShell)
│
├── 📁 backend/
│   ├── README.md                         ← Documentation Backend
│   ├── pom.xml                           ← Configuration Maven
│   ├── src/
│   │   └── main/
│   │       ├── java/                     ← Code source Java
│   │       └── resources/
│   │           └── application.properties ← Config Spring Boot
│   └── target/
│       └── credit-scoring-backend-1.0.0.jar ← 🎯 JAR exécutable
│
├── 📱 frontend/
│   ├── README.md                         ← Documentation Frontend
│   ├── pubspec.yaml                      ← Dépendances Flutter
│   ├── pubspec.lock                      ← Lock file (auto-généré)
│   ├── lib/
│   │   ├── main.dart                     ← Point d'entrée
│   │   ├── config/                       ← Configuration (API, thème)
│   │   ├── models/                       ← Modèles de données
│   │   ├── providers/                    ← State management
│   │   └── screens/                      ← Écrans UI
│   └── pubspec.lock
│
├── 🐍 python-ai/
│   ├── README.md                         ← Documentation Python-AI
│   ├── app.py                            ← Application Flask
│   ├── train_model.py                    ← Entraînement du modèle
│   ├── requirements.txt                  ← Dépendances Python
│   ├── .venv/                            ← Environnement virtuel
│   └── model/                            ← Modèles ML
│
├── 🗄️ database/
│   ├── README.md                         ← Documentation DB
│   ├── schema.sql                        ← Schéma (à importer)
│   └── demo_data.sql                     ← Données de test
│
├── 📧 postman/
│   └── Credit_Scoring_API.postman_collection.json ← Tests API
│
└── 📖 docs/
    ├── DEVELOPER_GUIDE.md                ← Guide développeur
    └── [autres docs]
```

---

## 🚀 DÉMARRAGE PAR ÉTAPES

### Étape 1: Préparation
```bash
# Vérifier les prérequis
java -version        # Java 17
mvn -version         # Maven 3.9.9
flutter doctor       # Flutter SDK
mysql --version      # MySQL 8.0+
```

### Étape 2: Configuration Base de Données (UNE FOIS)
```bash
mysql -u root -p
CREATE DATABASE credit_scoring_db CHARACTER SET utf8mb4;
USE credit_scoring_db;
\. database/schema.sql
\. database/demo_data.sql
```

### Étape 3: Lancer les Services
```bash
# Option A: Automatique
.\START_ALL.bat
# ou
.\START_ALL.ps1

# Option B: Manuel (3 terminaux)
Terminal 1: cd backend && java -jar target/credit-scoring-backend-1.0.0.jar
Terminal 2: cd python-ai && venv\Scripts\activate && python app.py
Terminal 3: cd frontend && flutter run
```

### Étape 4: Accéder à l'Application
- **Frontend**: URL affichée après `flutter run` (généralement http://localhost:port)
- **Backend API**: http://localhost:8080
- **Python-AI API**: http://localhost:5000

### Étape 5: Test
- Importer **postman/Credit_Scoring_API.postman_collection.json**
- Tester les endpoints
- Créer un compte utilisateur
- Soumettre une demande de crédit

---

## 👤 COMPTES DE TEST

| Rôle | Email | Mot de passe | Permissions |
|------|-------|--------------|-------------|
| 👨 USER | user1@example.com | password123 | Soumettre demandes, consulter son historique |
| 🕵️ AGENT | agent1@example.com | password123 | Valider demandes, gérer les validations |
| 👨‍💼 ADMIN | admin1@example.com | password123 | Gestion complète, audit, configuration |

---

## 🔌 ENDPOINTS CLÉS

### Backend (Port 8080)
```
POST   /api/auth/login           - Authentification
POST   /api/credit-requests      - Soumettre une demande
GET    /api/credit-requests      - Lister les demandes
POST   /api/validation-actions   - Valider une demande
GET    /api/admin/audit-logs     - Audit trail (ADMIN)
```

### Python-AI Service (Port 5000)
```
GET    /health                   - Health check
POST   /predict                  - Prédire score de crédit
```

---

## 🔐 INFORMATIONS DE SÉCURITÉ

### Avant la Production
- [ ] Changer les mots de passe par défaut
- [ ] Changer la clé secrète JWT
- [ ] Configurer HTTPS
- [ ] Configurer CORS correctement
- [ ] Mettre à jour les credentials MySQL
- [ ] Sauvegarder les données
- [ ] Configurer les logs
- [ ] Activer l'authentification 2FA (recommandé)

### Variables Importantes
- **JWT Secret**: `application.properties` (backend)
- **DB Password**: `.env.local`
- **API Keys**: À générer selon les besoins
- **CORS Origins**: À configurer dans `application.properties`

---

## 🐛 TROUBLESHOOTING RAPIDE

### "Cannot find JAR file"
```powershell
cd backend
mvn clean install -DskipTests
```

### "Port 8080 déjà utilisé"
```powershell
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### "Flutter not found"
```bash
flutter doctor
flutter pub get
```

### "Database connection failed"
```bash
mysql -u root -p
SHOW DATABASES;
```

---

## 📊 STATUT ACTUEL

✅ **ENVIRONNEMENT:** Entièrement configuré  
✅ **BACKEND:** Compilé et prêt (`credit-scoring-backend-1.0.0.jar`)  
✅ **FRONTEND:** Dépendances installées (75 packages)  
✅ **PYTHON-AI:** Environnement virtuel avec dépendances  
✅ **SCRIPTS:** START_ALL.bat et START_ALL.ps1 prêts  

---

## 📞 SUPPORT

Pour plus d'informations:
- 📖 Consultez **[GETTING_STARTED.md](GETTING_STARTED.md)**
- 🔧 Consultez **[ENVIRONMENT_SETUP_COMPLETE.md](ENVIRONMENT_SETUP_COMPLETE.md)**
- 💻 Consultez **[docs/DEVELOPER_GUIDE.md](docs/DEVELOPER_GUIDE.md)**
- 📋 Consultez les README de chaque service (backend/, frontend/, python-ai/)

---

## 🎯 PROCHAINES ÉTAPES

1. ✅ Lire **[README_SETUP.md](README_SETUP.md)**
2. ✅ Exécuter **START_ALL.bat** ou **START_ALL.ps1**
3. ✅ Configurer la base de données MySQL
4. ✅ Importer la collection Postman
5. ✅ Tester les services
6. ✅ Déployer en production

---

## 📝 NOTES IMPORTANTES

- Assurez-vous que **MySQL est en cours d'exécution** avant de démarrer le Backend
- **JAVA_HOME** doit pointer vers JDK 17
- Les ports **8080** et **5000** doivent être disponibles
- Utilisez les comptes de test fournis pour tester l'application
- Consultez les logs pour identifier les problèmes

---

## 🎉 SUCCÈS!

Votre environnement est maintenant **entièrement configuré et prêt à l'emploi**!

**Prochaine étape:** Exécutez `.\START_ALL.bat` ou `.\START_ALL.ps1`

---

**Mise à jour:** December 18, 2025  
**Statut:** ✅ PRÊT À DÉPLOYER  
**Version:** 1.0.0
