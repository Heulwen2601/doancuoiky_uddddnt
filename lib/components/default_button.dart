import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  final String? text;
  final VoidCallback? press;
  final Color color;
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(70),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,  // Thiết lập màu nền của TextButton
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: press,
        child: Text(
          text!,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(10),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
