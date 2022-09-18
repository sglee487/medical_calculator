import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '/components/navigation_drawer.dart';
import '/components/topBar.dart';

import '/api.dart';
import '/constants.dart';
import '/globals.dart';
import '/utils.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final Globals globals = Globals();

  @override
  Widget build(BuildContext context) {
    void _logout() async {
      globals.logout();
      Navigator.pushNamed(context, '/settings');
    }

    void _removeAccount() async {
      try {
        await removeAccount().then((_) {
          globals.logout();
          Navigator.pushNamed(context, '/settings');
          showToastMessage('Account removed');
        });
      } catch (e) {
        showErrorToast('Unable to remove account\nPlease try again later');
      }
    }

    return Scaffold(
        appBar: const TopBar(title: 'Settings'),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(color: kBackgroundColor1),
            child: Center(
              child: SizedBox(
                  width: kDefaultWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding * 2),
                    child: Column(
                      children: [
                        const Divider(
                          height: 20,
                          thickness: 1,
                        ),
                        Container(
                          child: globals.isLogined()
                              ? Column(
                                  children: [
                                    Text(globals.user['email'],
                                        style: kSecondayLabelStyle),
                                    const Divider(
                                        height: 20, color: Colors.transparent),
                                    ElevatedButton.icon(
                                        onPressed: () => {
                                              Navigator.pushNamed(
                                                  context, '/changePassword')
                                            },
                                        icon:
                                            const Icon(Icons.password_outlined),
                                        label: const Text('Change password')),
                                    const Divider(
                                        height: 10, color: Colors.transparent),
                                    ElevatedButton.icon(
                                        onPressed: () => {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            content: const Text(
                                                                'are you sure to remove account?'),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child: const Text(
                                                                      'CANCEL')),
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      _removeAccount,
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          primary: Colors
                                                                              .red),
                                                                  child: const Text(
                                                                      'remove'))
                                                            ],
                                                          ))
                                            },
                                        icon: const Icon(Icons.delete_rounded),
                                        label: const Text('remove account')),
                                    const Divider(
                                        height: 10, color: Colors.transparent),
                                    ElevatedButton.icon(
                                        onPressed: _logout,
                                        icon: const Icon(Icons.logout_outlined),
                                        label: const Text('logout'))
                                  ],
                                )
                              : TextButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/login'),
                                  child: const Text('로그인')),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                        ),
                        TextButton(
                            onPressed: () => launchUrlString(
                                'https://medicalculator.shop/media/medical+calculator+app\'s+privacy+policy_220824.html'),
                            child: const Text('개인정보처리방침')),
                        const Divider(
                          height: 20,
                          thickness: 1,
                        ),
                        const Text('문의'),
                        TextButton(
                            onPressed: () =>
                                launchUrlString('https://github.com/sglee487'),
                            child: const Text('github.com/sglee487')),
                        const Divider(
                          height: 20,
                          thickness: 1,
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
        drawer: const NavigationDrawer(index: 0));
  }
}
