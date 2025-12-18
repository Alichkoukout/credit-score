import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/api_config.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/credit_request_provider.dart';
import '../../models/credit_request.dart';

class ValidateRequestScreen extends StatefulWidget {
  final int requestId;

  const ValidateRequestScreen({super.key, required this.requestId});

  @override
  State<ValidateRequestScreen> createState() => _ValidateRequestScreenState();
}

class _ValidateRequestScreenState extends State<ValidateRequestScreen> {
  CreditRequest? _request;
  bool _isLoading = true;
  final _scoreController = TextEditingController();
  final _justificationController = TextEditingController();
  String _actionType = 'APPROVED';

  @override
  void initState() {
    super.initState();
    _loadRequest();
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _justificationController.dispose();
    super.dispose();
  }

  Future<void> _loadRequest() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('${ApiConfig.agentRequests}/${widget.requestId}'),
        headers: authProvider.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        setState(() {
          _request = CreditRequest.fromJson(jsonDecode(response.body));
          _scoreController.text = _request!.aiScore?.toStringAsFixed(2) ?? '0';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _validateRequest() async {
    if (_justificationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La justification est obligatoire')),
      );
      return;
    }

    final finalScore = double.tryParse(_scoreController.text);
    if (finalScore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Score invalide')),
      );
      return;
    }

    final provider = Provider.of<CreditRequestProvider>(context, listen: false);
    final success = await provider.validateRequest(
      widget.requestId,
      finalScore,
      _justificationController.text,
      _actionType,
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande validée avec succès')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la validation')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Valider la demande'),
        backgroundColor: AppTheme.accentColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _request == null
              ? const Center(child: Text('Demande non trouvée'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _request!.requestNumber,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text('Montant: ${_request!.amountRequested.toStringAsFixed(2)} €'),
                              if (_request!.aiScore != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Score IA suggéré: ${_request!.aiScore!.toStringAsFixed(1)}',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppTheme.secondaryColor,
                                  ),
                                ),
                                if (_request!.aiConfidence != null)
                                  Text(
                                    'Confiance: ${(_request!.aiConfidence! * 100).toStringAsFixed(1)}%',
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Décision de validation',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _actionType,
                        decoration: const InputDecoration(
                          labelText: 'Type d\'action',
                          prefixIcon: Icon(Icons.check_circle),
                        ),
                        items: ['APPROVED', 'REJECTED', 'MODIFIED']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _actionType = value ?? 'APPROVED'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _scoreController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Score final',
                          prefixIcon: Icon(Icons.score),
                          helperText: 'Modifier le score si nécessaire',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requis';
                          final score = double.tryParse(value);
                          if (score == null || score < 0 || score > 100) {
                            return 'Score entre 0 et 100';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _justificationController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Justification *',
                          prefixIcon: Icon(Icons.description),
                          helperText: 'Justification obligatoire pour toute modification',
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _validateRequest,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppTheme.accentColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Valider la demande'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

