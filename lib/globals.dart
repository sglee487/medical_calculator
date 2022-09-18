import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:localstorage/localstorage.dart";

GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>['email']);

class Globals {
  final LocalStorage storage = LocalStorage('app');
  late Map<String, dynamic> user;
  late List<dynamic> recents;

  static final Globals _instance = Globals._internal();

  factory Globals() {
    return _instance;
  }

  Globals._internal() {
    user = {
      'id': '',
      'type': '',
      'email': '',
      'token': '',
    };

    recents = [];
  }

  bool isLogined() {
    return user['id'] != '';
  }

  void logout() {
    if (user['type'] == 'google') {
      googleSignIn.disconnect();
    }

    user = {
      'id': '',
      'type': '',
      'email': '',
      'token': '',
    };

    storage.ready.then((_) {
      storage.deleteItem('user');
    });
  }
}
