-- ============================================
-- DONNÉES DE DÉMONSTRATION
-- ============================================

USE credit_scoring_db;

-- ============================================
-- UTILISATEURS DE DÉMO
-- Mot de passe pour tous: password123 (hashé avec BCrypt)
-- ============================================

-- Hash BCrypt pour "password123": $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
INSERT INTO users (username, email, password, first_name, last_name, phone, role, is_active) VALUES
-- USERS
('user1', 'user1@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Jean', 'Dupont', '+33123456789', 'USER', TRUE),
('user2', 'user2@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Marie', 'Martin', '+33987654321', 'USER', TRUE),
('user3', 'user3@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Pierre', 'Bernard', '+33555123456', 'USER', TRUE),
('user4', 'user4@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Sophie', 'Dubois', '+33666778899', 'USER', TRUE),

-- AGENTS
('agent1', 'agent1@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Agent', 'Validation', '+33111111111', 'AGENT', TRUE),
('agent2', 'agent2@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Agent', 'Credit', '+33222222222', 'AGENT', TRUE),

-- ADMINS
('admin1', 'admin1@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Admin', 'System', '+33333333333', 'ADMIN', TRUE);

-- ============================================
-- DEMANDES DE CRÉDIT DE DÉMO
-- ============================================

INSERT INTO credit_requests (user_id, request_number, amount_requested, purpose, employment_status, monthly_income, employment_duration_months, current_debt, credit_history_months, age, marital_status, dependents, property_owned, education_level, ai_score, ai_confidence, final_score, status, agent_id, validated_at) VALUES
-- Demandes en attente
(1, 'REQ-2024-001', 15000.00, 'Achat véhicule', 'EMPLOYED', 3500.00, 24, 5000.00, 36, 32, 'MARRIED', 2, TRUE, 'BACHELOR', 72.5, 0.85, NULL, 'PENDING', NULL, NULL),
(2, 'REQ-2024-002', 25000.00, 'Rénovation maison', 'EMPLOYED', 4200.00, 48, 8000.00, 60, 38, 'MARRIED', 1, TRUE, 'MASTER', 68.3, 0.78, NULL, 'PENDING', NULL, NULL),
(3, 'REQ-2024-003', 5000.00, 'Urgence médicale', 'SELF_EMPLOYED', 2800.00, 12, 2000.00, 18, 28, 'SINGLE', 0, FALSE, 'BACHELOR', 55.2, 0.65, NULL, 'PENDING', NULL, NULL),

-- Demandes traitées
(1, 'REQ-2024-004', 10000.00, 'Consommation', 'EMPLOYED', 3000.00, 36, 3000.00, 48, 35, 'SINGLE', 0, FALSE, 'BACHELOR', 75.8, 0.88, 78.0, 'TREATED', 5, NOW() - INTERVAL 2 DAY),
(2, 'REQ-2024-005', 30000.00, 'Achat immobilier', 'EMPLOYED', 5000.00, 60, 15000.00, 72, 42, 'MARRIED', 2, TRUE, 'MASTER', 82.5, 0.92, 85.0, 'TREATED', 5, NOW() - INTERVAL 1 DAY),
(4, 'REQ-2024-006', 8000.00, 'Éducation', 'EMPLOYED', 2500.00, 18, 1000.00, 24, 26, 'SINGLE', 0, FALSE, 'BACHELOR', 65.0, 0.72, 65.0, 'TREATED', 6, NOW() - INTERVAL 3 DAY);

-- ============================================
-- ACTIONS DE VALIDATION
-- ============================================

INSERT INTO validation_actions (request_id, agent_id, ai_score, original_score, final_score, action_type, justification) VALUES
(4, 5, 75.8, 75.8, 78.0, 'MODIFIED', 'Score augmenté car historique de crédit excellent et revenus stables. Client très fiable.'),
(5, 5, 82.5, 82.5, 85.0, 'MODIFIED', 'Score augmenté car propriétaire avec revenus élevés et faible ratio dette/revenu.'),
(6, 6, 65.0, 65.0, 65.0, 'APPROVED', 'Score IA validé. Client jeune mais avec bon profil et objectif éducatif valable.');

-- ============================================
-- EXPLICATIONS IA
-- ============================================

INSERT INTO ai_explanations (request_id, feature_importance, explanation_text, risk_factors, positive_factors) VALUES
(1, '{"monthly_income": 0.25, "credit_history_months": 0.20, "employment_duration_months": 0.15, "current_debt": 0.15, "age": 0.10, "property_owned": 0.10, "education_level": 0.05}', 
'Le score de 72.5 est basé sur un profil solide avec revenus stables et historique de crédit positif. Le ratio dette/revenu est acceptable.', 
'["Dette existante modérée", "Revenus moyens"]', 
'["Historique de crédit positif", "Propriétaire", "Emploi stable"]'),

(2, '{"monthly_income": 0.28, "credit_history_months": 0.22, "employment_duration_months": 0.18, "current_debt": 0.12, "age": 0.08, "property_owned": 0.08, "education_level": 0.04}', 
'Score de 68.3 reflétant un bon profil mais avec une dette existante qui réduit légèrement le score.', 
'["Dette existante", "Montant demandé élevé"]', 
'["Revenus élevés", "Emploi stable long terme", "Propriétaire", "Niveau éducation élevé"]'),

(3, '{"monthly_income": 0.20, "credit_history_months": 0.18, "employment_duration_months": 0.20, "current_debt": 0.15, "age": 0.12, "property_owned": 0.10, "education_level": 0.05}', 
'Score de 55.2 indiquant un profil modéré. Revenus moyens et historique de crédit limité.', 
'["Revenus moyens", "Historique de crédit court", "Non propriétaire", "Emploi récent"]', 
'["Faible dette existante", "Objectif valable (urgence médicale)"]');

-- ============================================
-- CONFIGURATION SYSTÈME
-- ============================================

INSERT INTO system_config (config_key, config_value, description) VALUES
('ai_service_url', 'http://localhost:5000', 'URL du service IA'),
('min_credit_score', '50', 'Score minimum pour approbation automatique'),
('max_credit_amount', '100000', 'Montant maximum de crédit autorisé'),
('auto_approval_threshold', '80', 'Seuil de score pour approbation automatique'),
('system_maintenance_mode', 'false', 'Mode maintenance du système');

-- ============================================
-- NOTIFICATIONS DE DÉMO
-- ============================================

INSERT INTO notifications (user_id, title, message, type, is_read) VALUES
(1, 'Demande traitée', 'Votre demande REQ-2024-004 a été traitée avec succès.', 'SUCCESS', FALSE),
(2, 'Demande traitée', 'Votre demande REQ-2024-005 a été approuvée.', 'SUCCESS', FALSE),
(4, 'Demande traitée', 'Votre demande REQ-2024-006 a été validée.', 'SUCCESS', TRUE);

-- ============================================
-- LOGS D'AUDIT ADMIN
-- ============================================

INSERT INTO admin_audit_log (admin_id, action_type, entity_type, entity_id, description, ip_address) VALUES
(7, 'USER_CREATED', 'users', 1, 'Création utilisateur user1', '192.168.1.100'),
(7, 'USER_SUSPENDED', 'users', 3, 'Suspension temporaire utilisateur', '192.168.1.100'),
(7, 'SYSTEM_CONFIG_UPDATED', 'system_config', 1, 'Mise à jour configuration système', '192.168.1.100');

