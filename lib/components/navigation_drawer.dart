import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_calculator/constants.dart';

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
                'Header',
                style: textTheme.headline6,
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('settings'),
              selected: index == 0,
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesome5.syringe),
              title: const Text('Epinephrine Rate'),
              selected: index == 1,
              onTap: () {
                Navigator.pushNamed(context, '/epinephrine');
              },
            ),
          ],
        ),
      ),
    );
  }
}
