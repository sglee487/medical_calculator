import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:easy_localization/easy_localization.dart';

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
      Navigator.pushReplacementNamed(context, '/settings');
    }

    void _removeAccount() async {
      try {
        await removeAccount().then((_) {
          globals.logout();
          Navigator.pushReplacementNamed(context, '/settings');
          showToastMessage('message.removeAccountSeccess'.tr());
        });
      } catch (e) {
        showErrorToast('message.unableRemoveAccount'.tr());
      }
    }

    return Scaffold(
        appBar: TopBar(title: 'common.settings'.tr()),
        backgroundColor: kBackgroundColor1,
        body: SingleChildScrollView(
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
                                            Navigator.pushReplacementNamed(
                                                context, '/changePassword')
                                          },
                                      icon: const Icon(Icons.password_outlined),
                                      label: const Text('common.changePassword')
                                          .tr()),
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
                                                                  'message.confirmRemoveAccount')
                                                              .tr(),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                child: const Text(
                                                                        'common.cancel')
                                                                    .tr()),
                                                            ElevatedButton(
                                                                onPressed:
                                                                    _removeAccount,
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        primary:
                                                                            Colors
                                                                                .red),
                                                                child: const Text(
                                                                        'common.remove')
                                                                    .tr())
                                                          ],
                                                        ))
                                          },
                                      icon: const Icon(Icons.delete_rounded),
                                      label: const Text('common.removeAccount')
                                          .tr()),
                                  const Divider(
                                      height: 10, color: Colors.transparent),
                                  ElevatedButton.icon(
                                      onPressed: _logout,
                                      icon: const Icon(Icons.logout_outlined),
                                      label: const Text('common.logout').tr()),
                                ],
                              )
                            : TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/login'),
                                child: const Text('common.login').tr()),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('settings.languageSetting').tr(),
                          DropdownButton(
                              value: context.locale.toString(),
                              items: const [
                                DropdownMenuItem(
                                  value: 'ko_KR',
                                  child: Text('한국어'),
                                ),
                                DropdownMenuItem(
                                  value: 'en_US',
                                  child: Text('English'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value == 'ko_KR') {
                                  context.setLocale(const Locale('ko', 'KR'));
                                } else if (value == 'en_US') {
                                  context.setLocale(const Locale('en', 'US'));
                                }
                              }),
                        ],
                      ),
                      const Divider(
                        height: 20,
                        thickness: 1,
                      ),
                      TextButton(
                          onPressed: () => launchUrlString(
                              'https://medicalculator.shop/media/medical+calculator+app\'s+privacy+policy_220824.html'),
                          child: const Text('settings.privacyPolicy').tr()),
                      const Divider(
                        height: 20,
                        thickness: 1,
                      ),
                      const Text('settings.contact').tr(),
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
        drawer: const NavigationDrawer(index: 0));
  }
}
