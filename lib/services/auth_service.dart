import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  FirebaseAuth get _auth => FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

 // 2. إنشاء حساب جديد مع حفظ البروفايل الكامل في Firestore 🚀
Future<UserCredential?> signUpWithEmail({
  required String email,
  required String password,
  required String name,
  required String phone, // 👈 1. ضفنا التليفون هنا
}) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    if (user != null) {
      // أ. تحديث الاسم في Auth
      await user.updateDisplayName(name);

      // ب. ☁️ حفظ بيانات المستخدم الكاملة أونلاين في Firestore!
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'phone': phone, // 👈 تخزين التليفون
        'createdAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    }

    return userCredential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      throw 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      throw 'The account already exists for that email.';
    } else {
      throw e.message ?? 'An error occurred during registration.';
    }
  } catch (e) {
    throw 'An unexpected error occurred.';
  }
}
//-----------------------------------
// 📥 1. جلب بيانات المستخدم الشخصية أونلاين من Firestore
Future<Map<String, dynamic>?> getUserProfileData() async {
  try {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return doc.data();
  } catch (e) {
    print('Error fetching user data: $e');
    return null;
  }
}

// ✏️ 2. تحديث بيانات المستخدم الشخصية في Firestore
Future<void> updateUserProfileData({
  required String name,
  required String phone,
}) async {
  try {
    final user = _auth.currentUser;
    if (user == null) return;

    // تحديث الاسم في Auth
    await user.updateDisplayName(name);

    // تحديث الاسم والرقم في Firestore أونلاين
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': name,
      'phone': phone,
    });
  } catch (e) {
    throw 'Failed to update personal details.';
  }
}
// -----------------------------------
  Future<UserCredential?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided.';
      } else {
        throw e.message ?? 'Login failed. Please check your credentials.';
      }
    } catch (e) {
      throw 'An unexpected error occurred.';
    }
  }

  Future<String?> uploadProfileImageToCloudinary(File imageFile) async {
    try {
      const String cloudName = 'hrkmfsgm';
      const String uploadPreset = 'zockw48q';

      final Uri url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final http.MultipartRequest request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final http.StreamedResponse response = await request.send();
      final String responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(responseData);
        final String imageUrl = jsonMap['secure_url'];

        final User? user = currentUser;
        if (user == null) {
          throw 'No user is logged in.';
        }

        await user.updateProfile(photoURL: imageUrl);
        await user.reload();

        return FirebaseAuth.instance.currentUser?.photoURL ?? imageUrl;
      }

      throw 'Cloudinary upload failed (${response.statusCode}): $responseData';
    } catch (e) {
      throw 'Failed to upload profile image: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
