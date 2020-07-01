import 'package:flutter/material.dart';

class Category {
  String id;
  String name;
  String url;
  Icon icon;

  Category({
    this.id,
    this.name,
    this.url,
    this.icon,
  });

  static final Category TOP = Category(
    id: "top",
    name: "Top",
    icon: Icon(Icons.trending_up),
    url: "https://hacker-news.firebaseio.com/v0/topstories.json",
  );
  static final Category JOBS = Category(
    id: "jobs",
    name: "Jobs",
    icon: Icon(Icons.business_center),
    url: "https://hacker-news.firebaseio.com/v0/jobstories.json",
  );
  static final Category ASK = Category(
    id: "ask",
    name: "Ask",
    icon: Icon(Icons.question_answer),
    url: "https://hacker-news.firebaseio.com/v0/askstories.json",
  );
  static final NEW = Category(
    id: "new",
    name: "New",
    icon: Icon(Icons.new_releases),
    url: "https://hacker-news.firebaseio.com/v0/newstories.json",
  );

  static final List<Category> list = <Category>[
    TOP,
    JOBS,
    ASK,
    NEW,
  ];
}
