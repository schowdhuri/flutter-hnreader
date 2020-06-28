import 'package:flutter/material.dart';
import 'package:hnreader/hnitem.dart';

class FeedItem extends StatelessWidget {
  final HNItem hnItem;
  final onTap;
  FeedItem(this.hnItem, {this.onTap, Key key}) : super(key: key);

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
      onTap: onTap,
      contentPadding: EdgeInsets.all(10),
      title: Column(
        children: <Widget>[
          Text(
            hnItem.title.trim(),
            style: titleStyle,
          ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text(
                "${hnItem.score} points | ",
                style: subTextStyle,
              ),
              Text(
                "By ${hnItem.by} | ",
                style: subTextStyle,
              ),
              Text(
                "${hnItem.descendants} comments",
                style: subTextStyle,
              )
            ],
          ),
        ],
      ),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
