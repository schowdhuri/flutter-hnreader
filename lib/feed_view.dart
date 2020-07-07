import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hnreader/categories.dart';
import 'package:hnreader/feed.dart';
import 'package:hnreader/hnitem.dart';
import 'package:hnreader/navbar.dart';
import 'package:hnreader/story_view.dart';
import 'package:hnreader/utils.dart';

class FeedView extends StatefulWidget {
  final FeedViewArgs _args;
  FeedView(this._args, {Key key}) : super(key: key);

  @override
  _FeedViewState createState() => _FeedViewState(_args.category);
}

class _FeedViewState extends State<FeedView> {
  Category _category;
  List<HNItem> _stories = [];
  String _error;

  _FeedViewState(this._category) : super();

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
    print("Fetching ${_category.name} stories...");
    _stories = [];
    _error = null;
    try {
      final http.Response response = await http.get(_category.url);

      if (response.statusCode == 200) {
        List<int> storyIds = List<int>.from(json.decode(response.body));
        List<int> page = storyIds.sublist(0, 10);
        List<Future<HNItem>> futures = page.map((int id) {
          return fetchItem(id);
        }).toList();
        _stories = await Future.wait(futures);
        print("${_stories.length} stories fetched");
        setState(() {});
        return;
      }
    } catch (ex) {
      _error = ex.toString();
    }
    throw Exception("Failed to load feed");
  }

  handleChangePage(Category category) {
    setState(() {
      _category = category;
      fetchStories();
    });
  }

  handleOpenStory(BuildContext context) => (HNItem story) {
        if (_category.id == Category.JOBS.id) {
          Utils.launchURL(story.url);
        } else {
          Navigator.pushNamed(
            context,
            "/story",
            arguments: StoryViewArgs(
              story: story,
            ),
          );
        }
      };

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HN Reader"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SafeArea(
        child: Feed(
          stories: _stories,
          category: _category,
          error: _error,
          onRefresh: fetchStories,
          onOpenStory: handleOpenStory(context),
        ),
      ),
      bottomNavigationBar: BotNavBar(
        onChange: handleChangePage,
        category: _category,
      ),
    );
  }
}

class FeedViewArgs {
  final Category category;

  FeedViewArgs(this.category);
}
