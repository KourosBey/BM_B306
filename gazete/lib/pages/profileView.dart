import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gazete/Navigasyon/stat_widget.dart';
import 'package:gazete/constanst/constants.dart';
import 'package:gazete/main.dart';
import 'package:gazete/pages/profilDuzenle.dart';
import 'LoginPage.dart';

String profileID;
FirebaseAuth auth = FirebaseAuth.instance;

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  Profile(String id) {
    profileID = id;
  }

  @override
  ProfileSayfasi createState() => ProfileSayfasi();
}

class ProfileSayfasi extends State<Profile> {
  void choiceAction(String choice) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void initState() {
    super.initState();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  final followRef = userRef.doc(profileID).collection("followers");
  final followingRef = userRef.doc(profileID).collection("following");
  final followersRef =
      userRef.doc(auth.currentUser.uid).collection("following");
  String buton = "Takip Et";
  String postOrientation = "grid";
  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  String photosURl =
      "https://cdn5.vectorstock.com/i/1000x1000/95/34/black-gamepad-icon-vector-1979534.jpg";
  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef.doc(profileID).get();
    setState(() {
      isFollowing = doc.exists;
      if (isFollowing)
        buton = "Takibi Bırak";
      else {
        buton = "Takip Et";
      }
    });
  }

  void checkFollow() {
    if (isFollowing) {
      followRef.doc(auth.currentUser.uid).set({"timestamp": DateTime.now()});
      followersRef.doc(profileID).set({"timestamp": DateTime.now()});
      setState(() {
        buton = "Takibi Bırak";
      });
    } else {
      followRef.doc(auth.currentUser.uid).delete();
      followersRef.doc(profileID).delete();
      setState(() {
        buton = "Takip Et";
      });
    }
    getFollowers();
    getFollowing();
  }

  Future<Image> getImage(String kullanici) async {
    String picNo;
    Image picImage;
    DocumentSnapshot user;
    user = await usersRef.doc(kullanici).get();
    user.data().forEach((key, value) {
      if (key == 'ProfilPic URL') {
        picNo = value;
      }
    });
    String url = await FirebaseStorage.instance
        .ref(kullanici + '/' + picNo)
        .getDownloadURL();

    setState(() {
      if (url != null) photosURl = url;
    });
    picImage = Image.network(photosURl);

    return picImage;
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followRef.get();
    setState(() {
      followerCount = snapshot.size;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef.get();
    setState(() {
      followingCount = snapshot.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance.collection("users");

    return FutureBuilder<DocumentSnapshot>(
      future: ref.doc(profileID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Uhh. Somethings went Wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[900],
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return Constants.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5),
                        child: CircleAvatar(
                          radius: 56,
                          backgroundImage: NetworkImage(photosURl),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  statWidget("Gönderi", "$postCount"),
                                  statWidget("Takipçi", "$followerCount"),
                                  statWidget("Takip", "$followingCount"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                              top: 15.0, bottom: 5.0, left: 15.0),
                          child: Text(
                            "${data['userName']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 15.0, left: 15.0),
                        child: Text(
                          "${data['email']}",
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () {
                          isFollowing
                              ? isFollowing = false
                              : isFollowing = true;
                          checkFollow();
                        },
                        color: Colors.indigo,
                        splashColor: Colors.white,
                        child: Text(
                          buton,
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 8.0),
                      ),
                      SizedBox(
                        width: 24.0,
                      ),
                      // ignore: deprecated_member_use
                      OutlineButton(
                        onPressed: () {},
                        child: Text("Mesaj"),
                        padding: EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 8.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      height: 18.0,
                      thickness: 0.6,
                      color: Colors.black87,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              /*decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://i1.sndcdn.com/artworks-tXB4eVVQFGdnsslS-tyNCGQ-t500x500.jpg"),
                        ),
                      ),*/
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
