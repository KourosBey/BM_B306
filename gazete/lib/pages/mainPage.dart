import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:gazete/pages/profileView.dart';
import 'LoginPage.dart';
import 'package:gazete/service/auth.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  AuthService _authService = AuthService();
  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 16,
            child: Container(
                height: 400.0,
                width: 360.0,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "HABER İÇERİĞİ",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  void choiceAction(String choice) {
    _authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }

  Widget cardPost() {
    String isim;
    isim = auth.currentUser.displayName;
    return Container(
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 4, top: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () async {
              showInformationDialog(context);
            },
            child: Text('$isim'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Anasayfa'),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.videogame_asset),
            onPressed: () {},
          );
        }),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            cardPost(),
            cardPost(),
            cardPost(),
            cardPost(),
            cardPost(),
            cardPost(),
            cardPost()
          ],
        ),
      ),
    );
  }
}
