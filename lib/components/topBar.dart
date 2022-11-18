import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/constants.dart';

class TopBar extends StatelessWidget with PreferredSizeWidget {
  const TopBar({Key? key, required this.title, this.subtitle})
      : super(key: key);
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        foregroundColor: Colors.blueGrey,
        shadowColor: Colors.transparent,
        elevation: 1,
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey),
        ),
        backgroundColor: kBackgroundColor1,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        bottom: subtitle != null
            ? PreferredSize(
                preferredSize: const Size.fromWidth(0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                  child: Text(subtitle!,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.blueGrey)),
                ))
            : null);
  }

  @override
  Size get preferredSize => const Size.fromHeight(54);
}
