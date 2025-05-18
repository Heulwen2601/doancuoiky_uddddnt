import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:do_an_ck_uddddnt/models/OrderItem.dart';
import 'order_card.dart';

class AllOrdersBody extends StatefulWidget {
  const AllOrdersBody({Key? key}) : super(key: key);

  @override
  State<AllOrdersBody> createState() => _AllOrdersBodyState();
}

class _AllOrdersBodyState extends State<AllOrdersBody> {
  late Future<List<OrderItem>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = fetchAllOrders();
  }

  Future<List<OrderItem>> fetchAllOrders() async {
    List<OrderItem> allOrders = [];
    Map<String, Map<String, dynamic>> productCache = {};

    try {
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;

        // Lấy tên người nhận từ addresses
        String userName = 'Unknown';
        try {
          final addressSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('addresses')
              .limit(1)
              .get();

          if (addressSnapshot.docs.isNotEmpty) {
            final addressData = addressSnapshot.docs.first.data();
            userName = addressData['receiver'] ?? 'Unknown';
          }
        } catch (e) {
          print("Không thể lấy tên người dùng từ addresses của $userId: $e");
        }

        // Lấy đơn hàng
        try {
          final orderedSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('ordered_products')
              .get();

          for (var orderDoc in orderedSnapshot.docs) {
            try {
              final data = orderDoc.data();
              final productUid = data['product_uid'] ?? '';
              final orderDate = data['order_date'] ?? '';

              if (productUid.isEmpty) continue;

              // Lấy thông tin sản phẩm (có cache)
              Map<String, dynamic>? productData;
              if (productCache.containsKey(productUid)) {
                productData = productCache[productUid];
              } else {
                final productDoc = await FirebaseFirestore.instance
                    .collection('products')
                    .doc(productUid)
                    .get();
                if (productDoc.exists) {
                  productData = productDoc.data();
                  productCache[productUid] = productData!;
                }
              }

              final productName = productData?['title'] ?? 'Unknown product';

              // Xử lý ảnh
              String productImageUrl = '';
              final images = productData?['images'];
              if (images is List && images.isNotEmpty) {
                productImageUrl = images.first.toString();
              } else if (images is String) {
                productImageUrl = images;
              }

              allOrders.add(OrderItem(
                userId: userId,
                userName: userName,
                productUid: productUid,
                productName: productName,
                productImageUrl: productImageUrl,
                orderDate: orderDate,
              ));
            } catch (e) {
              print("Lỗi khi xử lý đơn hàng của $userId: $e");
            }
          }
        } catch (e) {
          print("Lỗi khi load đơn hàng của user $userId: $e");
        }
      }
    } catch (e) {
      print("Lỗi khi load toàn bộ đơn hàng: $e");
    }

    return allOrders;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderItem>>(
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
          return const Center(child: Text("Không có đơn hàng nào."));
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderCard(
              userName: order.userName,
              productName: order.productName,
              productImageUrl: order.productImageUrl,
              orderDate: order.orderDate,
            );
          },
        );
      },
    );
  }
}
