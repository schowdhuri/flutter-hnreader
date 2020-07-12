import 'package:flutter/material.dart';
import 'package:hnreader/models/categories.dart';
import 'package:hnreader/screens/feed_view.dart';
import 'package:hnreader/widgets/feed_error.dart';
import 'package:hnreader/widgets/feed_item.dart';
import 'package:hnreader/models/hnitem.dart';

class Feed extends StatefulWidget {
  final List<HNItem> stories;
  final FeedRefreshCallback onRefresh;
  final FeedLoadMoreCallback onLoadMore;
  final OpenStoryCallback onOpenStory;
  final Category category;
  final String error;

  Feed({
    @required this.stories,
    @required this.onRefresh,
    @required this.onLoadMore,
    @required this.onOpenStory,
    @required this.category,
    @required this.error,
    Key key,
  }) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  ScrollController _scrollCtrl = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >
          0.9 * _scrollCtrl.position.maxScrollExtent) {
        this.widget.onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.error != null) {
      return FeedError(
        error: this.widget.error,
        onRefresh: this.widget.onRefresh,
      );
    }
    if (this.widget.stories.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: this.widget.onRefresh,
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollCtrl,
        child: ListView.separated(
          controller: _scrollCtrl,
          itemCount: this.widget.stories.length,
          itemBuilder: (BuildContext ctx, int index) {
            return FeedItem(
              this.widget.stories[index],
              onTap: this.widget.onOpenStory,
              category: this.widget.category,
            );
          },
          separatorBuilder: (BuildContext ctx, int index) => Divider(),
        ),
      ),
    );
  }
}
