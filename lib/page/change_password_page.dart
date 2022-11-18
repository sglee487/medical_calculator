import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '/components/navigation_drawer.dart';
import '/components/topBar.dart';

import '/constants.dart';
import '/utils.dart';
import '/api.dart';
import '/globals.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmController =
      TextEditingController();

  void _changePassword(context) async {
    if (!RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(_passwordController.text)) {
      showSimpleDialog(context, 'message.passwordStrict'.tr());
      return;
    }

    if (!RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(_newPasswordController.text)) {
      showSimpleDialog(context, 'message.passwordStrict'.tr());
      return;
    }

    if (_newPasswordController.text != _newPasswordConfirmController.text) {
      showSimpleDialog(context, 'message.confirmPassword'.tr());
      return;
    }

    try {
      await changePassword(
          _passwordController.text, _newPasswordController.text);
      Globals().logout();
      Navigator.pushReplacementNamed(context, '/settings');

      showSimpleDialog(context, 'message.changePasswordSeccess'.tr());
    } on DioError {
      showSimpleDialog(context, 'message.confirmPassword'.tr());
    } catch (e) {
      showSimpleDialog(context, 'message.unableRegister'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: 'common.changePassword'.tr()),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(color: kBackgroundColor1),
            child: Center(
              child: SizedBox(
                width: kDefaultWidth * 0.75,
                child: Column(
                  children: [
                    const Text('common.changePassword').tr(),
                    Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'common.password'.tr(),
                          ),
                        ),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'common.newPassword'.tr(),
                          ),
                        ),
                        TextFormField(
                          controller: _newPasswordConfirmController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'common.newPasswordConfirm'.tr(),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                0, kDefaultPadding, 0, 5),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _changePassword(context);
                              },
                              icon: const Icon(Icons.app_registration_rounded),
                              label: const Text('common.changePassword').tr(),
                            )),
                        const Divider(
                          height: 10,
                          thickness: 1,
                          color: Colors.transparent,
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                0, 5, 0, kDefaultPadding),
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/settings');
                              },
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              label: const Text('common.back').tr(),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: const NavigationDrawer(index: 0));
  }
}
