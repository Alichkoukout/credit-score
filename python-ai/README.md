# Module IA - Scoring de Crédit

## Description

Service Python Flask qui fournit des prédictions de scoring de crédit avec explications.

## Installation

1. Créer un environnement virtuel:
```bash
python -m venv venv
```

2. Activer l'environnement:
- Windows: `venv\Scripts\activate`
- Linux/Mac: `source venv/bin/activate`

3. Installer les dépendances:
```bash
pip install -r requirements.txt
```

4. Entraîner le modèle (première fois):
```bash
python train_model.py
```

## Lancement

```bash
python app.py
```

Le service sera accessible sur `http://localhost:5000`

## Endpoints

- `GET /health` - Vérifier l'état du service
- `POST /predict` - Calculer un score de crédit

### Exemple de requête POST /predict

```json
{
  "amount_requested": 15000,
  "monthly_income": 3500,
  "employment_duration_months": 24,
  "current_debt": 5000,
  "credit_history_months": 36,
  "age": 32,
  "dependents": 2,
  "property_owned": true
}
```

### Exemple de réponse

```json
{
  "score": 72.5,
  "confidence": 0.85,
  "explanation": "Score de 72.5 basé sur...",
  "risk_factors": ["..."],
  "positive_factors": ["..."],
  "feature_importance": {...}
}
```

