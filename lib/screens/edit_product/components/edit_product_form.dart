import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ck_uddddnt/components/async_progress_dialog.dart';
import 'package:do_an_ck_uddddnt/components/default_button.dart';
import 'package:do_an_ck_uddddnt/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:do_an_ck_uddddnt/exceptions/local_files_handling/local_file_handling_exception.dart';
import 'package:do_an_ck_uddddnt/models/Product.dart';
import 'package:do_an_ck_uddddnt/screens/edit_product/provider_models/ProductDetails.dart';
import 'package:do_an_ck_uddddnt/services/database/product_database_helper.dart';
import 'package:do_an_ck_uddddnt/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:do_an_ck_uddddnt/services/local_files_access/local_files_access_service.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class EditProductForm extends StatefulWidget {
  final Product? product; // cho phép null khi tạo sản phẩm mới

  EditProductForm({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final _basicDetailsFormKey = GlobalKey<FormState>();
  final _describeProductFormKey = GlobalKey<FormState>();

  final TextEditingController titleFieldController = TextEditingController();
  final TextEditingController variantFieldController = TextEditingController();
  final TextEditingController discountPriceFieldController = TextEditingController();
  final TextEditingController originalPriceFieldController = TextEditingController();
  final TextEditingController highlightsFieldController = TextEditingController();
  final TextEditingController descriptionFieldController = TextEditingController();
  final TextEditingController sellerFieldController = TextEditingController();

  bool newProduct = true;
  late Product product;

  @override
  void dispose() {
    titleFieldController.dispose();
    variantFieldController.dispose();
    discountPriceFieldController.dispose();
    originalPriceFieldController.dispose();
    highlightsFieldController.dispose();
    descriptionFieldController.dispose();
    sellerFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.product == null) {
      // Tạo product mặc định cho sản phẩm mới
      product = Product(
        '0',
        productType: ProductType.Computers,
        images: [],
        title: '',
        variant: '',
        discountPrice: 0.0,
        originalPrice: 0.0,
        rating: 0.0,
        highlights: '',
        description: '',
        seller: '',
        owner: '',
        searchTags: [],
      );
      newProduct = true;
    } else {
      product = widget.product!;
      newProduct = false;
    }

    // Set các giá trị controller 1 lần lúc initState
    titleFieldController.text = product.title;
    variantFieldController.text = product.variant;
    discountPriceFieldController.text = product.discountPrice.toString();
    originalPriceFieldController.text = product.originalPrice.toString();
    highlightsFieldController.text = product.highlights;
    descriptionFieldController.text = product.description;
    sellerFieldController.text = product.seller;

    // Cập nhật Provider ProductDetails
    final productDetails = Provider.of<ProductDetails>(context, listen: false);
    productDetails.initialSelectedImages = product.images
        .map((e) => CustomImage(imgType: ImageType.network, path: e))
        .toList();
    productDetails.initialProductType = product.productType;
    productDetails.initSearchTags = product.searchTags ?? [];
    productDetails.title = product.title;
    productDetails.variant = product.variant;
    productDetails.discountPrice = product.discountPrice.toDouble();
    productDetails.originalPrice = product.originalPrice.toDouble();
    productDetails.highlights = product.highlights;
    productDetails.description = product.description;
    productDetails.seller = product.seller;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          buildBasicDetailsTile(context),
          SizedBox(height: 10),
          buildDescribeProductTile(context),
          SizedBox(height: 10),
          buildUploadImagesTile(context),
          SizedBox(height: 20),
          buildProductTypeDropdown(),
          SizedBox(height: 20),
          buildProductSearchTagsTile(),
          SizedBox(height: 80),
          DefaultButton(
            text: "Save Product",
            press: () => saveProductButtonCallback(context),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildBasicDetailsTile(BuildContext context) {
    return Form(
      key: _basicDetailsFormKey,
      child: ExpansionTile(
        maintainState: true,
        title: Text(
          "Basic Details",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: Icon(Icons.shop),
        childrenPadding: EdgeInsets.symmetric(vertical: 20),
        children: [
          buildTitleField(),
          SizedBox(height: 20),
          buildVariantField(),
          SizedBox(height: 20),
          buildOriginalPriceField(),
          SizedBox(height: 20),
          buildDiscountPriceField(),
          SizedBox(height: 20),
          buildSellerField(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  bool validateBasicDetailsForm() {
    if (_basicDetailsFormKey.currentState?.validate() ?? false) {
      _basicDetailsFormKey.currentState?.save();
      product.title = titleFieldController.text;
      product.variant = variantFieldController.text;
      product.originalPrice = double.tryParse(originalPriceFieldController.text) ?? 0.0;
      product.discountPrice = double.tryParse(discountPriceFieldController.text) ?? 0.0;
      product.seller = sellerFieldController.text;
      return true;
    }
    return false;
  }

  Widget buildDescribeProductTile(BuildContext context) {
    return Form(
      key: _describeProductFormKey,
      child: ExpansionTile(
        maintainState: true,
        title: Text(
          "Describe Product",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: Icon(Icons.description),
        childrenPadding: EdgeInsets.symmetric(vertical: 20),
        children: [
          buildHighlightsField(),
          SizedBox(height: 20),
          buildDescriptionField(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  bool validateDescribeProductForm() {
    if (_describeProductFormKey.currentState?.validate() ?? false) {
      _describeProductFormKey.currentState?.save();
      product.highlights = highlightsFieldController.text;
      product.description = descriptionFieldController.text;
      return true;
    }
    return false;
  }

  Widget buildProductTypeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      child: Consumer<ProductDetails>(
        builder: (context, productDetails, child) {
          return DropdownButton<ProductType>(
            value: productDetails.productType,
            items: ProductType.values
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.toString().split('.').last),
                  ),
                )
                .toList(),
            hint: Text("Choose Product Type"),
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            onChanged: (value) {
              productDetails.productType = value!;
            },
            elevation: 0,
            underline: SizedBox(),
          );
        },
      ),
    );
  }

  Widget buildProductSearchTagsTile() {
    return ExpansionTile(
      title: Text(
        "Search Tags",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      leading: Icon(Icons.check_circle_sharp),
      childrenPadding: EdgeInsets.symmetric(vertical: 20),
      children: [
        Text("Your product will be searched for these Tags"),
        SizedBox(height: 15),
        buildProductSearchTags(),
      ],
    );
  }

  Widget buildProductSearchTags() {
    final TextEditingController _tagController = TextEditingController();

    return Consumer<ProductDetails>(
      builder: (context, productDetails, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      hintText: "Add search tag",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      final tag = value.trim().toLowerCase();
                      if (tag.isNotEmpty) {
                        productDetails.addSearchTag(tag);
                        _tagController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final tag = _tagController.text.trim().toLowerCase();
                    if (tag.isNotEmpty) {
                      productDetails.addSearchTag(tag);
                      _tagController.clear();
                    }
                  },
                )
              ],
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: productDetails.searchTags.asMap().entries.map((entry) {
                final index = entry.key;
                final tag = entry.value;
                return Chip(
                  label: Text(tag),
                  backgroundColor: Colors.blue.shade100,
                  deleteIcon: Icon(Icons.close),
                  onDeleted: () {
                    productDetails.removeSearchTag(index: index);
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget buildUploadImagesTile(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Upload Images",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      leading: Icon(Icons.image),
      childrenPadding: EdgeInsets.symmetric(vertical: 20),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: IconButton(
            icon: Icon(Icons.add_a_photo),
            color: Colors.black87,
            onPressed: () {
              addImageButtonCallback(index: null);
            },
          ),
        ),
        Consumer<ProductDetails>(
          builder: (context, productDetails, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                productDetails.selectedImages.length,
                (index) => SizedBox(
                  width: 80,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        addImageButtonCallback(index: index);
                      },
                      child: productDetails.selectedImages[index].imgType ==
                              ImageType.local
                          ? Image.memory(
                              File(productDetails.selectedImages[index].path)
                                  .readAsBytesSync())
                          : Image.network(productDetails.selectedImages[index].path),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildTitleField() {
    return TextFormField(
      controller: titleFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "e.g., Gaming PC Raptor X9",
        labelText: "Product Title",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (titleFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildVariantField() {
    return TextFormField(
      controller: variantFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "e.g., Intel i9 Processor",
        labelText: "Variant",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (variantFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildHighlightsField() {
    return TextFormField(
      controller: highlightsFieldController,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: "e.g., Intel i9 Processor | RTX 4090 Graphics Card | 32GB RAM, 2TB SSD",
        labelText: "Highlights",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (highlightsFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: null,
    );
  }

  Widget buildDescriptionField() {
    return TextFormField(
      controller: descriptionFieldController,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText:
            "e.g., The Raptor X9 is a powerhouse designed for ultimate gaming and productivity. Equipped with the latest Intel i9 processor and the powerful RTX 4090...",
        labelText: "Description",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (descriptionFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: null,
    );
  }

  Widget buildSellerField() {
    return TextFormField(
      controller: sellerFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "e.g., HighTech Traders",
        labelText: "Seller",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (sellerFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildOriginalPriceField() {
    return TextFormField(
      controller: originalPriceFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "e.g., 5999.0",
        labelText: "Original Price (in INR)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (originalPriceFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        if (double.tryParse(originalPriceFieldController.text) == null) {
          return "Enter a valid number";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildDiscountPriceField() {
    return TextFormField(
      controller: discountPriceFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "e.g., 2499.0",
        labelText: "Discount Price (in INR)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (discountPriceFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        if (double.tryParse(discountPriceFieldController.text) == null) {
          return "Enter a valid number";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> saveProductButtonCallback(BuildContext context) async {
    if (!validateBasicDetailsForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errors in Basic Details Form")),
      );
      return;
    }

    if (!validateDescribeProductForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errors in Describe Product Form")),
      );
      return;
    }

    final productDetails = Provider.of<ProductDetails>(context, listen: false);

    if (productDetails.selectedImages.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload at least Three Images of Product")),
      );
      return;
    }

    if (productDetails.productType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select Product Type")),
      );
      return;
    }

    if (productDetails.searchTags.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Add at least 3 search tags")),
      );
      return;
    }

    String? productId;
    String snackbarMessage = '';

    try {
      product.title = titleFieldController.text;
      product.variant = variantFieldController.text;
      product.discountPrice = double.tryParse(discountPriceFieldController.text) ?? 0.0;
      product.originalPrice = double.tryParse(originalPriceFieldController.text) ?? 0.0;
      product.highlights = highlightsFieldController.text;
      product.description = descriptionFieldController.text;
      product.seller = sellerFieldController.text;

      product.productType = productDetails.productType!;
      product.searchTags = productDetails.searchTags;

      final productUploadFuture = newProduct
          ? ProductDatabaseHelper().addUsersProduct(product)
          : ProductDatabaseHelper().updateUsersProduct(product);

      productId = await productUploadFuture;

      if (productId == null) {
        throw "Couldn't update product info due to some unknown issue";
      }

      snackbarMessage = "Product Info updated successfully";
    } catch (e) {
      snackbarMessage = "Something went wrong: $e";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(snackbarMessage)),
    );

    if (productId == null) return;

    bool allImagesUploaded = await uploadProductImages(productId);
    if (!allImagesUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Some images couldn't be uploaded, please try again")),
      );
      return;
    }

    // Lấy url ảnh
    List<String?> downloadUrls = productDetails.selectedImages
        .map((e) => e.imgType == ImageType.network ? e.path : null)
        .toList();

    try {
      final nonNullDownloadUrls = productDetails.selectedImages
          .map((e) => e.path)
          .whereType<String>()
          .toList();
      bool productFinalizeUpdate = await ProductDatabaseHelper()
          .updateProductsImages(productId, nonNullDownloadUrls);
      if (productFinalizeUpdate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product uploaded successfully")),
        );
      } else {
        throw "Couldn't upload product properly, please retry";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    }

    Navigator.pop(context);
  }

  Future<bool> uploadProductImages(String productId) async {
    final productDetails = Provider.of<ProductDetails>(context, listen: false);

    for (int i = 0; i < productDetails.selectedImages.length; i++) {
      if (productDetails.selectedImages[i].imgType == ImageType.local) {
        try {
          final filePath = productDetails.selectedImages[i].path;
          final fileName = filePath.split(Platform.pathSeparator).last;
          final staticUrl = "https://heulwen2601.github.io/static-images/$fileName";

          // Gán lại ảnh từ local sang URL static
          productDetails.selectedImages[i] =
              CustomImage(imgType: ImageType.network, path: staticUrl);
        } catch (e) {
          // Nếu có lỗi thì bỏ qua ảnh này
          return false;
        }
      }
    }

    return true;
  }


  Future<void> addImageButtonCallback({int? index}) async {
    final productDetails = Provider.of<ProductDetails>(context, listen: false);

    String? path;
    String? snackbarMessage;

    try {
      path = await choseImageFromLocalFiles(context);
      if (path == null) {
        throw Exception("Image picking cancelled or failed");
      }
    } catch (e) {
      snackbarMessage = e.toString();
    }

    if (snackbarMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(snackbarMessage)),
      );
      return;
    }

    if (path == null) return;

    final newImage = CustomImage(imgType: ImageType.local, path: path);

    if (index == null) {
      productDetails.addNewSelectedImage(newImage);
    } else {
      productDetails.setSelectedImageAtIndex(newImage, index);
    }
  }
}