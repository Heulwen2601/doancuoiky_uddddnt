import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ck_uddddnt/models/Address.dart';
import 'package:do_an_ck_uddddnt/models/CartItem.dart';
import 'package:do_an_ck_uddddnt/models/OrderedProduct.dart';
import 'package:do_an_ck_uddddnt/services/authentification/authentification_service.dart';
import 'package:do_an_ck_uddddnt/services/database/product_database_helper.dart';
import 'package:logger/logger.dart';

class UserDatabaseHelper {
  static const String USERS_COLLECTION_NAME = "users";
  static const String ADDRESSES_COLLECTION_NAME = "addresses";
  static const String CART_COLLECTION_NAME = "cart";
  static const String ORDERED_PRODUCTS_COLLECTION_NAME = "ordered_products";

  static const String PHONE_KEY = 'phone';
  static const String DP_KEY = "display_picture";
  static const String FAV_PRODUCTS_KEY = "favourite_products";

  UserDatabaseHelper._privateConstructor();
  static UserDatabaseHelper _instance =
      UserDatabaseHelper._privateConstructor();
  factory UserDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<void> createNewUser(String uid) async {
    await firestore.collection(USERS_COLLECTION_NAME).doc(uid).set({
      DP_KEY: null,
      PHONE_KEY: null,
      FAV_PRODUCTS_KEY: List<String>.empty(growable: true),
    });
  }

  Future<void> deleteCurrentUserData() async {
    final uid = AuthentificationService().currentUser.uid;
    final docRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final cartCollectionRef = docRef.collection(CART_COLLECTION_NAME);
    final addressCollectionRef = docRef.collection(ADDRESSES_COLLECTION_NAME);
    final ordersCollectionRef =
        docRef.collection(ORDERED_PRODUCTS_COLLECTION_NAME);

    final cartDocs = await cartCollectionRef.get();
    for (final cartDoc in cartDocs.docs) {
      await cartCollectionRef.doc(cartDoc.id).delete();
    }
    final addressesDocs = await addressCollectionRef.get();
    for (final addressDoc in addressesDocs.docs) {
      await addressCollectionRef.doc(addressDoc.id).delete();
    }
    final ordersDoc = await ordersCollectionRef.get();
    for (final orderDoc in ordersDoc.docs) {
      await ordersCollectionRef.doc(orderDoc.id).delete();
    }

    await docRef.delete();
  }

  Future<bool> isProductFavourite(String productId) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data();

    // Kiểm tra null cho userDocData
    if (userDocData == null) {
      return false; // Trả về false nếu tài liệu không tồn tại
    }

    // Truy cập FAV_PRODUCTS_KEY sau khi đã kiểm tra null
    final favList = (userDocData[FAV_PRODUCTS_KEY] as List<dynamic>?)?.cast<String>() ?? [];
    
