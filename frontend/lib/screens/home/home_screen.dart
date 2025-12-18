import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'user/user_home_screen.dart';
import 'agent/agent_home_screen.dart';
import 'admin/admin_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;
        
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Afficher l'interface selon le rôle
        if (user.isAdmin) {
          return const AdminHomeScreen();
        } else if (user.isAgent) {
          return const AgentHomeScreen();
        } else {
          return const UserHomeScreen();
        }
      },
    );
  }
}

