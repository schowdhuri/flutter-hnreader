import 'package:flutter/material.dart';
import 'package:hnreader/categories.dart';
import 'package:hnreader/feed_view.dart';
import 'package:hnreader/story_view.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    if (settings.name == "/") {
      final FeedViewArgs args =
          settings.arguments ?? FeedViewArgs(Category.list[0]);
      print("Page ${args.category.name}");
      return MaterialPageRoute(builder: (ctx) => FeedView(args));
    } else if (settings.name == "/story") {
      final StoryViewArgs args = settings.arguments;
      return MaterialPageRoute(builder: (ctx) => StoryView(story: args.story));
    }
  }
}
