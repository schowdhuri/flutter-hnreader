class HNItem {
  final int id;
  final String type;
  final String by;
  final int time;
  final String title;
  final String text;
  final int descendants;
  final List<int> kids;
  final String url;
  final int score;
  HNItem({
    this.id,
    this.type,
    this.by,
    this.time,
    this.title,
    this.text,
    this.descendants,
    this.kids,
    this.url,
    this.score,
  });
  factory HNItem.fromJSON(Map<String, dynamic> json) {
    return HNItem(
      id: json["id"],
      type: json["type"],
      by: json["by"],
      time: json["time"],
      title: json["title"],
      text: json["text"],
      descendants: json["descendants"],
      kids: json["kids"] != null ? List<int>.from(json["kids"]) : [],
      url: json["url"],
      score: json["score"],
    );
  }
}
