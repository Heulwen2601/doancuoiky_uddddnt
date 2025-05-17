import 'package:do_an_ck_uddddnt/constants.dart';
import 'package:do_an_ck_uddddnt/models/Address.dart';
import 'package:do_an_ck_uddddnt/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({
    Key? key,
    required this.addressId,
  }) : super(key: key);

  final String addressId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: FutureBuilder<Address>(
                  future: UserDatabaseHelper().getAddressFromId(addressId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final address = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${address.title  ?? 'Không rõ'}",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${address.receiver  ?? 'Không rõ'}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${address.addresLine1  ?? 'Không rõ'}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${address.addressLine2  ?? 'Không rõ'}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "City: ${address.city  ?? 'Không rõ'}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "District: ${address.district  ?? 'Không rõ'}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "State: ${address.state  ?? 'Không rõ'}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Landmark: ${address.landmark  ?? 'Không rõ'}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "PIN: ${address.pincode  ?? 'Không rõ'}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Phone: ${address.phone  ?? 'Không rõ'}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      final error = snapshot.error.toString();
                      Logger().e(error);
                    }
                    return Center(
                      child: Icon(
                        Icons.error,
                        color: kTextColor,
                        size: 60,
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
