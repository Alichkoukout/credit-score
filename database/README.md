# Base de Données - Documentation

## Schéma de la Base de Données

### Tables Principales

#### users
Stoque les informations des utilisateurs avec leurs rôles.

**Champs:**
- `id`: Identifiant unique
- `username`: Nom d'utilisateur unique
- `email`: Email unique
- `password`: Mot de passe hashé (BCrypt)
- `first_name`, `last_name`: Prénom et nom
- `phone`: Téléphone
- `role`: Rôle (USER, AGENT, ADMIN)
- `is_active`: Statut actif/inactif
- `created_at`, `updated_at`: Timestamps

#### credit_requests
Stoque les demandes de crédit.

**Champs:**
- `id`: Identifiant unique
- `user_id`: Référence à l'utilisateur
- `request_number`: Numéro unique de demande
- `amount_requested`: Montant demandé
- Informations financières et personnelles
- `ai_score`: Score calculé par l'IA
- `ai_confidence`: Niveau de confiance de l'IA
- `final_score`: Score final après validation
- `status`: Statut (PENDING, PROCESSING, APPROVED, REJECTED, TREATED)
- `agent_id`: Agent qui a validé
- `validated_at`: Date de validation

#### validation_actions
Trace toutes les actions de validation des agents.

**Champs:**
- `id`: Identifiant unique
- `request_id`: Référence à la demande
- `agent_id`: Agent qui a validé
- `ai_score`: Score IA original
- `original_score`: Score avant modification
- `final_score`: Score final
- `action_type`: Type d'action (APPROVED, REJECTED, MODIFIED)
- `justification`: Justification obligatoire
- `created_at`: Timestamp

#### admin_audit_log
Logs d'audit pour les actions administrateurs.

**Champs:**
- `id`: Identifiant unique
- `admin_id`: Administrateur
- `action_type`: Type d'action
- `entity_type`: Type d'entité concernée
- `entity_id`: ID de l'entité
- `description`: Description
- `ip_address`: Adresse IP
- `user_agent`: User agent
- `created_at`: Timestamp

#### ai_explanations
Explications générées par l'IA.

**Champs:**
- `id`: Identifiant unique
- `request_id`: Référence à la demande
- `feature_importance`: Importance des features (JSON)
- `explanation_text`: Texte d'explication
- `risk_factors`: Facteurs de risque (JSON)
- `positive_factors`: Facteurs positifs (JSON)

## Installation

1. Créer la base de données:
```sql
mysql -u root -p < schema.sql
```

2. Importer les données de démo:
```sql
mysql -u root -p credit_scoring_db < demo_data.sql
```

## Comptes de Démo

Tous les comptes utilisent le mot de passe: `password123`

- **USER**: user1@example.com, user2@example.com
- **AGENT**: agent1@example.com, agent2@example.com
- **ADMIN**: admin1@example.com

## Relations

- `credit_requests.user_id` → `users.id`
- `credit_requests.agent_id` → `users.id`
- `validation_actions.request_id` → `credit_requests.id`
- `validation_actions.agent_id` → `users.id`
- `admin_audit_log.admin_id` → `users.id`
- `ai_explanations.request_id` → `credit_requests.id`

