import 'Model.dart';

class Address extends Model {
  static const String TITLE_KEY = "title";
  static const String ADDRESS_LINE_1_KEY = "addresLine1"; // ✅ CHỈNH CHUẨN THEO FIRESTORE
  static const String ADDRESS_LINE_2_KEY = "addresLine2";
  static const String CITY_KEY = "city";
  static const String DISTRICT_KEY = "district";
  static const String STATE_KEY = "state";
  static const String LANDMARK_KEY = "landmark";
  static const String PINCODE_KEY = "pincode";
  static const String RECEIVER_KEY = "receiver";
  static const String PHONE_KEY = "phone";

  final String title;
  final String receiver;
  final String addresLine1;
  final String addressLine2;
  final String city;
  final String district;
  final String state;
  final String landmark;
  final String pincode;
  final String phone;

  Address({
    required String id,
    required this.title,
    required this.receiver,
    required this.addresLine1,
    required this.addressLine2,
    required this.city,
    required this.district,
    required this.state,
    required this.landmark,
    required this.pincode,
    required this.phone,
  }) : super(id);

  factory Address.fromMap(Map<String, dynamic> map, {required String id}) {
    return Address(
      id: id,
      title: map[TITLE_KEY] ?? '',
      receiver: map[RECEIVER_KEY] ?? '',
      addresLine1: map[ADDRESS_LINE_1_KEY] ?? '',
      addressLine2: map[ADDRESS_LINE_2_KEY] ?? '',
      city: map[CITY_KEY] ?? '',
      district: map[DISTRICT_KEY] ?? '',
      state: map[STATE_KEY] ?? '',
      landmark: map[LANDMARK_KEY] ?? '',
      pincode: map[PINCODE_KEY] ?? '',
      phone: map[PHONE_KEY] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      TITLE_KEY: title,
      RECEIVER_KEY: receiver,
      ADDRESS_LINE_1_KEY: addresLine1,
      ADDRESS_LINE_2_KEY: addressLine2,
      CITY_KEY: city,
      DISTRICT_KEY: district,
      STATE_KEY: state,
      LANDMARK_KEY: landmark,
      PINCODE_KEY: pincode,
      PHONE_KEY: phone,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (title.isNotEmpty) map[TITLE_KEY] = title;
    if (receiver.isNotEmpty) map[RECEIVER_KEY] = receiver;
    if (addresLine1.isNotEmpty) map[ADDRESS_LINE_1_KEY] = addresLine1;
    if (addressLine2.isNotEmpty) map[ADDRESS_LINE_2_KEY] = addressLine2;
    if (city.isNotEmpty) map[CITY_KEY] = city;
    if (district.isNotEmpty) map[DISTRICT_KEY] = district;
    if (state.isNotEmpty) map[STATE_KEY] = state;
    if (landmark.isNotEmpty) map[LANDMARK_KEY] = landmark;
    if (pincode.isNotEmpty) map[PINCODE_KEY] = pincode;
    if (phone.isNotEmpty) map[PHONE_KEY] = phone;
    return map;
  }
}
