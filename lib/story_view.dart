import 'package:flutter/material.dart';
import 'package:hnreader/hnitem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';

class StoryView extends StatefulWidget {
  final HNItem story;

  StoryView({Key key, @required this.story}) : super(key: key);

  @override
  _StoryViewState createState() => _StoryViewState(story);
}

class _StoryViewState extends State<StoryView> {
  final HNItem story;
  Map<String, dynamic> storyData;

  _StoryViewState(this.story);

  Future<Map<String, dynamic>> fetchItem(int id) async {
    final http.Response response =
        await http.get("https://hacker-news.firebaseio.com/v0/item/$id.json");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data != null && data["kids"] != null) {
        List<int> kids = List<int>.from(data["kids"]);
        List<Future<Map<String, dynamic>>> futures = kids.map((int kid) {
          return fetchItem(kid);
        }).toList();
        data["kids"] = await Future.wait(futures);
      }
      return data;
    }
    throw Exception("Failed to fetch item $id");
  }

  Future<void> fetchStory() async {
    print("Fetching ${story.id}");
    setState(() {
      storyData = null;
    });
    storyData = await fetchItem(story.id);
    print(storyData);
    setState(() {});
  }

  @override
  void initState() {
    fetchStory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: storyData != null
          ? ListView(
              children: <Widget>[
                storyData["text"] != null
                    ? Padding(
                        padding: EdgeInsets.all(10),
                        child: Html(
                          data: storyData["text"],
                        ),
                      )
                    : Text(""),
                for (var kid in storyData["kids"])
                  kid["text"] != null
                      ? Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Html(
                              data: kid["text"],
                            ),
                          ),
                        )
                      : Text("")
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
