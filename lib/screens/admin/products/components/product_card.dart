import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String variant;
  final int originalPrice;
  final int discountPrice;
  final String thumbnail;

  const ProductCard({
    Key? key,
    required this.title,
    required this.variant,
    required this.originalPrice,
    required this.discountPrice,
    required this.thumbnail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.network(thumbnail, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(variant),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$$originalPrice', style: const TextStyle(decoration: TextDecoration.lineThrough)),
            Text('\$$discountPrice', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
