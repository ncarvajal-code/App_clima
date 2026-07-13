import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool isLogged = false;

  void login() {
    isLogged = true;
    notifyListeners();
  }

  void logout() {
    isLogged = false;
    notifyListeners();
  }
}