import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hnreader/hnstory_details.dart';
import 'package:hnreader/utils.dart';

class StoryTitle extends StatelessWidget {
  final HNStory story;

  StoryTitle(this.story, {Key key}) : super(key: key);

  final titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  final titleButtonStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.blueAccent,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: story.url != null
                ? FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            story.title,
                            style: titleButtonStyle,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.launch,
                          color: Colors.blueGrey,
                          size: 16,
                        ),
                      ],
                    ),
                    onPressed: () {
                      Utils.launchURL(story.url);
                    },
                  )
                : Text(
                    story.title,
                    style: titleStyle,
                  ),
          ),
          Row(
            children: <Widget>[
              Text(
                "${story.score} points by ${story.by} | ${story.descendants} comments",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          story.text != null
              ? Html(
                  data: story.text,
                  defaultTextStyle: TextStyle(
                    fontSize: 14,
                  ),
                  onLinkTap: (url) {
                    Utils.launchURL(url);
                  },
                )
              : Text(""),
          SizedBox(
            height: 10,
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
