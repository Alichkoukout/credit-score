# Guide d'Installation Complet

## Vue d'ensemble

Ce guide vous accompagne étape par étape pour installer et lancer l'application de scoring de crédit.

## Prérequis

### 1. Java Development Kit (JDK) 17+

**Windows:**
1. Télécharger depuis https://adoptium.net/
2. Installer le JDK
3. Vérifier: Ouvrir PowerShell et taper `java -version`

**Configuration des variables d'environnement:**
- Ajouter `JAVA_HOME` pointant vers le dossier d'installation JDK
- Ajouter `%JAVA_HOME%\bin` au PATH

### 2. Maven 3.8+

**Windows:**
1. Télécharger depuis https://maven.apache.org/download.cgi
2. Extraire dans un dossier (ex: `C:\Program Files\Apache\maven`)
3. Vérifier: `mvn -version`

**Configuration:**
- Ajouter `MAVEN_HOME` pointant vers le dossier Maven
- Ajouter `%MAVEN_HOME%\bin` au PATH

### 3. MySQL 8.0+

**Windows:**
1. Télécharger depuis https://dev.mysql.com/downloads/mysql/
2. Installer MySQL Server
3. Noter le mot de passe root
4. Vérifier: `mysql --version`

**Démarrer MySQL:**
- Si installé comme service, il démarre automatiquement
- Sinon, lancer depuis le répertoire d'installation: `mysqld.exe`

### 4. Python 3.9+

**Windows:**
1. Télécharger depuis https://www.python.org/downloads/
2. Installer en cochant "Add Python to PATH"
3. Vérifier: `python --version`

### 5. Flutter SDK 3.0+

**Windows:**
1. Télécharger depuis https://flutter.dev/docs/get-started/install/windows
2. Extraire dans un dossier (ex: `C:\src\flutter`)
3. Ajouter `C:\src\flutter\bin` au PATH
4. Vérifier: `flutter --version`
5. Lancer: `flutter doctor` pour vérifier la configuration

## Installation Étape par Étape

### Étape 1: Base de Données MySQL

1. **Démarrer MySQL:**
   ```bash
   # Si MySQL est un service, il démarre automatiquement
   # Sinon, naviguer vers le dossier d'installation et lancer:
   mysqld.exe
   ```

2. **Se connecter à MySQL:**
   ```bash
   mysql -u root -p
   ```
   Entrer le mot de passe root.

3. **Créer la base de données:**
   ```sql
   CREATE DATABASE credit_scoring_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   USE credit_scoring_db;
   ```

4. **Importer le schéma:**
   ```bash
   # Depuis le dossier racine du projet
   mysql -u root -p credit_scoring_db < database/schema.sql
   ```

5. **Importer les données de démo:**
   ```bash
   mysql -u root -p credit_scoring_db < database/demo_data.sql
   ```

6. **Vérifier:**
   ```sql
   SELECT username, email, role FROM users;
   ```
   Vous devriez voir les utilisateurs de démo.

### Étape 2: Backend Spring Boot

1. **Naviguer vers le dossier backend:**
   ```bash
   cd backend
   ```

2. **Configurer application.properties:**
   
   Ouvrir `src/main/resources/application.properties`
   
   Modifier ces lignes:
   ```properties
   spring.datasource.username=root
   spring.datasource.password=VOTRE_MOT_DE_PASSE_MYSQL
   ```

3. **Installer les dépendances:**
   ```bash
   mvn clean install
   ```
   Cette commande peut prendre plusieurs minutes la première fois.

4. **Lancer le backend:**
   ```bash
   mvn spring-boot:run
   ```

5. **Vérifier:**
   - Ouvrir un navigateur: `http://localhost:8080`
   - Vous devriez voir une page d'erreur (normal, pas de route racine)
   - Les logs doivent indiquer que le serveur démarre

### Étape 3: Module IA Python

1. **Naviguer vers le dossier python-ai:**
   ```bash
   cd python-ai
   ```

2. **Créer un environnement virtuel:**
   ```bash
   python -m venv venv
   ```

3. **Activer l'environnement virtuel:**
   ```bash
   # Windows PowerShell
   venv\Scripts\Activate.ps1
   
   # Windows CMD
   venv\Scripts\activate.bat
   ```

4. **Installer les dépendances:**
   ```bash
   pip install -r requirements.txt
   ```

5. **Entraîner le modèle (première fois):**
   ```bash
   python train_model.py
   ```
   Cela crée le dossier `model/` avec le modèle entraîné.

6. **Lancer le service IA:**
   ```bash
   python app.py
   ```

7. **Vérifier:**
   - Ouvrir: `http://localhost:5000/health`
   - Vous devriez voir: `{"status": "healthy", ...}`

### Étape 4: Frontend Flutter

1. **Naviguer vers le dossier frontend:**
   ```bash
   cd frontend
   ```

2. **Installer les dépendances:**
   ```bash
   flutter pub get
   ```

3. **Vérifier la configuration:**
   
   Ouvrir `lib/config/api_config.dart` et vérifier:
   ```dart
   static const String baseUrl = 'http://localhost:8080/api';
   static const String aiServiceUrl = 'http://localhost:5000';
   ```

4. **Lancer l'application:**
   ```bash
   flutter run
   ```
   
   Ou pour une plateforme spécifique:
   ```bash
   flutter run -d windows
   flutter run -d chrome
   flutter run -d android
   ```

## Vérification Complète

### 1. Tester le Backend

Ouvrir Postman et importer la collection:
- `postman/Credit_Scoring_API.postman_collection.json`

Tester l'endpoint de login:
- POST `http://localhost:8080/api/auth/login`
- Body: `{"email": "user1@example.com", "password": "password123"}`

### 2. Tester le Service IA

```bash
curl http://localhost:5000/health
```

### 3. Tester le Frontend

1. Lancer l'application Flutter
2. Se connecter avec:
   - Email: `user1@example.com`
   - Password: `password123`
3. Vérifier que l'interface USER s'affiche

## Ordre de Démarrage

Pour lancer l'application complète:

1. **MySQL** (doit être démarré)
2. **Backend Spring Boot** (port 8080)
3. **Service IA Python** (port 5000)
4. **Frontend Flutter**

## Dépannage

### MySQL ne démarre pas
- Vérifier que le service MySQL est démarré
- Vérifier les logs MySQL
- Vérifier que le port 3306 n'est pas utilisé

### Backend ne se connecte pas à MySQL
- Vérifier les credentials dans `application.properties`
- Vérifier que la base de données existe
- Vérifier que MySQL écoute sur le port 3306

### Service IA ne répond pas
- Vérifier que Python 3.9+ est installé
- Vérifier que toutes les dépendances sont installées
- Vérifier les logs dans `python-ai/app.log`

### Flutter ne se connecte pas au backend
- Vérifier que le backend est lancé
- Vérifier l'URL dans `api_config.dart`
- Pour Android, utiliser `10.0.2.2` au lieu de `localhost`

## Support

En cas de problème, consulter:
- `README.md` - Documentation principale
- `docs/DEVELOPER_GUIDE.md` - Guide développeur
- Logs dans chaque composant

