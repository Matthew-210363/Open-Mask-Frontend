import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_mask/data/services/auth_service.dart';

import '../screens/login_screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _showLogoutDialog(final BuildContext context) {
    showDialog(
      context: context,
      builder: (final BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Möchtest du dich wirklich ausloggen?'),
          actions: [
            TextButton(
              onPressed: () => context.pop(), // Dialog schließen
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                _logout(context);
                context.pop(); // Dialog schließen
              },
              child: const Text('Ja, ausloggen'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(final BuildContext context) async {
    await AuthService.instance.logout();
    // Zum Login-Screen navigieren
    if (context.mounted) {
      context.go(LoginScreen.routePath);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showLogoutDialog(context),
      child: const Text('Logout'),
    );
  }
}
