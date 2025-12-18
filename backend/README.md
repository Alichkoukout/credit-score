# Backend Spring Boot - Credit Scoring API

## Description

API REST sécurisée avec Spring Boot pour la gestion du scoring de crédit.

## Installation

1. Prérequis:
   - Java 17+
   - Maven 3.8+
   - MySQL 8.0+

2. Configuration:
   - Modifier `src/main/resources/application.properties`
   - Configurer les credentials MySQL

3. Build:
```bash
mvn clean install
```

4. Lancer:
```bash
mvn spring-boot:run
```

L'API sera accessible sur `http://localhost:8080`

## Structure

- `entity/`: Entités JPA
- `repository/`: Repositories Spring Data
- `service/`: Logique métier
- `controller/`: Contrôleurs REST
- `dto/`: Data Transfer Objects
- `security/`: Configuration sécurité (JWT, Spring Security)

## Endpoints

Voir la collection Postman pour tous les endpoints disponibles.

## Sécurité

- Authentification JWT
- Rôles: USER, AGENT, ADMIN
- Permissions granulaires par endpoint
- Audit trail pour les actions admin

## Tests

```bash
mvn test
```

