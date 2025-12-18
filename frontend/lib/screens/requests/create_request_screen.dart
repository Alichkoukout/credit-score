import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/credit_request_provider.dart';
import '../../config/app_theme.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();
  final _employmentDurationController = TextEditingController();
  final _currentDebtController = TextEditingController();
  final _creditHistoryController = TextEditingController();
  final _ageController = TextEditingController();
  final _dependentsController = TextEditingController();
  
  String? _employmentStatus;
  String? _maritalStatus;
  String? _educationLevel;
  bool _propertyOwned = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    _monthlyIncomeController.dispose();
    _employmentDurationController.dispose();
    _currentDebtController.dispose();
    _creditHistoryController.dispose();
    _ageController.dispose();
    _dependentsController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'amountRequested': double.parse(_amountController.text),
      'purpose': _purposeController.text,
      'employmentStatus': _employmentStatus,
      'monthlyIncome': double.parse(_monthlyIncomeController.text),
      'employmentDurationMonths': int.parse(_employmentDurationController.text),
      'currentDebt': double.tryParse(_currentDebtController.text) ?? 0.0,
      'creditHistoryMonths': int.parse(_creditHistoryController.text),
      'age': int.parse(_ageController.text),
      'maritalStatus': _maritalStatus,
      'dependents': int.tryParse(_dependentsController.text) ?? 0,
      'propertyOwned': _propertyOwned,
      'educationLevel': _educationLevel,
    };

    final provider = Provider.of<CreditRequestProvider>(context, listen: false);
    final success = await provider.createRequest(data);

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande créée avec succès')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la création')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Demande'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Informations de base',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Montant demandé (€)',
                  prefixIcon: Icon(Icons.euro),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  if (double.tryParse(value) == null) return 'Nombre invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Objectif du crédit',
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _employmentStatus,
                decoration: const InputDecoration(
                  labelText: 'Statut professionnel',
                  prefixIcon: Icon(Icons.work),
                ),
                items: ['EMPLOYED', 'SELF_EMPLOYED', 'UNEMPLOYED', 'RETIRED']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => setState(() => _employmentStatus = value),
                validator: (value) => value == null ? 'Requis' : null,
              ),
              const SizedBox(height: 24),
              Text(
                'Situation financière',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _monthlyIncomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Revenus mensuels (€)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  if (double.tryParse(value) == null) return 'Nombre invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employmentDurationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Durée d\'emploi (mois)',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  if (int.tryParse(value) == null) return 'Nombre invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentDebtController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Dette actuelle (€)',
                  prefixIcon: Icon(Icons.account_balance_wallet),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditHistoryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Historique de crédit (mois)',
                  prefixIcon: Icon(Icons.history),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  if (int.tryParse(value) == null) return 'Nombre invalide';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Informations personnelles',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Âge',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  if (int.tryParse(value) == null) return 'Nombre invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _maritalStatus,
                decoration: const InputDecoration(
                  labelText: 'Statut marital',
                  prefixIcon: Icon(Icons.favorite),
                ),
                items: ['SINGLE', 'MARRIED', 'DIVORCED', 'WIDOWED']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => setState(() => _maritalStatus = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dependentsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Personnes à charge',
                  prefixIcon: Icon(Icons.family_restroom),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _educationLevel,
                decoration: const InputDecoration(
                  labelText: 'Niveau d\'éducation',
                  prefixIcon: Icon(Icons.school),
                ),
                items: ['HIGH_SCHOOL', 'BACHELOR', 'MASTER', 'PHD']
                    .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (value) => setState(() => _educationLevel = value),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Propriétaire'),
                value: _propertyOwned,
                onChanged: (value) => setState(() => _propertyOwned = value ?? false),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Soumettre la demande'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

