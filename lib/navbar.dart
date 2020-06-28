import 'package:flutter/material.dart';
import 'package:hnreader/categories.dart';

class BotNavBar extends StatefulWidget {
  final onChange;
  BotNavBar(this.onChange, {Key key}) : super(key: key);
  @override
  _BotNavBarState createState() => _BotNavBarState(onChange);
}

class _BotNavBarState extends State<BotNavBar> {
  final onChange;
  _BotNavBarState(this.onChange) : super();
  int _currentPage = 0;
  handleChangePage(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
    onChange(categories[newPage]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      currentIndex: _currentPage,
      onTap: handleChangePage,
      selectedItemColor: Colors.deepOrangeAccent,
      unselectedItemColor: Colors.grey,
      items: <BottomNavigationBarItem>[
        for (Category category in categories)
          BottomNavigationBarItem(
            icon: category.icon,
            title: Text(category.name),
          )
      ],
    );
  }
}
