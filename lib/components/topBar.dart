import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/constants.dart';

class TopBar extends StatelessWidget with PreferredSizeWidget {
  const TopBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.blueGrey,
      shadowColor: Colors.transparent,
      elevation: 3,
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
      backgroundColor: kBackgroundColor1,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(54);
}
