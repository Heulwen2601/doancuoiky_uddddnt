import 'package:do_an_ck_uddddnt/screens/admin/users/user_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  bool _isLoading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    List<Map<String, dynamic>> users = [];

    final userSnapshots = await FirebaseFirestore.instance.collection('users').get();

    for (var doc in userSnapshots.docs) {
      final userId = doc.id;
      final userData = doc.data();

      String name = 'Không rõ';
      try {
        final addressSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('addresses')
            .limit(1)
            .get();

        if (addressSnapshot.docs.isNotEmpty) {
          name = addressSnapshot.docs.first.data()['receiver'] ?? name;
        }
      } catch (_) {}

      users.add({
        'userId': userId,
        'phone': userData['phone'] ?? 'Không có phone',
        'name': name,
      });
    }

    setState(() {
      _users = users;
      _filteredUsers = users;
      _isLoading = false;
    });
  }

  void _filterUsers(String text) {
    setState(() {
      _searchText = text.toLowerCase();
      _filteredUsers = _users
          .where((user) =>
              user['name'].toString().toLowerCase().contains(_searchText) ||
              user['phone'].toString().toLowerCase().contains(_searchText))
          .toList();
    });
  }

  void _viewOrders(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserOrdersScreen(userId: userId),
      ),
    );
  }

  void _deleteUser(String userId) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn xoá người dùng này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xoá')),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      setState(() {
        _users.removeWhere((u) => u['userId'] == userId);
        _filteredUsers.removeWhere((u) => u['userId'] == userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onChanged: _filterUsers,
                  decoration: const InputDecoration(
                    labelText: 'Tìm kiếm người dùng',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = _filteredUsers[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user['name']),
                      subtitle: Text("Phone: ${user['phone']}\nID: ${user['userId']}"),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'orders') _viewOrders(user['userId']);
                          if (value == 'delete') _deleteUser(user['userId']);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'orders', child: Text('Xem đơn hàng')),
                          const PopupMenuItem(value: 'delete', child: Text('Xoá người dùng')),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
