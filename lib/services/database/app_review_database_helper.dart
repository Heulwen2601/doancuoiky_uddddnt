import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ck_uddddnt/models/AppReview.dart';
import 'package:do_an_ck_uddddnt/services/authentification/authentification_service.dart';

class AppReviewDatabaseHelper {
  static const String APP_REVIEW_COLLECTION_NAME = "app_reviews";

  AppReviewDatabaseHelper._privateConstructor();
  static AppReviewDatabaseHelper _instance =
      AppReviewDatabaseHelper._privateConstructor();
  factory AppReviewDatabaseHelper() {
    return _instance;
  }
  late FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<bool> editAppReview(AppReview appReview) async {
    final uid = AuthentificationService().currentUser.uid;
    final docRef = firestore.collection(APP_REVIEW_COLLECTION_NAME).doc(uid);
    final docData = await docRef.get();
    if (docData.exists) {
      docRef.update(appReview.toUpdateMap());
    } else {
      docRef.set(appReview.toMap());
    }
    return true;
  }

  Future<AppReview> getAppReviewOfCurrentUser() async {
    try {
      final uid = AuthentificationService().currentUser?.uid;
      if (uid == null) {
        throw Exception("User is not logged in");
      }

      final docRef = firestore.collection(APP_REVIEW_COLLECTION_NAME).doc(uid);
      final docData = await docRef.get();

      if (docData.exists && docData.data() != null) {
        final appReview = AppReview.fromMap(docData.data()!, id: docData.id);
        return appReview;
      } else {
        final appReview = AppReview(uid, liked: true, feedback: "");
        await docRef.set(appReview.toMap());
        return appReview;
      }
    } catch (e) {
      print('Error fetching or creating app review: $e');
      rethrow;
    }
  }
}
