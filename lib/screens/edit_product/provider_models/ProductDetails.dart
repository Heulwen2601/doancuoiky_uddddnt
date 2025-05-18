import 'package:do_an_ck_uddddnt/models/Product.dart';
import 'package:flutter/material.dart';

enum ImageType {
  local,
  network,
}

class CustomImage {
  final ImageType imgType;
  final String path;
  CustomImage({this.imgType = ImageType.local, required this.path});
  @override
  String toString() {
    return "Instance of Custom Image: {imgType: $imgType, path: $path}";
  }
}

class ProductDetails extends ChangeNotifier {
  List<CustomImage> _selectedImages = List<CustomImage>.empty(growable: true);
  late ProductType _productType;
  List<String> _searchTags = List<String>.empty(growable: true);

  String _title = '';
  String _variant = '';
  double _discountPrice = 0.0;
  double _originalPrice = 0.0;
  String _highlights = '';
  String _description = '';
  String _seller = '';

  List<CustomImage> get selectedImages => _selectedImages;
  set initialSelectedImages(List<CustomImage> images) {
    _selectedImages = images;
    notifyListeners();
  }
  set selectedImages(List<CustomImage> images) {
    _selectedImages = images;
    notifyListeners();
  }
  void setSelectedImageAtIndex(CustomImage image, int index) {
    if (index < _selectedImages.length) {
      _selectedImages[index] = image;
      notifyListeners();
    }
  }
  void addNewSelectedImage(CustomImage image) {
    _selectedImages.add(image);
    notifyListeners();
  }

  ProductType get productType => _productType;
  set initialProductType(ProductType type) {
    _productType = type;
    notifyListeners();
  }
  set productType(ProductType type) {
    _productType = type;
    notifyListeners();
  }

  List<String> get searchTags => _searchTags;
  set searchTags(List<String> tags) {
    _searchTags = tags;
    notifyListeners();
  }
  set initSearchTags(List<String> tags) {
    _searchTags = tags;
    notifyListeners();
  }
  void addSearchTag(String tag) {
    _searchTags.add(tag);
    notifyListeners();
  }
  void removeSearchTag({required int index}) {
    if (index >= 0 && index < _searchTags.length) {
      _searchTags.removeAt(index);
      notifyListeners();
    }
  }

  String get title => _title;
  set title(String val) {
    if (_title != val) {
      _title = val;
      notifyListeners();
    }
  }

  String get variant => _variant;
  set variant(String val) {
    if (_variant != val) {
      _variant = val;
      notifyListeners();
    }
  }

  double get discountPrice => _discountPrice;
  set discountPrice(double val) {
    if (_discountPrice != val) {
      _discountPrice = val;
      notifyListeners();
    }
  }

  double get originalPrice => _originalPrice;
  set originalPrice(double val) {
    if (_originalPrice != val) {
      _originalPrice = val;
      notifyListeners();
    }
  }

  String get highlights => _highlights;
  set highlights(String val) {
    if (_highlights != val) {
      _highlights = val;
      notifyListeners();
    }
  }

  String get description => _description;
  set description(String val) {
    if (_description != val) {
      _description = val;
      notifyListeners();
    }
  }

  String get seller => _seller;
  set seller(String val) {
    if (_seller != val) {
      _seller = val;
      notifyListeners();
    }
  }
}
