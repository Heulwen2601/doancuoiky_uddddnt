import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirestoreFilesAccess {
  FirestoreFilesAccess._privateConstructor();
  static FirestoreFilesAccess _instance =
      FirestoreFilesAccess._privateConstructor();
  factory FirestoreFilesAccess() {
    return _instance;
  }
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<String> uploadFileToPath(File file, String path) async {
    final Reference firestorageRef = FirebaseStorage.instance.ref();
    final snapshot = await firestorageRef.child(path).putFile(file);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<bool> deleteFileFromPath(String path) async {
    final Reference firestorageRef = FirebaseStorage.instance.ref();
    await firestorageRef.child(path).delete();
    return true;
  }

  ImageProvider getDeveloperImage() {
    return const AssetImage("assets/images/ava.jpg");
  }

  Future<String> uploadBytesToPath(Uint8List bytes, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putData(bytes);
    return await ref.getDownloadURL();
  }

}
