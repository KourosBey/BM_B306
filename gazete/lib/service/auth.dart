import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final postsRef = FirebaseFirestore.instance.collection('posts');
  final commentsRef = FirebaseFirestore.instance.collection('comments');
  final activityFeedRef = FirebaseFirestore.instance.collection('feed');

  final DateTime timestamp = DateTime.now();
  User currentUser;

//Giriş Yapmak için
  Future<User> singIn(String email, String password) async {
    var user;

    try {
      user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('I cant found your account..');
      } else if (e.code == 'wrong-password') {
        print('Hell no.. Whats ur pass bruh');
      }
    }
    return user.user;
  }

// Çıkış yapmak için
  signOut() async {
    return await auth.signOut();
  }
//Kayıt olma fonksiyonu

  // ignore: missing_return
  Future<User> registerUser(String name, String email, String password) async {
    var user;
    try {
      user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firestore.collection('users').doc(user.user.uid).set({
        'userName': name,
        'email': email,
        'userUid': auth.currentUser.uid,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("Weak pass");
      } else if (e.code == 'email-already-in-use') {
        print('Email already taken..');
      } else
        return user.user;
    }
  }

  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

/*
  forgetPass(String email) {
    auth.sendPasswordResetEmail(email: email).then((kullaniciPass) {
      /* text input içinden alınan emaili ile şifre sıfırlama bağlantısı gönderilir */
      debugPrint(
          "şifre güncelleme maili gönderildi lütfen e-mail  adresinizi kontol edin !");
      auth.signOut();
    }).catchError((e) => debugPrint('Sifre Güncellenirken hata'));
  }*/

  Future<String> getCurrentUID() async {
    return auth.currentUser.uid;
  }

  Future getCurrentuser() async {
    // ignore: await_only_futures
    return await auth.currentUser.displayName;
  }
}
