import 'package:flutter/material.dart';
import 'package:hnreader/categories.dart';
import 'package:hnreader/feed_item.dart';
import 'package:hnreader/hnitem.dart';

class Feed extends StatelessWidget {
  List<HNItem> stories;
  final onRefresh;
  Feed(this.stories, {this.onRefresh, Key key}) : super(key: key);

  handleOpenStory(HNItem story) => () {};

  @override
  Widget build(BuildContext context) {
    return stories.length > 0
        ? RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              itemCount: stories.length,
              itemBuilder: (BuildContext ctx, int index) {
                return FeedItem(
                  stories[index],
                  onTap: handleOpenStory(stories[index]),
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
