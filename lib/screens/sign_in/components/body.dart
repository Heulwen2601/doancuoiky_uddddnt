import 'package:do_an_ck_uddddnt/constants.dart';

import 'sign_in_form.dart';

import '../../../size_config.dart';
import 'package:flutter/material.dart';
import '../../../components/no_account_text.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Center(
                  child: Text(
                    "Welcome Back",
                    style: headingStyle.copyWith(
                      fontSize: getProportionateScreenWidth(36),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Sign in with your email and password",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                SignInForm(),
                SizedBox(height: getProportionateScreenHeight(20)),
                Center(child: NoAccountText()),
                SizedBox(height: getProportionateScreenHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
