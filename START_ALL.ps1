# Script de démarrage pour tous les services
# Credit Scoring Application - Environment Setup & Start Script

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Credit Scoring Application - Services Setup" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Configuration des variables d'environnement
$JAVA_HOME = "C:\Program Files\Java\jdk-17"
$MAVEN_HOME = "C:\Users\dell\apache-maven-3.9.9"
$env:JAVA_HOME = $JAVA_HOME
$env:MAVEN_HOME = $MAVEN_HOME
$env:PATH = "$JAVA_HOME\bin;$MAVEN_HOME\bin;$env:PATH"

# Vérifier Java et Maven
Write-Host "[1] Vérification des prérequis..." -ForegroundColor Yellow
Write-Host "  Java:" $(java -version 2>&1 | Select-Object -First 1)
Write-Host "  Maven:" $(mvn -version 2>&1 | Select-Object -First 1)
Write-Host ""

# Configuration du projet
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "[2] Répertoire du projet: $projectRoot" -ForegroundColor Yellow
Write-Host ""

# Menu des options
Write-Host "Options de démarrage:" -ForegroundColor Green
Write-Host "  1) Démarrer Backend (Spring Boot)"
Write-Host "  2) Démarrer Frontend (Flutter)"
Write-Host "  3) Démarrer Python-AI Service"
Write-Host "  4) Démarrer TOUS les services"
Write-Host "  5) Construire Backend (Maven build)"
Write-Host ""

$choice = Read-Host "Sélectionnez une option (1-5)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "========== Démarrage du Backend ==========" -ForegroundColor Cyan
        Write-Host ""
        Set-Location "$projectRoot\backend"
        Write-Host "Commande: java -jar target\credit-scoring-backend-1.0.0.jar" -ForegroundColor Yellow
        Write-Host ""
        java -jar target\credit-scoring-backend-1.0.0.jar
    }
    "2" {
        Write-Host ""
        Write-Host "========== Démarrage du Frontend ==========" -ForegroundColor Cyan
        Write-Host ""
        Set-Location "$projectRoot\frontend"
        Write-Host "Commande: flutter run" -ForegroundColor Yellow
        Write-Host ""
        flutter run
    }
    "3" {
        Write-Host ""
        Write-Host "========== Démarrage du Service Python ==========" -ForegroundColor Cyan
        Write-Host ""
        Set-Location "$projectRoot\python-ai"
        Write-Host "Activation de l'environnement virtuel..." -ForegroundColor Yellow
        & ".\venv\Scripts\Activate.ps1"
        Write-Host "Commande: python app.py" -ForegroundColor Yellow
        Write-Host ""
        python app.py
    }
    "4" {
        Write-Host ""
        Write-Host "========== Démarrage de TOUS les services ==========" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Les services vont démarrer dans des terminaux séparés..." -ForegroundColor Yellow
        Write-Host ""
        
        # Backend
        Write-Host "[Service 1/3] Démarrage du Backend..." -ForegroundColor Green
        Start-Process powershell -ArgumentList "-NoExit -Command `"cd '$projectRoot\backend'; `$env:JAVA_HOME='$JAVA_HOME'; `$env:PATH='$JAVA_HOME\bin;`$env:PATH'; java -jar target\credit-scoring-backend-1.0.0.jar`""
        Start-Sleep -Seconds 3
        
        # Python-AI
        Write-Host "[Service 2/3] Démarrage du Service Python-AI..." -ForegroundColor Green
        Start-Process powershell -ArgumentList "-NoExit -Command `"cd '$projectRoot\python-ai'; .\venv\Scripts\Activate.ps1; python app.py`""
        Start-Sleep -Seconds 3
        
        # Frontend
        Write-Host "[Service 3/3] Démarrage du Frontend..." -ForegroundColor Green
        Set-Location "$projectRoot\frontend"
        Write-Host ""
        Write-Host "Démarrage de Flutter..." -ForegroundColor Yellow
        flutter run
    }
    "5" {
        Write-Host ""
        Write-Host "========== Construction du Backend (Maven) ==========" -ForegroundColor Cyan
        Write-Host ""
        Set-Location "$projectRoot\backend"
        Write-Host "Commande: mvn clean install -DskipTests" -ForegroundColor Yellow
        Write-Host ""
        mvn clean install -DskipTests
    }
    default {
        Write-Host "Option invalide!" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Merci d'avoir utilisé le script de démarrage!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
