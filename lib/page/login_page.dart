import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:easy_localization/easy_localization.dart';

import '/components/navigation_drawer.dart';
import '/components/topBar.dart';

import '/api.dart';
import '/constants.dart';
import '/utils.dart';
import '/globals.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // google sign in
  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen(
        (GoogleSignInAccount? account) async {
      if (account != null) {
        // logined with google
        var loginResponse = await login(
            'google', account.email, 'google:${account.email}',
            socialAccountId: account.id);
        showToastMessage(loginResponse['user_email']);
        Navigator.popAndPushNamed(context, '/settings');
      } else {
        // logout with google
        showToastMessage('common.logout'.tr());
      }
    }, onError: (Object err) {
      print('Error signing in: $err');
    });
  }

  void _loginEmail(context) async {
    if (!EmailValidator.validate(_emailController.text)) {
      showSimpleDialog(context, 'message.enterValidEmail'.tr());
      return;
    }

    if (!RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(_passwordController.text)) {
      showSimpleDialog(context, 'message.passwordStrict'.tr());
      return;
    }

    try {
      await login('email', _emailController.text, _passwordController.text);
      showSimpleDialog(context, _emailController.text);
      Navigator.popAndPushNamed(context, '/settings');
    } catch (e) {
      showSimpleDialog(context, 'message.wrongEmailOrPassword'.tr());
    }
  }

  // https://www.youtube.com/watch?v=1k-gITZA9CI
  void _loginGoogle(context) async {
    try {
      googleSignIn.signIn();
    } catch (e) {
      print(e);
      showSimpleDialog(context, 'message.unableLogin'.tr());
    }
  }

  void _loginApple(context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.site.medicalcalculator1',
          redirectUri: Uri.parse(dotenv.env['APPLE_ANDROID_LOGIN_URL']!),
        ),
      );

      if (credential == null || credential.email == '') {
        return;
      }
      var loginResponse = await login(
          'apple', credential.email ?? '', 'apple:${credential.email}',
          socialAccountId: credential.userIdentifier);
      showToastMessage(loginResponse['user_email']);
      Navigator.popAndPushNamed(context, '/settings');
    } catch (e) {
      print(e);
      showSimpleDialog(context, 'message.unableLogin'.tr());
    }

    return;
  }

  void _forgotPassword(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('message.enterEmailAddress', style: kLabelStyle).tr(),
        content: TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
        ),
        actions: [
          TextButton(
            child: const Text('common.cancel').tr(),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('common.send').tr(),
            onPressed: () async {
              if (!EmailValidator.validate(_emailController.text)) {
                showErrorToast('message.enterValidEmail'.tr());
                return;
              }
              try {
                await forgotPassword(_emailController.text);

                if (!mounted) {
                  return;
                }

                Navigator.pop(context);
                showToastMessage('message.passwordResetEmailSent'.tr());
              } catch (e) {
                showErrorToast('message.tryLater'.tr());
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: 'common.login'.tr()),
        backgroundColor: kBackgroundColor1,
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: kDefaultWidth * 0.75,
              child: Column(
                children: [
                  const Text('common.medicalCalculator').tr(),
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
                        textInputAction: TextInputAction.next,
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
                        onFieldSubmitted: (_) => _loginEmail(context),
                        textInputAction: TextInputAction.go,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/register');
                                  },
                                  icon: const Icon(
                                      Icons.app_registration_rounded),
                                  label: const Text('common.signUp').tr(),
                                  style: TextButton.styleFrom(
                                      primary: Colors.black54))),
                          Padding(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: TextButton.icon(
                                  onPressed: () {
                                    _loginEmail(context);
                                  },
                                  icon: const Icon(Icons.login_rounded),
                                  label: const Text('common.signIn').tr(),
                                  style: TextButton.styleFrom(
                                      primary: Colors.black54))),
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                    height: kDefaultPadding,
                    thickness: 1,
                    color: Colors.transparent,
                  ),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      const Text('common.or').tr(),
                      const Expanded(child: Divider())
                    ],
                  ),
                  const Divider(
                    height: kDefaultPadding,
                    thickness: 1,
                    color: Colors.transparent,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {}, // needed
                      child: SignInButton(
                        Buttons.Google,
                        text: 'common.signInWithGoogle'.tr(),
                        padding: const EdgeInsets.all(10),
                        onPressed: () {
                          _loginGoogle(context);
                        },
                      ),
                    ),
                  ),
                  const Divider(
                    height: kDefaultPadding,
                    thickness: 1,
                    color: Colors.transparent,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {}, // needed
                      child: SignInButton(
                        Buttons.Apple,
                        text: 'common.signInWithApple'.tr(),
                        padding: const EdgeInsets.all(10),
                        onPressed: () {
                          _loginApple(context);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        0, kDefaultPadding, 0, kDefaultPadding / 2),
                    child: TextButton(
                        onPressed: () {
                          _forgotPassword(context);
                        },
                        child: const Text('common.areYouLossPassword').tr()),
                  )
                ],
              ),
            ),
          ),
        ),
        drawer: const NavigationDrawer(index: 0));
  }
}
