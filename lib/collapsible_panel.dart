import 'package:flutter/material.dart';

class Collapsible extends StatefulWidget {
  final Widget header;
  final Widget child;

  Collapsible({
    @required this.header,
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  _CollapsibleState createState() => _CollapsibleState(
        header: this.header,
        child: this.child,
      );
}

class _CollapsibleState extends State<Collapsible>
    with SingleTickerProviderStateMixin {
  final Widget header;
  final Widget child;
  bool _isOpen = true;

  double _contentHeight;
  AnimationController expandController;
  Animation<double> animation;

  handleOpen() {
    if (!_isOpen) {
      setState(() {
        _isOpen = true;
      });
      expandController.forward();
    }
  }

  handleClose() {
    if (_isOpen) {
      setState(() {
        _isOpen = false;
      });
      expandController.reverse();
    }
  }

  _CollapsibleState({
    @required this.header,
    @required this.child,
  });

  void prepareAnimations() {
    expandController = AnimationController(
      value: 1,
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (_isOpen) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onLongPress: handleClose,
            onTap: handleOpen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                header,
                SizedBox(height: 10),
                SizeTransition(
                  axisAlignment: 1.0,
                  sizeFactor: animation,
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
