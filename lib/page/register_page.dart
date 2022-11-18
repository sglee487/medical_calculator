import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:easy_localization/easy_localization.dart';

import '/components/navigation_drawer.dart';
import '/components/topBar.dart';

import '/constants.dart';
import '/utils.dart';
import '/api.dart';
// import '/globals.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  void _signUp(context) async {
    if (!EmailValidator.validate(_emailController.text)) {
      showSimpleDialog(context, 'message.enterValidEmail'.tr());
      return;
    }

    if (!RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(_passwordController.text)) {
      showSimpleDialog(context, 'message.passwordStrict'.tr());
      return;
    }

    if (_passwordController.text != _passwordConfirmController.text) {
      showSimpleDialog(context, 'message.confirmPassword'.tr());
      return;
    }

    try {
      await register(_emailController.text, _passwordController.text);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('message.registerSuccess'.tr()),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.popAndPushNamed(context, '/login'),
            ),
          ],
        ),
      );
    } catch (e) {
      showSimpleDialog(context, 'message.unableRegister'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: 'common.register'.tr()),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(color: kBackgroundColor1),
            child: Center(
              child: SizedBox(
                width: kDefaultWidth * 0.75,
                child: Column(
                  children: [
                    Text('common.register'.tr()),
                    Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'common.email'.tr(),
                          ),
                        ),
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
                          controller: _passwordConfirmController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'common.passwordConfirm'.tr(),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                0, kDefaultPadding, 0, 5),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _signUp(context);
                              },
                              icon: const Icon(Icons.app_registration_rounded),
                              label: const Text('common.register').tr(),
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
                                    context, '/login');
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
