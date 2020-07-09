import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hnreader/hnstory_details.dart';
import 'package:hnreader/utils.dart';

import 'package:hnreader/collapsible_panel.dart';

class StoryComments extends StatelessWidget {
  final HNStory story;
  final List<Widget> kids;

  StoryComments(this.story, {this.kids, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (story.text == null) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
      child: Collapsible(
        header: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.comment,
                color: Colors.blueGrey,
                size: 14,
              ),
              SizedBox(width: 5),
              Text(
                story.by,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 5),
              Text(
                timeago.format(
                    DateTime.fromMillisecondsSinceEpoch(story.time * 1000)),
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 1.0,
                    color: Colors.blueGrey[50],
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Html(
                        data: story.text,
                        defaultTextStyle: TextStyle(
                          fontSize: 14,
                        ),
                        onLinkTap: (url) {
                          Utils.launchURL(url);
                        }),
                    ...kids,
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
