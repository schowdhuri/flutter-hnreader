import 'package:flutter/material.dart';
import 'package:hnreader/feed.dart';
import 'package:hnreader/hnitem.dart';
import 'package:hnreader/navbar.dart';
import 'package:hnreader/story_view.dart';

class HomeView extends StatelessWidget {
  final List<HNItem> stories;
  final fetchStories;
  final onChangePage;

  HomeView({
    @required this.stories,
    @required this.fetchStories,
    @required this.onChangePage,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HN Reader"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SafeArea(
        child: Feed(
          stories: stories,
          onRefresh: fetchStories,
          onOpenStory: (HNItem story) {
            Navigator.pushNamed(
              context,
              "/story",
              arguments: StoryViewArgs(
                story: story,
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BotNavBar(onChangePage),
    );
  }
}
