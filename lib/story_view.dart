import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hnreader/story_view_comments.dart';
import 'package:hnreader/story_view_title.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hnreader/models/hnitem.dart';
import 'package:hnreader/models/hnstory_details.dart';

class StoryView extends StatefulWidget {
  final HNItem story;

  StoryView({Key key, @required this.story}) : super(key: key);

  @override
  _StoryViewState createState() => _StoryViewState(story);
}

class _StoryViewState extends State<StoryView> {
  final HNItem story;
  HNStory storyDetails;
  bool _isFetching = false;
  String _error;

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
    setState(() {
      _isFetching = true;
    });
    print("Fetching ${story.id}");
    try {
      storyDetails = await fetchItem(story.id);
      setState(() {
        _isFetching = false;
        _error = null;
      });
    } catch (ex0) {
      print(ex0);
      setState(() {
        _error = "There was an error fetching this story";
        _isFetching = false;
      });
    }
  }

  Widget buildCommentTree(HNStory storyDetails) {
    List<Widget> kids =
        List.generate(storyDetails.kidsDetails.length, (int index) {
      return buildCommentTree(storyDetails.kidsDetails[index]);
    });
    return StoryComments(storyDetails, kids: kids);
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
      body: _isFetching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: fetchStory,
              child: _error != null
                  ? Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_error),
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
                    )
                  : Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: ListView(
                        children: <Widget>[
                          StoryTitle(storyDetails),
                          for (HNStory kid in storyDetails.kidsDetails)
                            buildCommentTree(kid),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
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
