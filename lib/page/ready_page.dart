import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '/globals.dart';
import '/constants.dart';
import '/utils.dart';

class ReadyPage extends StatelessWidget {
  ReadyPage({Key? key}) : super(key: key);

  final Globals globals = Globals();
  LocalStorage storage = LocalStorage('app');

  @override
  Widget build(BuildContext context) {
    // login
    storage.ready.then((_) {
      var user = storage.getItem('user');

      if (user != null) {
        Globals().user = user;
        showToastMessage('${globals.user['email']} logined');
      }

      Navigator.pushNamed(context, '/epinephrine');
    });

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(color: kBackgroundColor1),
      child: const Center(
        child: SizedBox(
            width: kDefaultWidth,
            child: Padding(
                padding: EdgeInsets.all(kDefaultPadding * 2),
                child: Text('starting app...'))),
      ),
    ));
  }
}
