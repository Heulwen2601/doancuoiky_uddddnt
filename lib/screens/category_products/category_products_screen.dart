import 'package:do_an_ck_uddddnt/models/Product.dart';

import 'package:flutter/material.dart';

import 'components/body.dart';

class CategoryProductsScreen extends StatelessWidget {
  final ProductType productType;

  const CategoryProductsScreen({
    Key? key,
    required this.productType,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        productType: productType,
      ),
    );
  }
}
