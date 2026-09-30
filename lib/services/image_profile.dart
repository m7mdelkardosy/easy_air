import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

Future<String?> uploadProfileImageToCloudinary(
  File imageFile,
  FirebaseAuth auth,
) async {
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

    if (response.statusCode != 200) {
      throw 'Cloudinary failed: $responseData';
    }

    final Map<String, dynamic> jsonMap = jsonDecode(responseData);
    final String imageUrl = jsonMap['secure_url'] as String;

    final User? user = auth.currentUser;
    if (user == null) {
      throw 'No logged-in user found';
    }

    await user.updateProfile(photoURL: imageUrl);
    await user.reload();

    return FirebaseAuth.instance.currentUser?.photoURL ?? imageUrl;
  } catch (e) {
    rethrow;
  }
}
