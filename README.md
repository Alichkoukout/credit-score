# Application de Scoring de Crédit Éthique avec IA Explicable

## 📋 Vue d'ensemble

Application professionnelle de scoring de crédit avec système de validation humaine, intégrant une IA explicable pour l'évaluation des demandes de crédit. Le système comprend trois types d'utilisateurs avec des interfaces et permissions distinctes.

## 🏗️ Architecture

- **Backend**: Spring Boot (Java 17+)
- **Frontend**: Flutter (Dart)
- **IA**: Python (Flask, scikit-learn, SHAP)
- **Base de données**: MySQL 8.0+

## 👥 Rôles Utilisateurs

### USER (Utilisateur Normal)
- Soumettre des demandes de scoring
- Consulter son historique personnel
- Voir les résultats détaillés
- Modifier son profil

### AGENT (Agent de Validation)
- Visualiser toutes les demandes soumises
- Valider/modifier les scores avec justification
- Gérer les demandes en attente
- Consulter l'historique de ses validations

### ADMIN (Administrateur Système)
- Gestion complète des utilisateurs (CRUD)
- Monitoring des performances
- Gestion des logs et audit
- Configuration système
- Sauvegardes de base de données

## 📦 Prérequis

### Logiciels requis

1. **Java Development Kit (JDK) 17 ou supérieur**
   - Télécharger depuis: https://adoptium.net/
   - Vérifier: `java -version`

2. **Maven 3.8+**
   - Télécharger depuis: https://maven.apache.org/download.cgi
   - Vérifier: `mvn -version`

3. **MySQL 8.0+**
   - Télécharger depuis: https://dev.mysql.com/downloads/mysql/
   - Vérifier: `mysql --version`

4. **Python 3.9+**
   - Télécharger depuis: https://www.python.org/downloads/
   - Vérifier: `python --version`

5. **Flutter SDK 3.0+**
   - Télécharger depuis: https://flutter.dev/docs/get-started/install
   - Vérifier: `flutter --version`

6. **Git**
   - Télécharger depuis: https://git-scm.com/downloads
   - Vérifier: `git --version`

## 🚀 Installation Manuelle

### Étape 1: Configuration de la Base de Données MySQL

1. **Démarrer MySQL**
   ```bash
   # Windows (si installé comme service, il démarre automatiquement)
   # Sinon, lancer depuis le répertoire d'installation MySQL
   mysqld.exe
   ```

2. **Se connecter à MySQL**
   ```bash
   mysql -u root -p
   ```
   Entrer le mot de passe root quand demandé.

3. **Créer la base de données**
   ```sql
   CREATE DATABASE credit_scoring_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   USE credit_scoring_db;
   ```

4. **Importer le schéma**
   ```bash
   mysql -u root -p credit_scoring_db < database/schema.sql
   ```

5. **Importer les données de démo**
   ```bash
   mysql -u root -p credit_scoring_db < database/demo_data.sql
   ```

6. **Vérifier les utilisateurs de démo créés**
   ```sql
   SELECT username, email, role FROM users;
   ```
   
   Vous devriez voir:
   - `user1@example.com` (USER)
   - `agent1@example.com` (AGENT)
   - `admin1@example.com` (ADMIN)
   
   Tous avec le mot de passe: `password123`

### Étape 2: Configuration du Backend Spring Boot

1. **Naviguer vers le dossier backend**
   ```bash
   cd backend
   ```

2. **Configurer application.properties**
   
   Ouvrir `src/main/resources/application.properties` et modifier:
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/credit_scoring_db?useSSL=false&serverTimezone=UTC
   spring.datasource.username=root
   spring.datasource.password=VOTRE_MOT_DE_PASSE_MYSQL
   ```

3. **Installer les dépendances Maven**
   ```bash
   mvn clean install
   ```

4. **Lancer le backend**
   ```bash
   mvn spring-boot:run
   ```
   
   Le backend sera accessible sur: `http://localhost:8080`
   
   Vérifier que le serveur démarre correctement en consultant les logs.

### Étape 3: Configuration du Module IA Python

1. **Naviguer vers le dossier python-ai**
   ```bash
   cd python-ai
   ```

2. **Créer un environnement virtuel**
   ```bash
   python -m venv venv
   ```

3. **Activer l'environnement virtuel**
   
   **Windows:**
   ```bash
   venv\Scripts\activate
   ```
   
   **Linux/Mac:**
   ```bash
   source venv/bin/activate
   ```

4. **Installer les dépendances**
   ```bash
   pip install -r requirements.txt
   ```

5. **Entraîner le modèle (première fois seulement)**
   ```bash
   python train_model.py
   ```

6. **Lancer le service IA**
   ```bash
   python app.py
   ```
   
   Le service IA sera accessible sur: `http://localhost:5000`

### Étape 4: Configuration du Frontend Flutter

1. **Naviguer vers le dossier frontend**
   ```bash
   cd frontend
   ```

2. **Installer les dépendances Flutter**
   ```bash
   flutter pub get
   ```

3. **Configurer l'URL du backend**
   
   Ouvrir `lib/config/api_config.dart` et vérifier:
   ```dart
   static const String baseUrl = 'http://localhost:8080/api';
   static const String aiServiceUrl = 'http://localhost:5000';
   ```

4. **Lancer l'application**
   ```bash
   flutter run
   ```
   
   Ou pour une plateforme spécifique:
   ```bash
   flutter run -d windows
   flutter run -d chrome
   flutter run -d android
   ```

