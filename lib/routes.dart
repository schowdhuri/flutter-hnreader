import 'package:flutter/material.dart';
import 'package:hnreader/story_view.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/story":
        final StoryViewArgs args = settings.arguments;
        return MaterialPageRoute(builder: (ctx) {
          return StoryView(
            story: args.story,
          );
        });
    }
  }
}
