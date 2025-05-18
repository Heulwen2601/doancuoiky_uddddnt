import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrdersScreen extends StatefulWidget {
  final String userId;

  const UserOrdersScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  late Future<List<Map<String, dynamic>>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = fetchUserOrders();
  }

  Future<List<Map<String, dynamic>>> fetchUserOrders() async {
    List<Map<String, dynamic>> orders = [];

    // Lấy tên người dùng từ addresses
    String userName = 'Người dùng';
    try {
      final addressSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('addresses')
          .limit(1)
          .get();

      if (addressSnapshot.docs.isNotEmpty) {
        final addressData = addressSnapshot.docs.first.data();
        userName = addressData['receiver'] ?? userName;
      }
    } catch (e) {
      print("Không thể lấy tên người dùng: $e");
    }

    // Lấy danh sách đơn hàng
    final orderSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('ordered_products')
        .get();

    for (var doc in orderSnapshot.docs) {
      final data = doc.data();
      final productUid = data['product_uid'] ?? '';
      final orderDate = data['order_date'] ?? '';

      if (productUid.isEmpty) continue;

      try {
        final productDoc = await FirebaseFirestore.instance
            .collection('products')
            .doc(productUid)
            .get();

        if (!productDoc.exists) continue;

        final productData = productDoc.data();
        final productName = productData?['title'] ?? 'Không rõ tên sản phẩm';

        // Xử lý ảnh
        String productImage = '';
        final images = productData?['images'];
        if (images is List && images.isNotEmpty) {
          productImage = images.first.toString();
        } else if (images is String) {
          productImage = images;
        }

        orders.add({
          'user_name': userName,
          'product_name': productName,
          'product_image': productImage,
          'order_date': orderDate,
        });
      } catch (e) {
        print("Lỗi khi lấy thông tin sản phẩm $productUid: $e");
      }
    }

    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đơn hàng của người dùng')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text("Không có đơn hàng."));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                leading: order['product_image'].isNotEmpty
                    ? Image.network(order['product_image'], width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image_not_supported),
                title: Text(order['product_name']),
                subtitle: Text(
                  "Người đặt: ${order['user_name']}\nNgày đặt: ${order['order_date']}",
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
