import 'dart:io';

import 'package:flutter/cupertino.dart';

class ChosenImage extends ChangeNotifier {
  late File _chosenImage;

  File get chosenImage => _chosenImage;
  set setChosenImage(File img) {
    _chosenImage = img;
    notifyListeners();
  }
}
