import 'package:do_an_ck_uddddnt/components/async_progress_dialog.dart';
import 'package:do_an_ck_uddddnt/constants.dart';
import 'package:do_an_ck_uddddnt/screens/about_developer/about_developer_screen.dart';
import 'package:do_an_ck_uddddnt/screens/admin/admin_screen.dart';
import 'package:do_an_ck_uddddnt/screens/change_display_picture/change_display_picture_screen.dart';
import 'package:do_an_ck_uddddnt/screens/change_email/change_email_screen.dart';
import 'package:do_an_ck_uddddnt/screens/change_password/change_password_screen.dart';
import 'package:do_an_ck_uddddnt/screens/change_phone/change_phone_screen.dart';
import 'package:do_an_ck_uddddnt/screens/edit_product/edit_product_screen.dart';
import 'package:do_an_ck_uddddnt/screens/manage_addresses/manage_addresses_screen.dart';
import 'package:do_an_ck_uddddnt/screens/my_orders/my_orders_screen.dart';
import 'package:do_an_ck_uddddnt/screens/my_products/my_products_screen.dart';
import 'package:do_an_ck_uddddnt/services/authentification/authentification_service.dart';
import 'package:do_an_ck_uddddnt/services/database/user_database_helper.dart';
import 'package:do_an_ck_uddddnt/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import '../../change_display_name/change_display_name_screen.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<User?>(
        stream: AuthentificationService().userChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                buildUserAccountsHeader(user),
                buildEditAccountExpansionTile(context),
                ListTile(
                  leading: const Icon(Icons.edit_location),
                  title: const Text("Manage Addresses", style: TextStyle(fontSize: 16, color: Colors.black)),
                  onTap: () async {
                    bool allowed = AuthentificationService().currentUserVerified;
                    if (!allowed) {
                      final reverify = await showConfirmationDialog(
                        context,
                        "You haven't verified your email address. This action is only allowed for verified users.",
                        positiveResponse: "Resend verification email",
                        negativeResponse: "Go back",
                      );
                      if (reverify) {
                        final future = AuthentificationService().sendVerificationEmailToCurrentUser();
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AsyncProgressDialog(
                              future,
                              message: const Text("Resending verification email"),
                            );
                          },
                        );
                      }
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageAddressesScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit_location),
                  title: const Text("My Orders", style: TextStyle(fontSize: 16, color: Colors.black)),
                  onTap: () async {
                    bool allowed = AuthentificationService().currentUserVerified;
                    if (!allowed) {
                      final reverify = await showConfirmationDialog(
                        context,
                        "You haven't verified your email address. This action is only allowed for verified users.",
                        positiveResponse: "Resend verification email",
                        negativeResponse: "Go back",
                      );
                      if (reverify) {
                        final future = AuthentificationService().sendVerificationEmailToCurrentUser();
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AsyncProgressDialog(
                              future,
                              message: const Text("Resending verification email"),
                            );
                          },
                        );
                      }
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyOrdersScreen()),
                    );
                  },
                ),
                buildSellerExpansionTile(context),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("About Developer", style: TextStyle(fontSize: 16, color: Colors.black)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutDeveloperScreen()));
                  },
                ),

                // ✅ ADMIN PANEL chỉ hiển thị với email cụ thể
                if (user.email == 'huynhnhuhn2004@gmail.com')
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text("Admin Panel", style: TextStyle(fontSize: 16, color: Colors.black)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminScreen()),
                      );
                    },
                  ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Sign out", style: TextStyle(fontSize: 16, color: Colors.black)),
                  onTap: () async {
                    final confirmation = await showConfirmationDialog(context, "Confirm Sign out ?");
                    if (confirmation) AuthentificationService().signOut();
                  },
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Icon(Icons.error));
          }
        },
      ),
    );
  }

  UserAccountsDrawerHeader buildUserAccountsHeader(User user) {
    return UserAccountsDrawerHeader(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(color: kTextColor.withOpacity(0.15)),
      accountEmail: Text(
        user.email ?? "No Email",
        style: const TextStyle(fontSize: 15, color: Colors.black),
      ),
      accountName: Text(
        user.displayName ?? "No Name",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      currentAccountPicture: FutureBuilder(
        future: UserDatabaseHelper().displayPictureForCurrentUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(backgroundImage: NetworkImage(snapshot.data!));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            Logger().w(snapshot.error.toString());
          }
          return const CircleAvatar(backgroundColor: kTextColor);
        },
      ),
    );
  }

  ExpansionTile buildEditAccountExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.person),
      title: const Text("Edit Account", style: TextStyle(fontSize: 16, color: Colors.black)),
      children: [
        ListTile(
          title: const Text("Change Display Picture", style: TextStyle(color: Colors.black, fontSize: 15)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeDisplayPictureScreen())),
        ),
        ListTile(
          title: const Text("Change Display Name", style: TextStyle(color: Colors.black, fontSize: 15)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeDisplayNameScreen())),
        ),
        ListTile(
          title: const Text("Change Phone Number", style: TextStyle(color: Colors.black, fontSize: 15)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePhoneScreen())),
        ),
        ListTile(
          title: const Text("Change Email", style: TextStyle(color: Colors.black, fontSize: 15)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmailScreen())),
        ),
        ListTile(
          title: const Text("Change Password", style: TextStyle(color: Colors.black, fontSize: 15)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen())),
        ),
      ],
    );
  }

  Widget buildSellerExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.business),
      title: const Text("I am Seller", style: TextStyle(fontSize: 16, color: Colors.black)),
      children: [
        ListTile(
          title: const Text("Add New Product", style: TextStyle(color: Colors.black, fontSize: 15)),
          onTap: () async {
            bool allowed = AuthentificationService().currentUserVerified;
            if (!allowed) {
              final reverify = await showConfirmationDialog(
                context,
                "You haven't verified your email address. This action is only allowed for verified users.",
                positiveResponse: "Resend verification email",
                negativeResponse: "Go back",
              );
              if (reverify) {
                final future = AuthentificationService().sendVerificationEmailToCurrentUser();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AsyncProgressDialog(
                      future,
                      message: const Text("Resending verification email"),
                    );
                  },
                );
              }
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductScreen()));
          },
        ),
        ListTile(
          title: const Text("Manage My Products", style: TextStyle(color: Colors.black, fontSize: 15)),
          onTap: () async {
            bool allowed = AuthentificationService().currentUserVerified;
            if (!allowed) {
              final reverify = await showConfirmationDialog(
                context,
                "You haven't verified your email address. This action is only allowed for verified users.",
                positiveResponse: "Resend verification email",
                negativeResponse: "Go back",
              );
              if (reverify) {
                final future = AuthentificationService().sendVerificationEmailToCurrentUser();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AsyncProgressDialog(
                      future,
                      message: const Text("Resending verification email"),
                    );
                  },
                );
              }
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyProductsScreen()));
          },
        ),
      ],
    );
  }
}
