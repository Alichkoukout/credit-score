# Guide de Démarrage - Credit Scoring Application

## 📋 Statut de l'Environnement

✅ **Environnements Configurés:**
- Backend Java 17 avec Maven 3.9.9
- Frontend Flutter avec dépendances résolues
- Python-AI avec environnement virtuel et dépendances
- Base de données MySQL 8.0+

---

## 🚀 Démarrage des Services

### Option 1: Démarrage Automatisé (Recommandé)

Utilisez le script PowerShell fourni:

```powershell
# Depuis le répertoire racine du projet
.\START_ALL.ps1
```

Le script offre 5 options:
1. **Démarrer Backend** - Lancer Spring Boot API
2. **Démarrer Frontend** - Lancer Flutter App
3. **Démarrer Python-AI** - Lancer le service de prédiction
4. **Démarrer TOUS** - Lancer tous les services en parallèle
5. **Build Backend** - Compiler avec Maven

### Option 2: Démarrage Manuel

#### A) Démarrage du Backend (Spring Boot)

```powershell
# Définir les variables d'environnement
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"
$env:MAVEN_HOME = "C:\Users\dell\apache-maven-3.9.9"

# Naviguer au répertoire backend
cd .\backend

# Lancer l'application
java -jar target\credit-scoring-backend-1.0.0.jar

# OU utiliser Maven
mvn spring-boot:run
```

**URL de l'API:** `http://localhost:8081`

#### B) Démarrage du Frontend (Flutter)

```powershell
# Naviguer au répertoire frontend
cd .\frontend

# Installer les dépendances (si nécessaire)
flutter pub get

# Lancer l'application
flutter run
```

**Plateforme cible:** Windows, Android, iOS (à sélectionner)

#### C) Démarrage du Service Python-AI

```powershell
# Naviguer au répertoire python-ai
cd .\python-ai

# Activer l'environnement virtuel
.\venv\Scripts\Activate.ps1

# Lancer le service
python app.py
```

**URL du Service:** `http://localhost:5000`

---

## 🗄️ Configuration de la Base de Données

### 1. Créer la Base de Données

```bash
mysql -u root -p
```

Puis exécuter:

```sql
CREATE DATABASE credit_scoring_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE credit_scoring_db;
```

### 2. Importer le Schéma

```bash
mysql -u root -p credit_scoring_db < database/schema.sql
```

### 3. Importer les Données de Démo

```bash
mysql -u root -p credit_scoring_db < database/demo_data.sql
```

### 4. Vérifier l'Installation

```sql
SELECT username, email, role FROM users;
```

---

## 👤 Comptes de Test

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| USER | user1@example.com | password123 |
| AGENT | agent1@example.com | password123 |
| ADMIN | admin1@example.com | password123 |

---

## 🔍 Vérification des Services

### Backend Health Check

```bash
curl http://localhost:8080/health
```

### Python-AI Health Check

```bash
curl http://localhost:5000/health
```

### Frontend
Accédez à l'application Flutter sur le port indiqué après le démarrage.

---

## 📦 Gestion des Dépendances

### Backend (Maven)
```powershell
# Nettoyer et installer
mvn clean install

# Mettre à jour les dépendances
mvn dependency:tree
```

### Frontend (Flutter/Dart)
```bash
# Obtenir les dépendances
flutter pub get

# Mettre à jour les dépendances
flutter pub upgrade

# Analyser les dépendances
flutter pub outdated
```

### Python-AI
```bash
# Activer l'environnement
.\venv\Scripts\Activate.ps1

# Lister les dépendances
pip list

# Mettre à jour les dépendances
pip install --upgrade -r requirements.txt

# Installer des dépendances supplémentaires
pip install package_name
```

---

## 🛠️ Troubleshooting

### Le Backend ne démarre pas

1. **Vérifier Java:** 
   ```bash
   java -version
   ```

2. **Vérifier la base de données:**
   ```bash
   mysql -u root -p
   SHOW DATABASES;
   ```

3. **Vérifier le port 8080:**
   ```powershell
   netstat -ano | findstr :8080
   ```

### Le Frontend n'affiche pas les données

1. **Vérifier que le Backend est en cours d'exécution**
2. **Vérifier la configuration API:** `lib/config/api_config.dart`
3. **Redémarrer l'application Flutter**

### Le Service Python-AI ne répond pas

1. **Vérifier l'environnement virtuel:**
   ```bash
   .\venv\Scripts\Activate.ps1
   ```

2. **Réinstaller les dépendances:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Entraîner le modèle:**
   ```bash
   python train_model.py
   ```

---

## 📁 Structure du Projet

```
project/
├── backend/                   # Spring Boot API
│   ├── src/main/java/        # Code source
│   ├── pom.xml               # Configuration Maven
│   └── target/               # Artefacts compilés
├── frontend/                 # Application Flutter
│   ├── lib/                  # Code source Flutter
│   └── pubspec.yaml          # Configuration Flutter
├── python-ai/                # Service IA
│   ├── venv/                 # Environnement virtuel
│   ├── app.py                # Application Flask
│   └── requirements.txt       # Dépendances Python
├── database/                 # Scripts SQL
│   ├── schema.sql            # Schéma de base de données
│   └── demo_data.sql         # Données de test
└── docs/                     # Documentation
```

---

## 📚 Ressources Utiles

- **Backend Documentation:** [Spring Boot](https://spring.io/projects/spring-boot)
- **Frontend Documentation:** [Flutter](https://flutter.dev)
- **Python ML:** [scikit-learn](https://scikit-learn.org), [SHAP](https://shap.readthedocs.io)
- **Database:** [MySQL](https://dev.mysql.com)

---

## ✅ Checklist de Vérification

- [ ] Java JDK 17 installé et configuré
- [ ] Maven 3.9.9 installé et configuré
- [ ] MySQL 8.0+ en cours d'exécution
- [ ] Base de données créée et schéma importé
- [ ] Backend compilé avec succès (`mvn clean install`)
- [ ] Frontend dépendances installées (`flutter pub get`)
- [ ] Python-AI environnement virtuel créé avec dépendances
- [ ] Port 8080 disponible pour le Backend
- [ ] Port 5000 disponible pour Python-AI
- [ ] Backend API répond aux requêtes
- [ ] Service Python-AI répond aux requêtes

---

## 🎉 Prêt à Lancer!

Tous les services sont maintenant configurés et prêts à être démarrés. Utilisez le script `START_ALL.ps1` pour un démarrage facile!

```powershell
.\START_ALL.ps1
```

Pour toute question ou problème, consultez les fichiers README dans chaque dossier de service.
