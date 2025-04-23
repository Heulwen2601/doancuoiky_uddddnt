class CategoryModel {
  final String title;
  final String? image, svgSrc;
  final List<CategoryModel>? subCategories;

  CategoryModel({
    required this.title,
    this.image,
    this.svgSrc,
    this.subCategories,
  });
}

final List<CategoryModel> demoCategoriesWithImage = [
  CategoryModel(title: "Laptop", image: "https://i.imgur.com/XDdFT97.png"),
  CategoryModel(title: "PC Gaming", image: "https://i.imgur.com/4rRfbIG.png"),
  CategoryModel(title: "Linh kiện", image: "https://i.imgur.com/C2XAOdK.png"),
  CategoryModel(title: "Phụ kiện", image: "https://i.imgur.com/sE1yYO1.png"),
];

final List<CategoryModel> demoCategories = [
  CategoryModel(
    title: "Laptop",
    svgSrc: "assets/icons/laptop.svg",
    subCategories: [
      CategoryModel(title: "Laptop Gaming"),
      CategoryModel(title: "Laptop Văn phòng"),
      CategoryModel(title: "Laptop Đồ họa"),
      CategoryModel(title: "MacBook"),
    ],
  ),
  CategoryModel(
    title: "PC Gaming",
    svgSrc: "assets/icons/pc_gaming.svg",
    subCategories: [
      CategoryModel(title: "PC Tầm trung"),
      CategoryModel(title: "PC Cao cấp"),
      CategoryModel(title: "PC Mini"),
    ],
  ),
  CategoryModel(
    title: "Linh kiện",
    svgSrc: "assets/icons/components.svg",
    subCategories: [
      CategoryModel(title: "CPU"),
      CategoryModel(title: "Mainboard"),
      CategoryModel(title: "RAM"),
      CategoryModel(title: "Ổ cứng SSD/HDD"),
      CategoryModel(title: "Card màn hình (GPU)"),
      CategoryModel(title: "Nguồn (PSU)"),
      CategoryModel(title: "Tản nhiệt"),
    ],
  ),
  CategoryModel(
    title: "Phụ kiện",
    svgSrc: "assets/icons/accessories.svg",
    subCategories: [
      CategoryModel(title: "Chuột"),
      CategoryModel(title: "Bàn phím"),
      CategoryModel(title: "Tai nghe"),
      CategoryModel(title: "Bàn di chuột"),
      CategoryModel(title: "Webcam"),
      CategoryModel(title: "USB & Ổ cứng di động"),
    ],
  ),
];
