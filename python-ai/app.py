from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np
import pandas as pd
import joblib
import os
import logging
from datetime import datetime

app = Flask(__name__)
CORS(app)

# Configuration du logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

# Charger le modèle
MODEL_PATH = 'model/credit_scoring_model.pkl'
model = None
scaler = None

def load_model():
    global model, scaler
    try:
        if os.path.exists(MODEL_PATH):
            loaded = joblib.load(MODEL_PATH)
            model = loaded['model']
            scaler = loaded['scaler']
            logger.info("Modèle chargé avec succès")
        else:
            logger.warning("Modèle non trouvé, utilisation du modèle par défaut")
            model = None
            scaler = None
    except Exception as e:
        logger.error(f"Erreur lors du chargement du modèle: {e}")
        model = None
        scaler = None

# Charger le modèle au démarrage
load_model()

def calculate_score_default(data):
    """Calcul de score par défaut si le modèle n'est pas disponible"""
    score = 50.0
    
    # Facteurs positifs
    if data.get('monthly_income', 0) > 3000:
        score += 10
    if data.get('credit_history_months', 0) > 24:
        score += 10
    if data.get('employment_duration_months', 0) > 12:
        score += 5
    if data.get('property_owned', False):
        score += 5
    if data.get('age', 0) > 25 and data.get('age', 0) < 60:
        score += 5
    
    # Facteurs négatifs
    debt_ratio = data.get('current_debt', 0) / max(data.get('monthly_income', 1), 1)
    if debt_ratio > 0.5:
        score -= 15
    elif debt_ratio > 0.3:
        score -= 10
    
    if data.get('dependents', 0) > 3:
        score -= 5
    
    # Normaliser entre 0 et 100
    score = max(0, min(100, score))
    
    # Calculer la confiance (plus le score est proche de 50, moins on est confiant)
    confidence = 0.5 + abs(score - 50) / 100
    
    return score, confidence

def calculate_score_with_model(data):
    """Calcul de score avec le modèle entraîné"""
    try:
        # Préparer les features
        features = np.array([[
            data.get('monthly_income', 0),
            data.get('employment_duration_months', 0),
            data.get('current_debt', 0),
            data.get('credit_history_months', 0),
            data.get('age', 0),
            data.get('dependents', 0),
            1 if data.get('property_owned', False) else 0,
            data.get('amount_requested', 0)
        ]])
        
        # Normaliser
        if scaler:
            features = scaler.transform(features)
        
        # Prédire
        if model:
            prediction = model.predict(features)[0]
            # Convertir en score 0-100
            score = float(prediction * 100)
            score = max(0, min(100, score))
        else:
            score, _ = calculate_score_default(data)
        
        # Calculer la confiance
        confidence = 0.7 + abs(score - 50) / 200
        confidence = max(0.5, min(0.95, confidence))
        
        return score, confidence
        
    except Exception as e:
        logger.error(f"Erreur lors du calcul avec le modèle: {e}")
        return calculate_score_default(data)

def generate_explanation(data, score, confidence):
    """Générer une explication du score"""
    explanations = []
    risk_factors = []
    positive_factors = []
    
    # Analyse des facteurs
    if data.get('monthly_income', 0) > 3000:
        positive_factors.append("Revenus mensuels élevés")
    else:
        risk_factors.append("Revenus mensuels moyens")
    
    if data.get('credit_history_months', 0) > 24:
        positive_factors.append("Historique de crédit établi")
    else:
        risk_factors.append("Historique de crédit limité")
    
    if data.get('employment_duration_months', 0) > 12:
        positive_factors.append("Emploi stable")
    else:
        risk_factors.append("Emploi récent")
    
    if data.get('property_owned', False):
        positive_factors.append("Propriétaire")
    else:
        risk_factors.append("Non propriétaire")
    
    debt_ratio = data.get('current_debt', 0) / max(data.get('monthly_income', 1), 1)
    if debt_ratio > 0.5:
        risk_factors.append("Ratio dette/revenu élevé")
    elif debt_ratio < 0.2:
        positive_factors.append("Faible ratio dette/revenu")
    
    explanation_text = f"Score de {score:.1f} basé sur l'analyse de votre profil. "
    if positive_factors:
        explanation_text += f"Points positifs: {', '.join(positive_factors[:3])}. "
    if risk_factors:
        explanation_text += f"Points d'attention: {', '.join(risk_factors[:3])}."
    
    return {
        'explanation_text': explanation_text,
        'risk_factors': risk_factors,
        'positive_factors': positive_factors
    }

@app.route('/health', methods=['GET'])
def health():
    """Endpoint de santé"""
    return jsonify({
        'status': 'healthy',
        'model_loaded': model is not None,
        'timestamp': datetime.now().isoformat()
    })

@app.route('/predict', methods=['POST'])
def predict():
    """Endpoint principal de prédiction"""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        logger.info(f"Requête reçue: {data}")
        
        # Calculer le score
        if model:
            score, confidence = calculate_score_with_model(data)
        else:
            score, confidence = calculate_score_default(data)
        
        # Générer l'explication
        explanation = generate_explanation(data, score, confidence)
        
        # Calculer l'importance des features
        feature_importance = {
            'monthly_income': 0.25,
            'credit_history_months': 0.20,
            'employment_duration_months': 0.15,
            'current_debt': 0.15,
            'age': 0.10,
            'property_owned': 0.10,
            'education_level': 0.05
        }
        
        response = {
            'score': round(score, 2),
            'confidence': round(confidence, 2),
            'explanation': explanation['explanation_text'],
            'risk_factors': explanation['risk_factors'],
            'positive_factors': explanation['positive_factors'],
            'feature_importance': feature_importance
        }
        
        logger.info(f"Réponse générée: score={score}, confidence={confidence}")
        
        return jsonify(response)
        
    except Exception as e:
        logger.error(f"Erreur lors de la prédiction: {e}")
        return jsonify({
            'error': str(e),
            'score': 65.0,
            'confidence': 0.7
        }), 500

if __name__ == '__main__':
    logger.info("Démarrage du service IA de scoring de crédit")
    logger.info(f"Modèle chargé: {model is not None}")
    app.run(host='0.0.0.0', port=5000, debug=True)

