import 'package:do_an_ck_uddddnt/components/top_rounded_container.dart';
import 'package:do_an_ck_uddddnt/models/Product.dart';
import 'package:do_an_ck_uddddnt/models/Review.dart';
import 'package:do_an_ck_uddddnt/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'review_box.dart';

class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return TopRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: buildProductRatingWidget(product.rating),
          ),
          SizedBox(height: getProportionateScreenHeight(16)),
          Text(
            "Product Reviews",
            style: TextStyle(
              fontSize: 21,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          StreamBuilder<List<Review>>(
            stream: ProductDatabaseHelper()
                .getAllReviewsStreamForProductId(product.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                Logger().w(snapshot.error.toString());
                return Center(
                  child: Icon(Icons.error, color: kTextColor, size: 50),
                );
              } else if (snapshot.hasData) {
                final reviewsList = snapshot.data!;
                if (reviewsList.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/review.svg",
                            color: kTextColor,
                            width: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "No reviews yet",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true, // 🔥 BẮT BUỘC nếu nằm trong Column
                  itemCount: reviewsList.length,
                  itemBuilder: (context, index) {
                    return ReviewBox(review: reviewsList[index]);
                  },
                );
              } else {
                return Center(child: Text("Unknown state"));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildProductRatingWidget(num rating) {
    return Container(
      width: getProportionateScreenWidth(80),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$rating",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: getProportionateScreenWidth(16),
              ),
            ),
          ),
          SizedBox(width: 5),
          Icon(Icons.star, color: Colors.white),
        ],
      ),
    );
  }
}
