import 'dart:io';

import 'package:do_an_ck_uddddnt/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:do_an_ck_uddddnt/exceptions/local_files_handling/local_file_handling_exception.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

Future<String> choseImageFromLocalFiles(
  BuildContext context, {
  int maxSizeInKB = 1024,
  int minSizeInKB = 5,
}) async {
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    final PermissionStatus photoPermissionStatus =
        await Permission.photos.request();
    if (!photoPermissionStatus.isGranted) {
      throw LocalFileHandlingStorageReadPermissionDeniedException(
          message: "Permission required to read storage, please give permission");
    }
  }

  final imgPicker = ImagePicker();
  final imgSource = await showDialog<ImageSource>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Choose image source"),
        actions: [
          TextButton(
            child: Text("Camera"),
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          TextButton(
            child: Text("Gallery"),
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
        ],
      );
    },
  );

  if (imgSource == null) {
    throw LocalImagePickingInvalidImageException(
        message: "No image source selected");
  }

  final XFile? imagePicked = await imgPicker.pickImage(source: imgSource);

  if (imagePicked == null) {
    throw LocalImagePickingInvalidImageException();
  }

  if (kIsWeb) {
    final bytes = await imagePicked.readAsBytes();
    final fileSize = bytes.lengthInBytes;

    if (fileSize > (maxSizeInKB * 1024) || fileSize < (minSizeInKB * 1024)) {
      throw LocalImagePickingFileSizeOutOfBoundsException(
          message:
              "Image size should be between $minSizeInKB KB and $maxSizeInKB KB");
    }

    final fileExtension = imagePicked.name.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      throw LocalImagePickingInvalidImageException(
          message: "Unsupported image format: $fileExtension");
    }

    // Convert to base64 string to use as image src
    return "data:image/$fileExtension;base64,${base64Encode(bytes)}";
  } else {
    final fileLength = await File(imagePicked.path).length();

    if (fileLength > (maxSizeInKB * 1024) ||
        fileLength < (minSizeInKB * 1024)) {
      throw LocalImagePickingFileSizeOutOfBoundsException(
          message:
              "Image size should be between $minSizeInKB KB and $maxSizeInKB KB");
    }

    final fileExtension = imagePicked.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      throw LocalImagePickingInvalidImageException(
          message: "Unsupported image format: $fileExtension");
    }

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imagePicked.path);
    final savedImagePath = path.join(appDir.path, fileName);
    final savedImage = await File(imagePicked.path).copy(savedImagePath);

    return savedImage.path;
  }
}
