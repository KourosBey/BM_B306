import 'package:flutter/material.dart';
import 'package:gazete/pages/UIHelper.dart';

import 'package:gazete/pages/registerPage.dart';
import "package:gazete/service/auth.dart";
import 'package:gazete/Widgets/navigationbar.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: NetworkImage(
              "https://st3.depositphotos.com/1010652/14828/v/600/depositphotos_148283389-stock-illustration-video-game-seamless-background.jpg"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 4.0,
                color: Colors.white,
                margin: EdgeInsets.only(left: 10, right: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80)),
                child: Padding(
                  padding: const EdgeInsets.all(45),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: emailController,
                        style: TextStyle(color: Color(0xFF000000)),
                        cursorColor: Color(0xFF9b9b9b),
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        style: TextStyle(color: Color(0xFF000000)),
                        cursorColor: Color(0xFF9b9b9b),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Parola",
                          hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),

                      //Giriş Butonu
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: TextButton(
                            onPressed: () {
                              _authService
                                  .singIn(emailController.text,
                                      passwordController.text)
                                  .then(
                                    (value) => {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NavigationBar(),
                                        ),
                                      ),
                                    },
                                  );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                left: 10,
                                right: 10,
                              ),
                              child: Text(
                                "Giriş",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Kaydol

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateAccount(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                left: 10,
                                right: 10,
                              ),
                              child: Text(
                                "Kayıt Ol",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
