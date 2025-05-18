import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({Key? key}) : super(key: key);

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  int totalProducts = 0;
  int totalOrders = 0;
  double totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    int products = 0;
    int orders = 0;
    double revenue = 0.0;

    // Lấy sản phẩm
    final productSnapshot = await FirebaseFirestore.instance.collection('products').get();
    products = productSnapshot.size;

    // Lấy người dùng
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    for (var userDoc in usersSnapshot.docs) {
      final orderSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.id)
          .collection('ordered_products')
          .get();

      orders += orderSnapshot.size;

      // Duyệt qua từng đơn hàng để cộng doanh thu
      for (var orderDoc in orderSnapshot.docs) {
        final productUid = orderDoc['product_uid'];
        final productDoc = await FirebaseFirestore.instance.collection('products').doc(productUid).get();

        if (productDoc.exists) {
          final data = productDoc.data();
          if (data != null && data['discount_price'] != null) {
            revenue += (data['discount_price'] as num).toDouble();
          }
        }
      }
    }

    setState(() {
      totalProducts = products;
      totalOrders = orders;
      totalRevenue = revenue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Admin Dashboard", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildStatCard("Total Products", totalProducts.toString(), Icons.computer),
          const SizedBox(height: 16),
          _buildStatCard("Total Orders", totalOrders.toString(), Icons.receipt_long),
          const SizedBox(height: 16),
          _buildStatCard("Total Revenue", "\$${totalRevenue.toStringAsFixed(2)}", Icons.attach_money),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 36, color: Colors.blueAccent),
        title: Text(title),
        subtitle: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