## 🔐 Comptes de Démonstration

Après l'import des données de démo, vous pouvez vous connecter avec:

| Rôle | Email | Mot de passe | Description |
|------|-------|--------------|-------------|
| USER | user1@example.com | password123 | Utilisateur normal |
| USER | user2@example.com | password123 | Utilisateur normal |
| AGENT | agent1@example.com | password123 | Agent de validation |
| AGENT | agent2@example.com | password123 | Agent de validation |
| ADMIN | admin1@example.com | password123 | Administrateur |

## 📱 Utilisation

### Connexion

1. Lancer l'application Flutter
2. Sélectionner un compte selon le rôle à tester
3. Entrer l'email et le mot de passe
4. L'interface s'adaptera automatiquement selon le rôle

### Workflow de Demande (USER)

1. Se connecter en tant que USER
2. Accéder à "Nouvelle Demande"
3. Remplir le formulaire en plusieurs étapes
4. Soumettre la demande
5. La demande passe en statut "EN ATTENTE"
6. Attendre la validation par un AGENT

### Workflow de Validation (AGENT)

1. Se connecter en tant que AGENT
2. Accéder au tableau de bord des validations
3. Voir les demandes en attente
4. Cliquer sur une demande pour voir les détails
5. Consulter le score suggéré par l'IA
6. Valider ou modifier le score (avec justification obligatoire)
7. La demande passe en statut "TRAITÉ"

### Gestion Système (ADMIN)

1. Se connecter en tant que ADMIN
2. Accéder au dashboard administrateur
3. Gérer les utilisateurs (créer, modifier, suspendre)
4. Consulter les métriques système
5. Voir les logs d'audit
6. Configurer les paramètres système

## 🧪 Tests

### Tests Backend

```bash
cd backend
mvn test
```

### Tests Frontend

```bash
cd frontend
flutter test
```

### Tests IA

```bash
cd python-ai
python -m pytest tests/
```

## 📡 API Endpoints

### Authentification
- `POST /api/auth/login` - Connexion
- `POST /api/auth/register` - Inscription (USER uniquement)
- `POST /api/auth/refresh` - Rafraîchir le token

### USER
- `GET /api/user/profile` - Profil utilisateur
- `PUT /api/user/profile` - Modifier le profil
- `POST /api/user/requests` - Créer une demande
- `GET /api/user/requests` - Historique des demandes
- `GET /api/user/requests/{id}` - Détails d'une demande

### AGENT
- `GET /api/agent/pending-requests` - Demandes en attente
- `GET /api/agent/requests` - Toutes les demandes
- `POST /api/agent/requests/{id}/validate` - Valider une demande
- `GET /api/agent/validation-history` - Historique de validation

### ADMIN
- `GET /api/admin/users` - Liste des utilisateurs
- `POST /api/admin/users` - Créer un utilisateur
- `PUT /api/admin/users/{id}` - Modifier un utilisateur
- `DELETE /api/admin/users/{id}` - Supprimer un utilisateur
- `GET /api/admin/stats` - Statistiques système
- `GET /api/admin/audit-logs` - Logs d'audit

## 🔧 Configuration Avancée

### Changer les ports

**Backend (application.properties):**
```properties
server.port=8080
```

**IA Python (app.py):**
```python
app.run(host='0.0.0.0', port=5000)
```

**Frontend (api_config.dart):**
```dart
static const String baseUrl = 'http://localhost:8080/api';
```

### Configuration CORS

Le backend est configuré pour accepter les requêtes depuis Flutter. Si vous changez le port, modifier `CorsConfig.java`.

## 🐛 Dépannage

### Problème: MySQL ne démarre pas
- Vérifier que le service MySQL est démarré
- Vérifier les logs MySQL
- Vérifier que le port 3306 n'est pas utilisé

### Problème: Backend ne se connecte pas à MySQL
- Vérifier les credentials dans `application.properties`
- Vérifier que la base de données existe
- Vérifier que MySQL écoute sur le port 3306

### Problème: Service IA ne répond pas
- Vérifier que Python 3.9+ est installé
- Vérifier que toutes les dépendances sont installées
- Vérifier les logs dans `python-ai/app.log`

### Problème: Flutter ne se connecte pas au backend
- Vérifier que le backend est lancé
- Vérifier l'URL dans `api_config.dart`
- Vérifier les règles CORS
- Pour Android, utiliser `10.0.2.2` au lieu de `localhost`

### Problème: Erreur de permissions
- Vérifier que l'utilisateur a le bon rôle
- Vérifier les logs backend pour les erreurs d'autorisation
- Vérifier que le token JWT est valide

## 📚 Documentation Supplémentaire

- [Collection Postman](postman/Credit_Scoring_API.postman_collection.json) - Pour tester les API
- [Schéma Base de Données](database/README.md) - Documentation du schéma
- [Guide Développeur](docs/DEVELOPER_GUIDE.md) - Guide pour les développeurs

## 👨‍💻 Équipe de Développement

Projet développé par une équipe de 4 développeurs pour un projet de fin d'année.

## 📄 Licence

Ce projet est un projet académique.

## 🎯 Fonctionnalités Futures

- [ ] Intégration de vraies données bancaires
- [ ] Amélioration du modèle IA avec plus de données
- [ ] Notifications push
- [ ] Export PDF des résultats
- [ ] Dashboard analytics avancé
- [ ] API GraphQL
- [ ] Microservices architecture

