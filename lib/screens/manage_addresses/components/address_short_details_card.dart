import 'package:do_an_ck_uddddnt/constants.dart';
import 'package:do_an_ck_uddddnt/models/Address.dart';
import 'package:do_an_ck_uddddnt/services/database/user_database_helper.dart';
import 'package:do_an_ck_uddddnt/size_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddressShortDetailsCard extends StatelessWidget {
  final String addressId;
  final VoidCallback? onTap;

  const AddressShortDetailsCard
  (
    {
      Key? key, 
      required this.addressId, 
      required this.onTap
    })
  : super(key: key);
  
  @override
Widget build(BuildContext context) {
  // Ghi log ra addressId trước khi build FutureBuilder
  Logger().i(UserDatabaseHelper().getAddressFromId(addressId));

  final futureAddress = UserDatabaseHelper().getAddressFromId(addressId);

  return InkWell(
    onTap: onTap,
    child: SizedBox(
      width: double.infinity,
      height: SizeConfig.screenHeight * 0.15,
      child: FutureBuilder<Address>(
        future: futureAddress,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final error = snapshot.error.toString();
            Logger().e('Lỗi khi lấy địa chỉ: $error');
            Logger().d("Address data: ${snapshot.data}");
            Logger().d("Address ID: $addressId");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Lỗi khi tải địa chỉ',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final address = snapshot.data!;
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      color: kTextColor.withOpacity(0.24),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        address.title ?? 'Không rõ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: kTextColor.withOpacity(0.24)),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          address.receiver ?? 'Không rõ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text("City: ${address.city ?? 'Không rõ'}"),
                        Text("Phone: ${address.phone ?? 'Không rõ'}"),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          // Khi không có dữ liệu nhưng cũng không phải lỗi
          return Center(
            child: Icon(
              Icons.error,
              size: 40,
              color: kTextColor,
            ),
          );
        },
      ),
    ),
  );
}

}
