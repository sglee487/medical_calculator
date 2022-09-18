import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './page/ready_page.dart';
import './page/settings_page.dart';
import './page/register_page.dart';
import './page/login_page.dart';
import './page/change_password_page.dart';
import './page/epinephrine_rate_page.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  await initializeDateFormatting('kr_KR', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return CustomRoute(builder: (_) => ReadyPage(), settings: settings);
          case '/settings':
            return CustomRoute(
                builder: (_) => SettingsPage(), settings: settings);
          case '/register':
            return CustomRoute(
                builder: (_) => const RegisterPage(), settings: settings);
          case '/login':
            return CustomRoute(
                builder: (_) => const LoginPage(), settings: settings);
          case '/changePassword':
            return CustomRoute(
                builder: (_) => const ChangePasswordPage(), settings: settings);
          case '/epinephrine':
            return CustomRoute(
                builder: (_) => const EpinephrineRatePage(),
                settings: settings);
        }
        return null;
      },
    );
  }
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: child);
  }
}
