import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  TokenService();
  //Key SharedPreferences
  static const accessTokenKey = 'accessToken';
  static const isFirstInstallKey = 'isFirstInstall';

  static const deviceIdKey = 'device-id';

  //Function

  //Handle AccessToken
  saveTokens({required String accessToken}) async {
    try {
      final storage = await SharedPreferences.getInstance();
      await storage.setString(accessTokenKey, accessToken);
    } catch (e) {
      return;
    }
  }
  FutureOr<String?> getAccessToken() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getString(accessTokenKey);
  }

  //Handle App Install
  FutureOr<void> setFirstInstall({required bool isFirstInstall}) async {
    try {
      final storage = await SharedPreferences.getInstance();
      await storage.setBool(isFirstInstallKey, isFirstInstall);
    } catch (e) {
      return;
    }
  }
  FutureOr<bool?> getFirstInstall() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getBool(isFirstInstallKey);
  }

  //Handle Device Id
  saveDeviceId({required String deviceId}) async {
    try {
      final storage = await SharedPreferences.getInstance();
      await storage.setString(deviceIdKey, deviceId);
    } catch (e) {
      return;
    }
  }
}
