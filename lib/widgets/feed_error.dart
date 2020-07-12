import 'package:flutter/material.dart';
import 'package:hnreader/screens/feed_view.dart';

class FeedError extends StatelessWidget {
  final String error;
  final FeedRefreshCallback onRefresh;

  FeedError({
    @required this.error,
    @required this.onRefresh,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
