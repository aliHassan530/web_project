import 'dart:io';

import 'package:flutter/cupertino.dart';

class MainProvider extends ChangeNotifier {
  bool isLoading = false;
  changeIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
