import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazete/Widgets/navigationbar.dart';
import 'package:gazete/pages/mainPage.dart';
import 'package:gazete/pages/profil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:gazete/service/auth.dart';
import 'package:gazete/pages/profileView.dart';
import 'package:gazete/widgets/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class ProfilDuzenle extends StatefulWidget {
  @override
  _ProfilDuzenleState createState() => _ProfilDuzenleState();
}

class _ProfilDuzenleState extends State<ProfilDuzenle> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  void initState() {
    super.initState();
    handleUser();
  }

  Future<String> url;

  DocumentSnapshot user;
  void pickImage() async {
    var randomno = Random(25);
    File imageFile;
    String fotoNo = randomno.nextInt(5000).toString();
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
    } else {
      imageFile = File(pickedFile.path);
      await firebase_storage.FirebaseStorage.instance
          .ref(auth.currentUser.uid + '/' + fotoNo)
          .putFile(imageFile);
      await usersRef
          .doc(auth.currentUser.uid)
          .update({'ProfilPic URL': fotoNo});
    }
    handleUser();
  }

  handleUser() async {
    user = await usersRef.doc(auth.currentUser.uid).get();
    String picNo;
    user.data().forEach((key, value) {
      if (key == 'ProfilPic URL') {
        picNo = value;
      }
    });
    setState(() {
      url = firebase_storage.FirebaseStorage.instance
          .ref(auth.currentUser.uid + '/' + picNo)
          .getDownloadURL();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Profili Düzenle'),
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder(
                future: url,
                builder: (context, snapshot) {
                  Image picImage;
                  if (!snapshot.hasData) {
                    return Container(
                      alignment: Alignment.center,
                      width: 165,
                      height: 165,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                              "https://cdn5.vectorstock.com/i/1000x1000/95/34/black-gamepad-icon-vector-1979534.jpg"),
                        ),
                      ),
                    );
                  }
                  picImage = Image.network(snapshot.data);

                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      alignment: Alignment.center,
                      width: 165,
                      height: 165,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: picImage.image,
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return circularProgress();
                  }

                  return Container();
                }),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () async {
                          pickImage();
                        },
                        child: Text('Fotoğraf Seç'),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavigationBar()));
                        },
                        child: Text(' Onayla'),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
