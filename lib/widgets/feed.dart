import 'package:flutter/material.dart';
import 'package:hnreader/models/categories.dart';
import 'package:hnreader/widgets/feed_item.dart';
import 'package:hnreader/models/hnitem.dart';

class Feed extends StatelessWidget {
  final List<HNItem> stories;
  final Function onRefresh;
  final Function onOpenStory;
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
      return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(error),
            FlatButton(
              onPressed: onRefresh,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Try Again"),
                  SizedBox(width: 5),
                  Icon(
                    Icons.refresh,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
            )
          ],
        ),
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
