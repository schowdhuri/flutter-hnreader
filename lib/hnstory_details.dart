import 'package:flutter/material.dart';

class StoryTypes {
  static const String STORY = "story";
  static const String COMMENT = "comment";
}

class HNStory {
  final int id;
  final String by;
  final int descendants;
  final List<int> kids;
  List<HNStory> kidsDetails;
  final int score;
  final int time;
  final String title;
  final String text;
  final String type;
  final String url;

  HNStory({
    @required this.id,
    @required this.by,
    @required this.descendants,
    this.kids,
    this.kidsDetails,
    this.score,
    @required this.time,
    @required this.title,
    this.text,
    @required this.type,
    this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "by": by,
      "descendants": descendants,
      "kids": kids,
      "score": score,
      "time": time,
      "title": title,
      "text": text,
      "type": type,
      "url": url,
    };
  }

  static HNStory fromJSON(Map<String, dynamic> data) {
    return HNStory(
        id: data["id"],
        by: data["by"],
        descendants: data["descendants"],
        kids: data["kids"] != null ? List<int>.from(data["kids"]) : [],
        kidsDetails: data["kidsDetails"] is List
            ? List<HNStory>.from(
                data["kidsDetails"].map(HNStory.fromJSON).toList())
            : [],
        score: data["score"],
        time: data["time"],
        title: data["title"],
        text: data["text"],
        type: data["type"],
        url: data["url"]);
  }
}
