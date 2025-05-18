import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String userName;
  final String productName;
  final String productImageUrl;
  final String orderDate;

  const OrderCard({
    Key? key,
    required this.userName,
    required this.productName,
    required this.productImageUrl,
    required this.orderDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: productImageUrl.isNotEmpty
            ? Image.network(
                productImageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.image_not_supported),
        title: Text(productName),
        subtitle: Text("User: $userName\nOrder date: $orderDate"),
      ),
    );
  }
}
