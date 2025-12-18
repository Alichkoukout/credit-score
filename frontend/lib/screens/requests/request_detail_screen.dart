import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/api_config.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../models/credit_request.dart';
import 'package:provider/provider.dart';

class RequestDetailScreen extends StatefulWidget {
  final int requestId;

  const RequestDetailScreen({super.key, required this.requestId});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  CreditRequest? _request;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequest();
  }

  Future<void> _loadRequest() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('${ApiConfig.userRequests}/${widget.requestId}'),
        headers: authProvider.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        setState(() {
          _request = CreditRequest.fromJson(jsonDecode(response.body));
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la demande'),
        backgroundColor: AppTheme.primaryColor,
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
                              Chip(
                                label: Text(_request!.status),
                                backgroundColor: _getStatusColor(_request!.status),
                              ),
                              if (_request!.aiScore != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  'Score IA: ${_request!.aiScore!.toStringAsFixed(1)}',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                if (_request!.aiConfidence != null)
                                  Text(
                                    'Confiance: ${(_request!.aiConfidence! * 100).toStringAsFixed(1)}%',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                              ],
                              if (_request!.finalScore != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Score final: ${_request!.finalScore!.toStringAsFixed(1)}',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppTheme.accentColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard('Montant demandé', '${_request!.amountRequested.toStringAsFixed(2)} €'),
                      if (_request!.purpose != null)
                        _buildInfoCard('Objectif', _request!.purpose!),
                      if (_request!.monthlyIncome != null)
                        _buildInfoCard('Revenus mensuels', '${_request!.monthlyIncome!.toStringAsFixed(2)} €'),
                      if (_request!.age != null)
                        _buildInfoCard('Âge', '${_request!.age} ans'),
                      if (_request!.employmentStatus != null)
                        _buildInfoCard('Statut professionnel', _request!.employmentStatus!),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(label),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return AppTheme.warningColor.withOpacity(0.2);
      case 'TREATED':
        return AppTheme.successColor.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }
}

