import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _soundEffects = true;
  bool _biometricAuth = true;

  bool get pushNotifications => _pushNotifications;
  bool get emailNotifications => _emailNotifications;
  bool get smsNotifications => _smsNotifications;
  bool get soundEffects => _soundEffects;
  bool get biometricAuth => _biometricAuth;

  void togglePushNotifications(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  void toggleEmailNotifications(bool value) {
    _emailNotifications = value;
    notifyListeners();
  }

  void toggleSMSNotifications(bool value) {
    _smsNotifications = value;
    notifyListeners();
  }

  void toggleSoundEffects(bool value) {
    _soundEffects = value;
    notifyListeners();
  }

  void toggleBiometricAuth(bool value) {
    _biometricAuth = value;
    notifyListeners();
  }
}
