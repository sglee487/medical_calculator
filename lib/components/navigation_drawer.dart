import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_calculator/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class NavigationDrawer extends StatelessWidget {
  final int index;
  const NavigationDrawer({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: kBackgroundColor1),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'menu.menu',
                style: textTheme.headline6,
              ).tr(),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('common.settings').tr(),
              selected: index == 0,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesome5.syringe),
              // title: const Text('Epinephrine Rate'),
              title: const Text('menu.epinephrineRate').tr(),
              subtitle: context.locale.toString() == 'ko_KR'
                  ? const Text('Epinephrine Rate')
                  : const Text('에피네프린 주사량'),
              selected: index == 1,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/epinephrine');
              },
            ),
          ],
        ),
      ),
    );
  }
}
