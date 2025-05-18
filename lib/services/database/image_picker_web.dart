import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

Future<Uint8List?> pickImage(BuildContext context) async {
  return await ImagePickerWeb.getImageAsBytes();
}
