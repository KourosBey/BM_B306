import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gazete/pages/UIHelper.dart';
import 'pages/LoginPage.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Login(),
  ));
}

void kullaniciEkleme() {
  CollectionReference ref = FirebaseFirestore.instance.collection("users");
  if (emailController.value != null && passwordController.value != null) {
    ref.add({
      "Email": emailController.text,
      "Sifre": passwordController.text,
    });
  }
}
