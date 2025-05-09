import 'package:do_an_ck_uddddnt/constants.dart';
import 'package:do_an_ck_uddddnt/models/Address.dart';
import 'package:do_an_ck_uddddnt/services/database/user_database_helper.dart';
import 'package:do_an_ck_uddddnt/size_config.dart';
import 'package:flutter/material.dart';

import 'address_details_form.dart';

class Body extends StatelessWidget {
  final String? addressIdToEdit;

  const Body({
    Key? key, 
    this.addressIdToEdit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  "Fill Address Details",
                  style: headingStyle,
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                addressIdToEdit == null
                    ? AddressDetailsForm(
                        addressToEdit: null, // Truyền null khi không có id
                      )
                    : FutureBuilder<Address>(
                        future: UserDatabaseHelper()
                            .getAddressFromId(addressIdToEdit!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final address = snapshot.data!;
                            return AddressDetailsForm(addressToEdit: address);
                          } else if (snapshot.connectionState == 
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return AddressDetailsForm(
                            addressToEdit: null, // Trả về null nếu không có dữ liệu
                          );
                        },
                      ),
                SizedBox(height: getProportionateScreenHeight(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
