class ProductModel {
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;

  ProductModel({
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
  });
}

List<ProductModel> demoPopularProducts = [
  ProductModel(
    image: "https://i.imgur.com/5Uu9UOe.png",
    title: "Laptop ASUS Vivobook X1502",
    brandName: "ASUS",
    price: 15900000,
    priceAfetDiscount: 14500000,
    dicountpercent: 9,
  ),
  ProductModel(
    image: "https://i.imgur.com/XxkI1iQ.png",
    title: "CPU Intel Core i5 12400F",
    brandName: "Intel",
    price: 4390000,
  ),
  ProductModel(
    image: "https://i.imgur.com/pb6dPA8.png",
    title: "Mainboard MSI B660M Mortar",
    brandName: "MSI",
    price: 3890000,
    priceAfetDiscount: 3590000,
    dicountpercent: 8,
  ),
];

List<ProductModel> demoFlashSaleProducts = [
  ProductModel(
    image: "https://i.imgur.com/GCkKP7J.png",
    title: "RAM Kingston Fury Beast 16GB DDR4",
    brandName: "Kingston",
    price: 1290000,
    priceAfetDiscount: 1150000,
    dicountpercent: 11,
  ),
  ProductModel(
    image: "https://i.imgur.com/Rv7uLSO.png",
    title: "SSD Samsung 970 EVO Plus 1TB",
    brandName: "Samsung",
    price: 2790000,
    priceAfetDiscount: 2490000,
    dicountpercent: 11,
  ),
];

List<ProductModel> demoBestSellersProducts = [
  ProductModel(
    image: "https://i.imgur.com/d3FQgBo.png",
    title: "VGA Gigabyte RTX 3060 Gaming OC",
    brandName: "Gigabyte",
    price: 8390000,
    priceAfetDiscount: 7790000,
    dicountpercent: 7,
  ),
  ProductModel(
    image: "https://i.imgur.com/vH6OmAm.png",
    title: "Nguồn Corsair CV650 650W",
    brandName: "Corsair",
    price: 1250000,
  ),
];

List<ProductModel> basicProducts = [
  ProductModel(
    image: "https://i.imgur.com/M0fF9p1.png",
    title: "Chuột Logitech G102",
    brandName: "Logitech",
    price: 490000,
    priceAfetDiscount: 450000,
    dicountpercent: 8,
  ),
  ProductModel(
    image: "https://i.imgur.com/Cvjxas9.png",
    title: "Tai nghe Gaming DareU EH469",
    brandName: "DareU",
    price: 620000,
  ),
];
