import 'package:flutter/material.dart';
import 'package:hnreader/categories.dart';
import 'package:hnreader/feed.dart';
import 'package:hnreader/hnitem.dart';
import 'package:hnreader/navbar.dart';
import 'package:hnreader/story_view.dart';
import 'package:hnreader/utils.dart';

class HomeView extends StatelessWidget {
  final List<HNItem> stories;
  final fetchStories;
  final onChangePage;
  final Category category;
  final String error;

  HomeView({
    @required this.stories,
    @required this.fetchStories,
    @required this.onChangePage,
    @required this.category,
    @required this.error,
    Key key,
  }) : super(key: key);

  handleOpenStory(BuildContext context) => (HNItem story) {
        if (category.id == Category.JOBS.id) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HN Reader"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SafeArea(
        child: Feed(
          stories: stories,
          category: category,
          error: error,
          onRefresh: fetchStories,
          onOpenStory: handleOpenStory(context),
        ),
      ),
      bottomNavigationBar: BotNavBar(onChangePage),
    );
  }
}
