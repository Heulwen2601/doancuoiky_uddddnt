import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'product_card.dart';

class AllProductsBody extends StatelessWidget {
  const AllProductsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi khi tải sản phẩm'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            return ProductCard(
              title: data['title'] ?? '',
              variant: data['variant'] ?? '',
              originalPrice: data['original_price'] ?? 0,
              discountPrice: data['discount_price'] ?? 0,
              thumbnail: (data['images'] as List).isNotEmpty ? data['images'][0] : '',
            );
          },
        );
      },
    );
  }
}
