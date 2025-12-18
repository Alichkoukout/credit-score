import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/credit_request_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../config/app_theme.dart';
import '../../../models/credit_request.dart';
import '../../requests/create_request_screen.dart';
import '../../requests/request_detail_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CreditRequestProvider>(context, listen: false)
          .fetchUserRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Demandes'),
        backgroundColor: AppTheme.primaryColor,
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
      body: _selectedIndex == 0 ? _buildDashboard() : _buildHistory(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateRequestScreen()),
          ).then((_) {
            Provider.of<CreditRequestProvider>(context, listen: false)
                .fetchUserRequests();
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle Demande'),
        backgroundColor: AppTheme.accentColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Tableau de bord',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Consumer<CreditRequestProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final requests = provider.requests;
        final pendingCount = requests.where((r) => r.isPending).length;
        final treatedCount = requests.where((r) => r.isTreated).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'En attente',
                      pendingCount.toString(),
                      AppTheme.warningColor,
                      Icons.pending,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Traitées',
                      treatedCount.toString(),
                      AppTheme.successColor,
                      Icons.check_circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Dernières demandes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (requests.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text('Aucune demande pour le moment'),
                    ),
                  ),
                )
              else
                ...requests.take(5).map((request) => _buildRequestCard(request)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color),
                Text(
                  value,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(CreditRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(request.requestNumber),
        subtitle: Text('${request.amountRequested.toStringAsFixed(2)} € - ${request.status}'),
        trailing: Icon(
          request.isPending ? Icons.pending : Icons.check_circle,
          color: request.isPending ? AppTheme.warningColor : AppTheme.successColor,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RequestDetailScreen(requestId: request.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistory() {
    return Consumer<CreditRequestProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final requests = provider.requests;

        if (requests.isEmpty) {
          return const Center(
            child: Text('Aucune demande'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return _buildRequestCard(request);
          },
        );
      },
    );
  }
}

