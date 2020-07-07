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
  final FeedViewArgs args;
  FeedView(this.args, {Key key}) : super(key: key);

  @override
  _FeedViewState createState() => _FeedViewState(this.args);
}

class _FeedViewState extends State<FeedView> {
  final FeedViewArgs args;
  List<HNItem> _stories = [];
  String _error;

  _FeedViewState(this.args) : super();

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
    print("Fetching ${args.category.name} stories...");
    _stories = [];
    _error = null;
    try {
      final http.Response response = await http.get(args.category.url);

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

  handleChangePage(BuildContext ctx) => (Category category) {
        Navigator.pushReplacementNamed(
          ctx,
          "/${category.id}",
          arguments: FeedViewArgs(category),
        );
      };

  handleOpenStory(BuildContext context) => (HNItem story) {
        if (args.category.id == Category.JOBS.id) {
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
          category: args.category,
          error: _error,
          onRefresh: fetchStories,
          onOpenStory: handleOpenStory(context),
        ),
      ),
      bottomNavigationBar: BotNavBar(
        onChange: handleChangePage(context),
        category: args.category,
      ),
    );
  }
}

class FeedViewArgs {
  final Category category;

  FeedViewArgs(this.category);
}
