import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';

import '/globals.dart';

String baseUrl = dotenv.env['BASE_URL'] ?? '';
String djangoToken = dotenv.env['DJANGO_TOKEN'] ?? '';

Future login(String type, String email, String password,
    {String? socialAccountId}) async {
  Globals globals = Globals();
  LocalStorage storage = LocalStorage('app');
  try {
    var data = {
      'type': type,
      'email': email,
      'username': type == 'email' ? email : password,
      'password': password
    };
    if (socialAccountId != null) {
      data['social_account_id'] = socialAccountId;
    }
    var response = await Dio().post('$baseUrl/token/',
        data: data,
        options: Options(headers: {'Authorization': 'Token $djangoToken'}));
    if (response.statusCode == 200) {
      var data = response.data;

      globals.user['id'] = data['user_id'];
      globals.user['type'] = type;
      globals.user['email'] = data['user_email'];
      globals.user['token'] = data['token'];

      // Save user data to local storage
      await storage.ready;
      await storage.setItem('user', globals.user);

      return Future.value(data);
    } else {
      return Future.error(response.data);
    }
  } catch (e) {
    return Future.error(e);
  }
}

Future register(String email, String password) async {
  try {
    var response = await Dio().post('$baseUrl/user/',
        data: {'email': email, 'username': email, 'password': password},
        options: Options(
          headers: {'Authorization': 'Token $djangoToken'},
        ));

    if (response.statusCode == 201) {
      var data = response.data;

      return Future.value(data);
    }
  } catch (e) {
    return Future.error(e);
  }
}

Future changePassword(String password, String newPassword) async {
  Globals globals = Globals();

  try {
    var response = await Dio().patch('$baseUrl/user/${globals.user['id']}/',
        data: {
          "username": globals.user['email'],
          "password": password,
          "new_password": newPassword,
        },
        options: Options(headers: {'Authorization': 'Token $djangoToken'}));

    if (response.statusCode == 200) {
      return Future.value(response.data);
    }
    return Future.error(response.data);
  } catch (e) {
    return Future.error(e);
  }
}

Future forgotPassword(String email) async {
  FormData formData = FormData.fromMap({
    'email': email,
  });
  try {
    var response = await Dio().post('$baseUrl/reset-password/',
        data: formData,
        options: Options(headers: {'Authorization': 'Token $djangoToken'}));

    if (response.statusCode == 200) {
      return Future.value(response.data);
    }
    return Future.error(response.data);
  } catch (e) {
    return Future.error(e);
  }
}

Future removeAccount() async {
  Globals globals = Globals();

  try {
    var response = await Dio().delete('$baseUrl/user/${globals.user['id']}/',
        data: {'username': Globals().user['email']},
        options: Options(
          headers: {'Authorization': 'Token $djangoToken'},
        ));

    if (response.statusCode == 200) {
      var data = response.data;

      return Future.value(data);
    }
  } catch (e) {
    return Future.error(e);
  }
}
