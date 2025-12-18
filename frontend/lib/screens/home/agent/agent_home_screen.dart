import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/credit_request_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../config/app_theme.dart';
import '../../../models/credit_request.dart';
import '../../requests/request_detail_screen.dart';
import '../../validation/validate_request_screen.dart';

class AgentHomeScreen extends StatefulWidget {
  const AgentHomeScreen({super.key});

  @override
  State<AgentHomeScreen> createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CreditRequestProvider>(context, listen: false);
      provider.fetchPendingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation des Demandes'),
        backgroundColor: AppTheme.accentColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildPendingRequests() : _buildAllRequests(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          final provider = Provider.of<CreditRequestProvider>(context, listen: false);
          if (index == 0) {
            provider.fetchPendingRequests();
          } else {
            provider.fetchAllRequests();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'En attente',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Toutes',
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRequests() {
    return Consumer<CreditRequestProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final pendingRequests = provider.requests.where((r) => r.isPending).toList();

        if (pendingRequests.isEmpty) {
          return const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Aucune demande en attente'),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pendingRequests.length,
          itemBuilder: (context, index) {
            final request = pendingRequests[index];
            return _buildRequestCard(request, isPending: true);
          },
        );
      },
    );
  }

  Widget _buildAllRequests() {
    return Consumer<CreditRequestProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.requests.isEmpty) {
          return const Center(
            child: Text('Aucune demande'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.requests.length,
          itemBuilder: (context, index) {
            final request = provider.requests[index];
            return _buildRequestCard(request, isPending: false);
          },
        );
      },
    );
  }

  Widget _buildRequestCard(CreditRequest request, {required bool isPending}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (isPending) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ValidateRequestScreen(requestId: request.id),
              ),
            ).then((_) {
              Provider.of<CreditRequestProvider>(context, listen: false)
                  .fetchPendingRequests();
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RequestDetailScreen(requestId: request.id),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    request.requestNumber,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Chip(
                    label: Text(request.status),
                    backgroundColor: _getStatusColor(request.status),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Montant: ${request.amountRequested.toStringAsFixed(2)} €',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (request.aiScore != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Score IA: ${request.aiScore!.toStringAsFixed(1)} (Confiance: ${(request.aiConfidence ?? 0) * 100}%)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (request.user != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Client: ${request.user!.fullName}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (isPending) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ValidateRequestScreen(requestId: request.id),
                        ),
                      ).then((_) {
                        Provider.of<CreditRequestProvider>(context, listen: false)
                            .fetchPendingRequests();
                      });
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Valider'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
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
      case 'APPROVED':
        return AppTheme.accentColor.withOpacity(0.2);
      case 'REJECTED':
        return AppTheme.errorColor.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }
}

