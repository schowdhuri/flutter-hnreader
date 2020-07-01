import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hnreader/categories.dart';
import 'package:hnreader/hnitem.dart';

class FeedItem extends StatelessWidget {
  final HNItem hnItem;
  final Category category;
  final onTap;
  FeedItem(
    this.hnItem, {
    @required this.category,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  handleOpenStory() {
    onTap(this.hnItem);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: 16,
    );
    final subTextStyle = TextStyle(
      color: Colors.blueGrey,
      fontSize: 14,
    );
    return ListTile(
      onTap: handleOpenStory,
      contentPadding: EdgeInsets.all(10),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            hnItem.title.trim(),
            style: titleStyle,
          ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text(
                "${hnItem.score} points",
                style: subTextStyle,
              ),
              Text(
                " | By ${hnItem.by}",
                style: subTextStyle,
              ),
              category.id != Category.JOBS.id
                  ? Text(
                      " | ${hnItem.descendants} comments",
                      style: subTextStyle,
                    )
                  : Text(""),
            ],
          ),
        ],
      ),
      trailing: category.id != Category.JOBS.id
          ? Icon(Icons.chevron_right)
          : Icon(
              Icons.launch,
              size: 18,
            ),
    );
  }
}
