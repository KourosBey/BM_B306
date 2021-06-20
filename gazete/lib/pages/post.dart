import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  @override
  PostView createState() => PostView();
}

var id;

class PostView extends State<Post> {
  @override
  Widget build(BuildContext context) {
    ElevatedButton(
      onPressed: () {},
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 60.0,
      ),
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(), primary: Colors.green),
    );

    return Container();
  }
}
