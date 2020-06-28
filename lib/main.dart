import 'package:flutter/material.dart';
import 'package:hnreader/categories.dart';
import 'package:hnreader/feed.dart';
import 'package:hnreader/header.dart';
import 'package:hnreader/navbar.dart';

void main() => runApp(HNApp());

class HNApp extends StatefulWidget {
  @override
  _HNAppState createState() => _HNAppState();
}

class _HNAppState extends State<HNApp> {
  Category _page = categories[0];

  handleChangePage(Category page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HN Reader",
      home: Scaffold(
        appBar: AppBar(
          title: Text("HN Reader"),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: SafeArea(
          child: Feed(_page),
        ),
        bottomNavigationBar: BotNavBar(handleChangePage),
      ),
    );
  }
}
