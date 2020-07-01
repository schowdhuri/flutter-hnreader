import 'package:flutter/material.dart';
import 'package:hnreader/categories.dart';
import 'package:hnreader/feed_item.dart';
import 'package:hnreader/hnitem.dart';

class Feed extends StatelessWidget {
  final List<HNItem> stories;
  final onRefresh;
  final onOpenStory;
  final Category category;
  final String error;

  Feed({
    @required this.stories,
    @required this.onRefresh,
    @required this.onOpenStory,
    @required this.category,
    @required this.error,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(
        child: Text(error),
      );
    }
    return stories.length > 0
        ? RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              itemCount: stories.length,
              itemBuilder: (BuildContext ctx, int index) {
                return FeedItem(
                  stories[index],
                  onTap: onOpenStory,
                  category: category,
                );
              },
              separatorBuilder: (BuildContext ctx, int index) => Divider(),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
