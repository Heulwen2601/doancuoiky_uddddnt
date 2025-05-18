import 'package:do_an_ck_uddddnt/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:do_an_ck_uddddnt/size_config.dart';
import 'package:do_an_ck_uddddnt/constants.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(10),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(10),
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
