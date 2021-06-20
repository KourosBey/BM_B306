import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String displayName;
  final String picNo;

  User({this.id, this.username, this.email, this.displayName, this.picNo});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.data()['userUid'],
      email: doc.data()['email'],
      username: doc.data()['userName'],
      displayName: doc.data()['userName'],
      picNo: doc.data()["ProfilPic URL"],
    );
  }
}
