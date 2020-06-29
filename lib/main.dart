import 'package:flutter/material.dart';
import 'package:hnreader/categories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hnreader/hnitem.dart';
import 'package:hnreader/routes.dart';
import 'package:hnreader/home_view.dart';

void main() => runApp(HNApp());

class HNApp extends StatefulWidget {
  @override
  _HNAppState createState() => _HNAppState();
}

class _HNAppState extends State<HNApp> {
  Category _page = categories[0];
  List<HNItem> _stories = [];

  Future<HNItem> fetchItem(int id) async {
    print("Fetching item #$id");
    final http.Response response =
        await http.get("https://hacker-news.firebaseio.com/v0/item/$id.json");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final HNItem hnItem = HNItem.fromJSON(data);
      return hnItem;
    }
    throw Exception("Failed to load item #$id");
  }

  Future<void> fetchStories() async {
    print("Fetching ${_page.name} stories...");
    final http.Response response = await http.get(_page.url);
    if (response.statusCode == 200) {
      print("Response OK");
      List<int> storyIds = List<int>.from(json.decode(response.body));
      List<int> page = storyIds.sublist(0, 10);
      List<Future<HNItem>> futures = page.map((int id) {
        return fetchItem(id);
      }).toList();
      _stories = await Future.wait(futures);
      print("${_stories.length} stories fetched");
      setState(() {});
    } else {
      throw Exception("Failed to load feed");
    }
  }

  handleChangePage(Category page) {
    setState(() {
      _page = page;
      _stories = [];
      fetchStories();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HN Reader",
      onGenerateRoute: Routes.generateRoutes,
      home: HomeView(
        fetchStories: fetchStories,
        onChangePage: handleChangePage,
        stories: _stories,
      ),
    );
  }
}
