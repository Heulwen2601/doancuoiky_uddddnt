import 'package:do_an_ck_uddddnt/constants.dart';
import 'package:do_an_ck_uddddnt/models/AppReview.dart';
import 'package:do_an_ck_uddddnt/services/authentification/authentification_service.dart';
import 'package:do_an_ck_uddddnt/services/database/app_review_database_helper.dart';
import 'package:do_an_ck_uddddnt/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:do_an_ck_uddddnt/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_review_dialog.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(10)),
                Text(
                  "About Developer",
                  style: headingStyle,
                ),
                SizedBox(height: getProportionateScreenHeight(50)),
                InkWell(
                  onTap: () async {
                    const String linkedInUrl =
                        "https://www.facebook.com/lhnhu2004/";
                    await launchUrl(linkedInUrl);
                  },
                  child: buildDeveloperAvatar(),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Text(
                  '" Lam Huynh Nhu "',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "HCM",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Row(
                  children: [
                    Spacer(),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/github_icon.svg",
                        color: kTextColor.withOpacity(0.75),
                      ),
                      color: kTextColor.withOpacity(0.75),
                      iconSize: 40,
                      padding: EdgeInsets.all(16),
                      onPressed: () async {
                        const String githubUrl = "https://github.com/Heulwen2601/doancuoiky_uddddnt.git";
                        await launchUrl(githubUrl);
                      },
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(50)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      color: kTextColor.withOpacity(0.75),
                      iconSize: 50,
                      padding: EdgeInsets.all(16),
                      onPressed: () {
                        submitAppReview(context, liked: true);
                      },
                    ),
                    Text(
                      "Liked the app?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.thumb_down),
                      padding: EdgeInsets.all(16),
                      color: kTextColor.withOpacity(0.75),
                      iconSize: 50,
                      onPressed: () {
                        submitAppReview(context, liked: false);
                      },
                    ),
                    Spacer(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeveloperAvatar() {
    return FutureBuilder<String>(
        future: FirestoreFilesAccess().getDeveloperImage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final url = snapshot.data!;
            return CircleAvatar(
              radius: SizeConfig.screenWidth * 0.3,
              backgroundColor: kTextColor.withOpacity(0.75),
              backgroundImage: NetworkImage(url),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error.toString();
            Logger().e(error);
          }
          return CircleAvatar(
            radius: SizeConfig.screenWidth * 0.3,
            backgroundColor: kTextColor.withOpacity(0.75),
          );
        });
  }

  Future<void> launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Logger().i("LinkedIn URL was unable to launch");
      }
    } catch (e) {
      Logger().e("Exception while launching URL: $e");
    }
  }

  Future<void> submitAppReview(BuildContext context,
      {bool liked = true}) async {
    AppReview? prevReview;
    try {
      prevReview = await AppReviewDatabaseHelper().getAppReviewOfCurrentUser();
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
    } catch (e) {
      Logger().w("Unknown Exception: $e");
    } finally {
      if (prevReview == null) {
        prevReview = AppReview(
          AuthentificationService().currentUser.uid,
          liked: liked,
          feedback: "",
        );
      }
    }

    final AppReview? result = await showDialog(
      context: context,
      builder: (context) {
        return AppReviewDialog(
          appReview: prevReview  ?? AppReview(
            '0',
            liked: false,
            feedback: ''
          ),
        );
      },
    );
    if (result != null) {
      result.liked = liked;
      bool reviewAdded = false;
      String snackbarMessage = '';
      try {
        reviewAdded = await AppReviewDatabaseHelper().editAppReview(result);
        if (reviewAdded == true) {
          snackbarMessage = "Feedback submitted successfully";
        } else {
          throw "Coulnd't add feeback due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = e.toString();
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }
}
