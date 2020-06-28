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
}

List<Category> categories = <Category>[
  Category(
    id: "top",
    name: "Top",
    icon: Icon(Icons.trending_up),
    url: "https://hacker-news.firebaseio.com/v0/topstories.json",
  ),
  Category(
    id: "jobs",
    name: "Jobs",
    icon: Icon(Icons.business_center),
    url: "https://hacker-news.firebaseio.com/v0/jobstories.json",
  ),
  Category(
    id: "ask",
    name: "Ask",
    icon: Icon(Icons.question_answer),
    url: "https://hacker-news.firebaseio.com/v0/askstories.json",
  ),
  Category(
    id: "new",
    name: "New",
    icon: Icon(Icons.new_releases),
    url: "https://hacker-news.firebaseio.com/v0/newstories.json",
  ),
];
