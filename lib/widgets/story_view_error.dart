import 'package:flutter/material.dart';

class StoryViewError extends StatelessWidget {
  final String error;
  final Function fetchStory;
  StoryViewError({
    @required this.error,
    @required this.fetchStory,
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
            onPressed: fetchStory,
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
