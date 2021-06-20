import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:gazete/models/user.dart';
import 'package:gazete/Widgets/progress.dart';
import 'package:gazete/main.dart';
import 'package:gazete/pages/profileView.dart';
/*
class Arama extends StatefulWidget {
  @override
  _AramaState createState() => _AramaState();
}

class _AramaState extends State<Arama> {
  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        decoration: InputDecoration(
            hintText: "Search",
            filled: true,
            prefixIcon: Icon(
              Icons.account_box,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => print('cleared'),
            )),
      ),
    );
  }

  Container buildNoContent() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildSearchField(), body: buildNoContent());
  }
}
*/

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

String photoUrl;
final usersRef = FirebaseFirestore.instance.collection('users');

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  //Future<List> searchResltList;

  handleSearch(var query) {
    //Future<List> user;
    /*
    userRef
        .where('userName', isGreaterThanOrEqualTo: query)
        .snapshots()s
        .asyncMap((QuerySnapshot snapshot) => users);
    print(users);


    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['userName']);
        users = doc;
      });
    });

    handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef
        .where("displayName", isGreaterThanOrEqualTo: query)
        .getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }
   */
    Future<QuerySnapshot> usersCollection =
        userRef.where('userName', isGreaterThanOrEqualTo: query).get();
    // ignore: missing_return

    setState(() {
      //searchResltList = user;

      searchResultsFuture = usersCollection;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Kullanici Adini Giriniz..",
          filled: true,
          prefixIcon: Icon(
            Icons.account_box,
            size: 28.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearSearch,
          ),
        ),
        onChanged: (value) => handleSearch(value),
      ),
    );
  }

  Container buildNoContent() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[],
        ),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchResults = [];

        final users = snapshot.data.docs.map((doc) {
          User user = User.fromDocument(doc);
          UserResult searchResult = UserResult(user);
          searchResults.add(searchResult);
        }).toList();
        print(users);

        return ListView(
          children: searchResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;
  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Profile(user.id))),
            child: ListTile(
              leading: CircleAvatar(),
              title: Text(
                user.displayName,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
