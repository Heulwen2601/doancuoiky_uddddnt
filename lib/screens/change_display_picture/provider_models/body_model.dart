import 'dart:typed_data';
import 'package:flutter/material.dart';

class ChosenImage extends ChangeNotifier {
  Uint8List? _imageBytes;

  Uint8List? get imageBytes => _imageBytes;

  set imageBytes(Uint8List? value) {
    _imageBytes = value;
    notifyListeners();
  }

  void clear() {
    _imageBytes = null;
    notifyListeners();
  }
}
