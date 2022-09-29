
/*
  自定义appbar
 */

import 'package:flutter/cupertino.dart';

class BaseViewBar extends PreferredSize {
  Widget childView;

  //var preferredSize;
  @override
  final Size preferredSize;
 // @override Size get preferredSize => Size.fromHeight(20.0);

  BaseViewBar({Key? key, required this.preferredSize,required this.childView}) {
    // TODO: implement

  }




  @override
  Widget build(BuildContext context) {
    Widget current = childView;
    if (childView == null) {
      current = LimitedBox(
        maxWidth: 0.0,
        maxHeight: 0.0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand()),
      );
    }
    return current;
  }

}
