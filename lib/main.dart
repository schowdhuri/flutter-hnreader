import 'package:flutter/material.dart';
import 'package:hnreader/routes.dart';

void main() => runApp(HNApp());

class HNApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HN Reader",
      onGenerateRoute: Routes.generateRoutes,
      initialRoute: "/",
    );
  }
}
