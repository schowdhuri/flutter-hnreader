import 'package:flutter/material.dart';
import 'package:hnreader/categories.dart';

class BotNavBar extends StatelessWidget {
  final Function onChange;
  final Category category;
  BotNavBar({
    this.onChange,
    this.category,
    Key key,
  }) : super(key: key);

  handleChangePage(int newPage) {
    onChange(Category.list[newPage]);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = Category.list.indexOf(category);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: handleChangePage,
      selectedItemColor: Colors.deepOrangeAccent,
      unselectedItemColor: Colors.grey,
      items: <BottomNavigationBarItem>[
        for (Category category in Category.list)
          BottomNavigationBarItem(
            icon: category.icon,
            title: Text(category.name),
          )
      ],
    );
  }
}
