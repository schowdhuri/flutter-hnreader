import 'package:flutter/material.dart';
import 'package:hnreader/categories.dart';
import 'package:hnreader/feed_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hnreader/hnitem.dart';

class Feed extends StatefulWidget {
  Category page;
  Feed(this.page, {Key key}) : super(key: key);
  @override
  _FeedState createState() => _FeedState(page);
}

class _FeedState extends State<Feed> {
  Category page;
  _FeedState(this.page) : super();

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
    print("Fetching ${page.name} stories...");
    final http.Response response = await http.get(page.url);
    if (response.statusCode == 200) {
      print("Response OK");
      List<int> storyIds = List<int>.from(json.decode(response.body));
      List<int> page = storyIds.sublist(0, 10);
      List<Future<HNItem>> futures = page.map((int id) {
        return fetchItem(id);
      }).toList();
      _stories = await Future.wait(futures);
      setState(() {});
    } else {
      throw Exception("Failed to load feed");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDeps $page");
  }

  handleOpenStory(HNItem hnItem) => () {};

  @override
  Widget build(BuildContext context) {
    return _stories.length > 0
        ? ListView.separated(
            itemCount: _stories.length,
            itemBuilder: (BuildContext ctx, int index) {
              return FeedItem(
                _stories[index],
                onTap: handleOpenStory(_stories[index]),
              );
            },
            separatorBuilder: (BuildContext ctx, int index) => Divider(),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
