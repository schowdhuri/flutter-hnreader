import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hnreader/models/categories.dart';
import 'package:hnreader/widgets/feed.dart';
import 'package:hnreader/models/hnitem.dart';
import 'package:hnreader/widgets/navbar.dart';
import 'package:hnreader/screens/story_view.dart';
import 'package:hnreader/utils.dart';

typedef void FeedRefreshCallback();
typedef void FeedLoadMoreCallback();
typedef void OpenStoryCallback(HNItem story);

class FeedView extends StatefulWidget {
  final FeedViewArgs args;
  FeedView(this.args, {Key key}) : super(key: key);

  @override
  _FeedViewState createState() => _FeedViewState(args);
}

class _FeedViewState extends State<FeedView> {
  List<HNItem> _stories = [];
  List<int> _storyIds = [];
  int _pageNum = 0;
  bool _isLoadingMore = false;
  String _error;
  Category _category;

  _FeedViewState(FeedViewArgs args) : super() {
    this._category = args.category;
  }

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

  Future<List<int>> fetchStoryIds() async {
    final http.Response response = await http.get(_category.url);
    if (response.statusCode != 200) {
      throw Exception("Error fetching feed");
    }
    return List<int>.from(json.decode(response.body));
  }

  Future<void> fetchStories([bool isMore = false]) async {
    if (!isMore) {
      print("Fetching ${_category.name} stories...");
      setState(() {
        _stories = [];
        _error = null;
      });
      try {
        _storyIds = await fetchStoryIds();
      } catch (ex0) {
        setState(() {
          _error = "Index could not be fetched because of an error";
        });
      }
    } else if (!_isLoadingMore) {
      print("Fetching ${_category.name} stories page ${_pageNum + 2}...");
      setState(() {
        _isLoadingMore = true;
        _pageNum += 1;
        _error = null;
      });
    } else {
      print("Fetch in progress...");
      return;
    }
    try {
      List<int> page = _storyIds.sublist(_pageNum * 10, _pageNum * 10 + 10);
      List<Future<HNItem>> futures = page.map((int id) {
        return fetchItem(id);
      }).toList();
      List<HNItem> newStories = await Future.wait(futures);
      print("${newStories.length} stories fetched");
      setState(() {
        _stories = [..._stories, ...newStories];
        _error = null;
        _isLoadingMore = false;
      });
    } catch (ex1) {
      print(ex1);
      setState(() {
        _isLoadingMore = false;
        _error = "Stories could not be fetched because of an error";
      });
    }
  }

  handleChangePage(Category category) {
    setState(() {
      _category = category;
      _pageNum = 0;
      _error = null;
      fetchStories();
    });
  }

  handleOpenStory(BuildContext context) {
    void _openStory(HNItem story) {
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
    }

    return _openStory;
  }

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
            onLoadMore: () {
              fetchStories(true);
            }),
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
