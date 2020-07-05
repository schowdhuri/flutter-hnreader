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

class _CollapsibleState extends State<Collapsible> {
  final Widget header;
  final Widget child;
  bool _isOpen = true;

  handleOpen() {
    if (!_isOpen) {
      setState(() {
        _isOpen = true;
      });
    }
  }

  handleClose() {
    if (_isOpen) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  _CollapsibleState({
    @required this.header,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onLongPress: handleClose,
            onTap: handleOpen,
            child: Column(
              children: <Widget>[
                header,
                SizedBox(height: 10),
                Container(
                  height: _isOpen ? null : 0,
                  child: child,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
