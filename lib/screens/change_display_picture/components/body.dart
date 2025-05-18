import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ck_uddddnt/components/async_progress_dialog.dart';
import 'package:do_an_ck_uddddnt/components/default_button.dart';
import 'package:do_an_ck_uddddnt/constants.dart';
import 'package:do_an_ck_uddddnt/services/database/user_database_helper.dart';
import 'package:do_an_ck_uddddnt/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:do_an_ck_uddddnt/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:do_an_ck_uddddnt/services/database/image_picker_helper.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../provider_models/body_model.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChosenImage(),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Consumer<ChosenImage>(
                builder: (context, bodyState, child) {
                  return Column(
                    children: [
                      Text(
                        "Change Avatar",
                        style: headingStyle,
                      ),
                      SizedBox(height: getProportionateScreenHeight(40)),
                      GestureDetector(
                        child: buildDisplayPictureAvatar(context, bodyState),
                        onTap: () {
                          getImageFromUser(context, bodyState);
                        },
                      ),
                      SizedBox(height: getProportionateScreenHeight(80)),
                      buildChosePictureButton(context, bodyState),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      buildUploadPictureButton(context, bodyState),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      buildRemovePictureButton(context, bodyState),
                      SizedBox(height: getProportionateScreenHeight(80)),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDisplayPictureAvatar(
      BuildContext context, ChosenImage bodyState) {
    return StreamBuilder(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Logger().w(snapshot.error.toString());
          return CircleAvatar(
            radius: SizeConfig.screenWidth * 0.3,
            backgroundColor: kTextColor.withOpacity(0.5),
          );
        }

        ImageProvider? backImage;

        if (bodyState.imageBytes != null) {
          backImage = MemoryImage(bodyState.imageBytes!);
        } else if (snapshot.hasData && snapshot.data is DocumentSnapshot) {
          final docSnapshot = snapshot.data as DocumentSnapshot;
          final data = docSnapshot.data() as Map<String, dynamic>?;
          final String? url = data?[UserDatabaseHelper.DP_KEY];
          if (url != null) {
            backImage = NetworkImage(url);
          }
        }

        return CircleAvatar(
          radius: SizeConfig.screenWidth * 0.3,
          backgroundColor: kTextColor.withOpacity(0.5),
          backgroundImage: backImage,
        );
      }
    );
  }

  Future<void> getImageFromUser(BuildContext context, ChosenImage bodyState) async {
    try {
      final bytes = await pickImage(context);

      if (bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No image selected.")),
        );
        return;
      }

      bodyState.imageBytes = bytes;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }


  Widget buildChosePictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      text: "Choose Picture",
      press: () {
        getImageFromUser(context, bodyState);
      },
    );
  }

  Widget buildUploadPictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      text: "Upload Picture",
      press: () {
        final Future uploadFuture =
            uploadImageToFirestorage(context, bodyState);
        showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              uploadFuture,
              message: Text("Updating Display Picture"),
            );
          },
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Display Picture updated")));
      },
    );
  }

  Future<void> uploadImageToFirestorage(
      BuildContext context, ChosenImage bodyState) async {
    bool uploadDisplayPictureStatus = false;
    String snackbarMessage = '';
    try {
      final downloadUrl = await FirestoreFilesAccess().uploadBytesToPath(
        bodyState.imageBytes!,
        UserDatabaseHelper().getPathForCurrentUserDisplayPicture(),
      );

      uploadDisplayPictureStatus = await UserDatabaseHelper()
          .uploadDisplayPictureForCurrentUser(downloadUrl);
      if (uploadDisplayPictureStatus == true) {
        snackbarMessage = "Display Picture updated successfully";
      } else {
        throw "Coulnd't update display picture due to unknown reason";
      }
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
      snackbarMessage = "Something went wrong";
    } catch (e) {
      Logger().w("Unknown Exception: $e");
      snackbarMessage = "Something went wrong";
    } finally {
      Logger().i(snackbarMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage),
        ),
      );
    }
  }

  Widget buildRemovePictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      text: "Remove Picture",
      press: () async {
        final Future uploadFuture =
            removeImageFromFirestore(context, bodyState);
        await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              uploadFuture,
              message: Text("Deleting Display Picture"),
            );
          },
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Display Picture removed")));
        Navigator.pop(context);
      },
    );
  }

  Future<void> removeImageFromFirestore(
      BuildContext context, ChosenImage bodyState) async {
    bool status = false;
    String snackbarMessage = '';
    try {
      bool fileDeletedFromFirestore = false;
      fileDeletedFromFirestore = await FirestoreFilesAccess()
          .deleteFileFromPath(
              UserDatabaseHelper().getPathForCurrentUserDisplayPicture());
      if (fileDeletedFromFirestore == false) {
        throw "Couldn't delete file from Storage, please retry";
      }
      status = await UserDatabaseHelper().removeDisplayPictureForCurrentUser();
      if (status == true) {
        snackbarMessage = "Picture removed successfully";
      } else {
        throw "Coulnd't removed due to unknown reason";
      }
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
      snackbarMessage = "Something went wrong";
    } catch (e) {
      Logger().w("Unknown Exception: $e");
      snackbarMessage = "Something went wrong";
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
