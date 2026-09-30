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
      // 📡 الشفرة السحرية: بتتسمع للتغيير في حالة تسجيل الدخول مباشر من الفايربيز
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        
        // 1. أجزاء من الثانية أثناء ما الفايربيز بيفحص الـ Cache والسيشن
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5F7FB),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB73F)),
            ),
          );
        }

        // 2. لو المستخدم مسجل دخول حالياً (في بيانات User) ➔ افتح الصفحة الرئيسية
        if (snapshot.hasData && snapshot.data != null) {
          return const MainLayout();
        }

        // 3. لو مش مسجل دخول ➔ افتح صفحة تسجيل الدخول
        return const LoginScreen();
      },
    );
  }
}