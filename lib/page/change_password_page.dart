import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmController =
      TextEditingController();

  void _changePassword(context) async {
    if (!RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(_passwordController.text)) {
      showSimpleDialog(context,
          'Please enter a password with at least 8 characters, one lowercase letter and one number.');
      return;
    }

    if (!RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(_newPasswordController.text)) {
      showSimpleDialog(context,
          'Please enter a password with at least 8 characters, one lowercase letter and one number.');
      return;
    }

    if (_newPasswordController.text != _newPasswordConfirmController.text) {
      showSimpleDialog(context, 'Please confirm your password.');
      return;
    }

    try {
      await changePassword(
          _passwordController.text, _newPasswordController.text);
      Globals().logout();
      Navigator.pushNamed(context, '/settings');

      showSimpleDialog(
          context, 'Change password success!\nPlease login again.');
    } on DioError {
      showSimpleDialog(context, 'Please confirm your password.');
    } catch (e) {
      showSimpleDialog(context, 'Unable to register. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TopBar(title: 'Change Password'),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(color: kBackgroundColor1),
            child: Center(
              child: SizedBox(
                width: kDefaultWidth * 0.75,
                child: Column(
                  children: [
                    const Text('Change Password'),
                    Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'New password',
                          ),
                        ),
                        TextFormField(
                          controller: _newPasswordConfirmController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'New Password Confirm',
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
                              label: const Text('Change Password'),
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
                                Navigator.pushNamed(context, '/settings');
                              },
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              label: const Text('Back'),
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
