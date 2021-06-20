import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final passwordController = TextEditingController();
final emailController = TextEditingController();
final nameController = TextEditingController();
final forgetEmailController = TextEditingController();
Stream<QuerySnapshot> getStatus() {
  var ref = FirebaseFirestore.instance.collection("users").snapshots();
  return ref;
}
