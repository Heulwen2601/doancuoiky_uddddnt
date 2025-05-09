import 'package:flutter/material.dart';

import 'components/body.dart';

class EditAddressScreen extends StatelessWidget {
  final String? addressIdToEdit;

  const EditAddressScreen({
    Key? key, 
    this.addressIdToEdit
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(addressIdToEdit: addressIdToEdit ),
    );
  }
}

class Body extends StatelessWidget {
  final String? addressIdToEdit;

  const Body({
    Key? key,
    this.addressIdToEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(addressIdToEdit ?? 'No address selected'),
    );
  }
}