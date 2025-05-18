class OrderItem {
  final String userId;
  final String userName;
  final String productUid;
  final String productName;
  final String productImageUrl;
  final String orderDate;

  OrderItem({
    required this.userId,
    required this.userName,
    required this.productUid,
    required this.productName,
    required this.productImageUrl,
    required this.orderDate,
  });
}
