import 'package:do_an_ck_uddddnt/screens/admin/users/user_management_screen.dart';
import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'products/all_products_screen.dart';
import 'orders/all_orders_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    AllProductsScreen(),
    AllOrdersScreen(),
    UserManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        backgroundColor: Colors.grey, // hoặc Colors.grey[100]
        selectedItemColor: Colors.deepOrange, // màu khi chọn
        unselectedItemColor: Colors.orangeAccent, // màu không chọn
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.computer), label: "Products"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
        ],
      ),
    );
  }
}
