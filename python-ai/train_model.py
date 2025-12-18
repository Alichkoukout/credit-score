"""
Script d'entraînement du modèle de scoring de crédit
Génère un modèle simple basé sur des données synthétiques
"""

import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
import joblib
import os

def generate_synthetic_data(n_samples=1000):
    """Générer des données synthétiques pour l'entraînement"""
    np.random.seed(42)
    
    data = {
        'monthly_income': np.random.normal(3500, 1500, n_samples),
        'employment_duration_months': np.random.exponential(24, n_samples),
        'current_debt': np.random.exponential(5000, n_samples),
        'credit_history_months': np.random.exponential(36, n_samples),
        'age': np.random.normal(35, 10, n_samples),
        'dependents': np.random.poisson(1, n_samples),
        'property_owned': np.random.choice([0, 1], n_samples, p=[0.6, 0.4]),
        'amount_requested': np.random.exponential(15000, n_samples)
    }
    
    df = pd.DataFrame(data)
    
    # Générer des scores cibles réalistes
    # Score basé sur plusieurs facteurs
    scores = []
    for idx, row in df.iterrows():
        score = 50.0
        
        # Revenus
        if row['monthly_income'] > 4000:
            score += 15
        elif row['monthly_income'] > 3000:
            score += 10
        elif row['monthly_income'] < 2000:
            score -= 10
        
        # Historique de crédit
        if row['credit_history_months'] > 48:
            score += 15
        elif row['credit_history_months'] > 24:
            score += 10
        elif row['credit_history_months'] < 12:
            score -= 10
        
        # Durée d'emploi
        if row['employment_duration_months'] > 36:
            score += 10
        elif row['employment_duration_months'] < 6:
            score -= 10
        
        # Dette
        debt_ratio = row['current_debt'] / max(row['monthly_income'], 1)
        if debt_ratio < 0.2:
            score += 10
        elif debt_ratio > 0.6:
            score -= 15
        
        # Propriété
        if row['property_owned'] == 1:
            score += 5
        
        # Âge
        if 30 <= row['age'] <= 50:
            score += 5
        
        # Normaliser entre 0 et 100
        score = max(0, min(100, score))
        scores.append(score / 100.0)  # Normaliser entre 0 et 1
    
    df['target_score'] = scores
    return df

def train_model():
    """Entraîner le modèle"""
    print("Génération des données synthétiques...")
    df = generate_synthetic_data(2000)
    
    print("Préparation des features...")
    features = ['monthly_income', 'employment_duration_months', 'current_debt',
                'credit_history_months', 'age', 'dependents', 'property_owned',
                'amount_requested']
    
    X = df[features].values
    y = df['target_score'].values
    
    # Normaliser les features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    
    # Diviser en train/test
    X_train, X_test, y_train, y_test = train_test_split(
        X_scaled, y, test_size=0.2, random_state=42
    )
    
    print("Entraînement du modèle...")
    model = RandomForestRegressor(n_estimators=100, random_state=42, max_depth=10)
    model.fit(X_train, y_train)
    
    # Évaluer
    train_score = model.score(X_train, y_train)
    test_score = model.score(X_test, y_test)
    
    print(f"Score d'entraînement: {train_score:.4f}")
    print(f"Score de test: {test_score:.4f}")
    
    # Sauvegarder le modèle
    os.makedirs('model', exist_ok=True)
    model_path = 'model/credit_scoring_model.pkl'
    
    joblib.dump({
        'model': model,
        'scaler': scaler,
        'features': features
    }, model_path)
    
    print(f"Modèle sauvegardé dans {model_path}")
    return model, scaler

if __name__ == '__main__':
    train_model()
    print("Entraînement terminé avec succès!")

