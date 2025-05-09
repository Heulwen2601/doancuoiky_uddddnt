import 'package:do_an_ck_uddddnt/models/Product.dart';
import 'package:do_an_ck_uddddnt/screens/edit_product/provider_models/ProductDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';

class EditProductScreen extends StatelessWidget {
  final Product? productToEdit;

  const EditProductScreen({
    Key? key, 
    this.productToEdit
    }) 
  : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetails(),
      child: Scaffold(
        appBar: AppBar(),
        body: Body(
          productToEdit: productToEdit  ?? Product(
            '0',
            productType: ProductType.Electronics,
            images: [],
            title: 'Default Product',
            variant: 'Default Variant',
            discountPrice: 0.0,
            originalPrice: 0.0,
            rating: 0.0,
            highlights: 'No highlights',
            description: 'No description available',
            seller: 'Unknown',
            owner: 'Unknown',
            searchTags: [],
          ),
        ),
      ),
    );
  }
}
