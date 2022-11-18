import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:easy_localization/easy_localization.dart';

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

      Navigator.pushReplacementNamed(context, '/epinephrine');
    });

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(color: kBackgroundColor1),
      child: Center(
        child: SizedBox(
            width: kDefaultWidth,
            child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding * 2),
                child: const Text('guide.startupApp').tr())),
      ),
    ));
  }
}
