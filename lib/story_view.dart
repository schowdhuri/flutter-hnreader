import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:hnreader/hnitem.dart';
import 'package:hnreader/hnstory_details.dart';
import 'package:hnreader/utils.dart';

class StoryView extends StatefulWidget {
  final HNItem story;

  StoryView({Key key, @required this.story}) : super(key: key);

  @override
  _StoryViewState createState() => _StoryViewState(story);
}

class _StoryViewState extends State<StoryView> {
  final HNItem story;
  HNStory storyDetails;

  _StoryViewState(this.story);

  Future<HNStory> fetchItem(int id) async {
    final http.Response response =
        await http.get("https://hacker-news.firebaseio.com/v0/item/$id.json");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data == null) return null;
      final HNStory story = HNStory.fromJSON(data);
      List<Future<HNStory>> futures = story.kids.map((int kid) {
        return fetchItem(kid);
      }).toList();
      List<HNStory> kidsDetails = await Future.wait(futures);
      story.kidsDetails = kidsDetails;
      return story;
    }
    throw Exception("Failed to fetch item $id");
  }

  Future<void> fetchStory() async {
    print("Fetching ${story.id}");
    setState(() {
      storyDetails = null;
    });
    storyDetails = await fetchItem(story.id);
    setState(() {});
  }

  Widget buildStoryTitle(HNStory storyDetails) {
    final titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    final titleButtonStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.blueAccent,
    );
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: storyDetails.url != null
                ? FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          storyDetails.title,
                          style: titleButtonStyle,
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
                      Utils.launchURL(storyDetails.url);
                    },
                  )
                : Text(
                    storyDetails.title,
                    style: titleStyle,
                  ),
          ),
          Row(
            children: <Widget>[
              Text(
                "${storyDetails.score} points by ${storyDetails.by}",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          storyDetails.text != null
              ? Html(
                  data: storyDetails.text,
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

  Widget buildCommentTree(HNStory storyDetails, {int depth}) {
    Widget buildComment(HNStory storyDetails) {
      return storyDetails.text != null
          ? Padding(
              padding: EdgeInsets.fromLTRB(10 + 20.0 * depth, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.comment,
                        color: Colors.blueGrey,
                        size: 14,
                      ),
                      SizedBox(width: 5),
                      Text(
                        storyDetails.by,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Html(
                      data: storyDetails.text,
                      defaultTextStyle: TextStyle(
                        fontSize: 14,
                      ),
                      onLinkTap: (url) {
                        Utils.launchURL(url);
                      }),
                ],
              ),
            )
          : Text("");
    }

    if (depth == null) {
      depth = 0;
    }
    if (storyDetails.kidsDetails.length > 0) {
      return Column(
        children: <Widget>[
          buildComment(storyDetails),
          for (HNStory kid in storyDetails.kidsDetails)
            buildCommentTree(kid, depth: depth + 1)
        ],
      );
    }
    return buildComment(storyDetails);
  }

  @override
  void initState() {
    super.initState();
    fetchStory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: storyDetails != null
          ? ListView(
              children: <Widget>[
                buildStoryTitle(storyDetails),
                for (HNStory kid in storyDetails.kidsDetails)
                  buildCommentTree(kid)
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class StoryViewArgs {
  final HNItem story;
  StoryViewArgs({
    @required this.story,
  });
}
