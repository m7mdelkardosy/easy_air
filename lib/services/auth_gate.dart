import 'package:easyair_app/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easyair_app/services/auth_service.dart';
import 'package:easyair_app/screens/main_layout.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5F7FB),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB73F)),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const MainLayout();
        }

        return const LoginScreen();
      },
    );
  }
}