    return favList.contains(productId); // Rút gọn if-else
  }

  Future<List<String>> get usersFavouriteProductsList async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data();

    // Kiểm tra null cho userDocData
    if (userDocData == null) {
      return []; // Trả về danh sách rỗng nếu tài liệu không tồn tại
    }

    // Lấy và ép kiểu favList
    final favList = (userDocData[FAV_PRODUCTS_KEY] as List<dynamic>?)?.cast<String>() ?? [];

    return favList;
  }

  Future<bool> switchProductFavouriteStatus(
      String productId, bool newState) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);

    if (newState == true) {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayUnion([productId])
      });
    } else {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayRemove([productId])
      });
    }
    return true;
  }

  Future<List<String>> get addressesList async {
    String uid = AuthentificationService().currentUser.uid;
    final snapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .get();
    final addresses = List<String>.empty(growable: true);
    snapshot.docs.forEach((doc) {
      addresses.add(doc.id);
    });

    return addresses;
  }

  Future<Address> getAddressFromId(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final doc = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(id)
        .get();

    if (!doc.exists || doc.data() == null) {
      throw Exception("Address not found");
    }

    final address = Address.fromMap(doc.data()!, id: doc.id);
    return address;
  }

  Future<bool> addAddressForCurrentUser(Address address) async {
    String uid = AuthentificationService().currentUser.uid;
    final addressesCollectionReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME);
    await addressesCollectionReference.add(address.toMap());
    return true;
  }

  Future<bool> deleteAddressForCurrentUser(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final addressDocReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(id);
    await addressDocReference.delete();
    return true;
  }

  Future<bool> updateAddressForCurrentUser(Address address) async {
    String uid = AuthentificationService().currentUser.uid;
    final addressDocReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(address.id);
    await addressDocReference.update(address.toMap());
    return true;
  }

  Future<CartItem> getCartItemFromId(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(id);
    final docSnapshot = await docRef.get();
    final cartItem = CartItem.fromMap(docSnapshot.data() ?? {}, id: docSnapshot.id);
    return cartItem;
  }

  Future<bool> addProductToCart(String productId) async {
    try {
      final currentUser = AuthentificationService().currentUser;
      if (currentUser == null) {
        throw Exception("User is not logged in");
      }

      final uid = currentUser.uid;

      final cartCollectionRef = firestore
          .collection(USERS_COLLECTION_NAME)
          .doc(uid)
          .collection(CART_COLLECTION_NAME);
      final docRef = cartCollectionRef.doc(productId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        await docRef.set(CartItem(itemCount: 1).toMap());
      } else {
        await docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(1)});
      }

      return true;
    } catch (e, stack) {
      Logger().e("Failed to add product to cart", error: e, stackTrace: stack);
      return false;
    }
  }

  Future<List<String>> emptyCart() async {
    String uid = AuthentificationService().currentUser.uid;
    final cartItems = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    List<String> orderedProductsUid = List<String>.empty(growable: true);
    for (final doc in cartItems.docs) {
      orderedProductsUid.add(doc.id as String);
      await doc.reference.delete();
    }
    return orderedProductsUid;
  }

  Future<num> get cartTotal async {
    String uid = AuthentificationService().currentUser.uid;
    final cartItems = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    num total = 0.0;
    for (final doc in cartItems.docs) {
      num itemsCount = doc.data()[CartItem.ITEM_COUNT_KEY];
      final product = await ProductDatabaseHelper().getProductWithID(doc.id);
      total += (itemsCount * (product?.discountPrice ?? 0));
    }
    return total;
  }

  Future<bool> removeProductFromCart(String cartItemID) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    await cartCollectionReference.doc(cartItemID).delete();
    return true;
  }

  Future<bool> increaseCartItemCount(String cartItemID) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(1)});
    return true;
  }

  Future<bool> decreaseCartItemCount(String cartItemID) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    final docSnapshot = await docRef.get();

    // Kiểm tra docSnapshot và data() không null
    final data = docSnapshot.data();
    if (data == null) {
      return false; // Hoặc xử lý phù hợp nếu tài liệu không tồn tại
    }

    int currentCount = data[CartItem.ITEM_COUNT_KEY] as int;
    if (currentCount <= 1) {
      return removeProductFromCart(cartItemID);
    } else {
      await docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(-1)});
    }
    return true;
  }

  Future<List<String>> get allCartItemsList async {
    String uid = AuthentificationService().currentUser.uid;
    final querySnapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    List<String> itemsId = List<String>.empty(growable: true);
    for (final item in querySnapshot.docs) {
      itemsId.add(item.id);
    }
    return itemsId;
  }

  Future<List<String>> get orderedProductsList async {
    String uid = AuthentificationService().currentUser.uid;
    final orderedProductsSnapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ORDERED_PRODUCTS_COLLECTION_NAME)
        .get();
    List<String> orderedProductsId = List<String>.empty(growable: true);
    for (final doc in orderedProductsSnapshot.docs) {
      orderedProductsId.add(doc.id);
    }
    return orderedProductsId;
  }

  Future<bool> addToMyOrders(List<OrderedProduct> orders) async {
    String uid = AuthentificationService().currentUser.uid;
    final orderedProductsCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ORDERED_PRODUCTS_COLLECTION_NAME);
    for (final order in orders) {
      await orderedProductsCollectionRef.add(order.toMap());
    }
    return true;
  }

  Future<OrderedProduct> getOrderedProductFromId(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final doc = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ORDERED_PRODUCTS_COLLECTION_NAME)
        .doc(id)
        .get();
    final orderedProduct = OrderedProduct.fromMap(doc.data() ?? {}, id: doc.id);
    return orderedProduct;
  }

  Stream<DocumentSnapshot> get currentUserDataStream {
    String uid = AuthentificationService().currentUser.uid;
    return firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .get()
        .asStream();
  }

  Future<bool> updatePhoneForCurrentUser(String phone) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({PHONE_KEY: phone});
    return true;
  }

  String getPathForCurrentUserDisplayPicture() {
    final String currentUserUid = AuthentificationService().currentUser.uid;
    return "user/display_picture/$currentUserUid";
  }

  Future<bool> uploadDisplayPictureForCurrentUser(String url) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {DP_KEY: url},
    );
    return true;
  }

  Future<bool> removeDisplayPictureForCurrentUser() async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {
        DP_KEY: FieldValue.delete(),
      },
    );
    return true;
  }

  Future<String> get displayPictureForCurrentUser async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();

    // Kiểm tra null cho data
    final data = userDocSnapshot.data();
    if (data == null) {
      return ''; // Trả về chuỗi rỗng hoặc giá trị mặc định nếu tài liệu không tồn tại
    }

    // Ép kiểu và kiểm tra giá trị của DP_KEY
    final dpValue = data[DP_KEY];
    if (dpValue == null) {
      return ''; // Trả về chuỗi rỗng nếu DP_KEY không tồn tại
    }
    return dpValue as String; // Ép kiểu thành String
  }
}
