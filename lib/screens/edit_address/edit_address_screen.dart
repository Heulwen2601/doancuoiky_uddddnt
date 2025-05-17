import 'package:flutter/material.dart';
import 'package:do_an_ck_uddddnt/services/database/user_database_helper.dart';
import 'package:do_an_ck_uddddnt/models/Address.dart';

class EditAddressScreen extends StatefulWidget {
  final String? addressIdToEdit;

  const EditAddressScreen({Key? key, this.addressIdToEdit}) : super(key: key);

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _receiverController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.addressIdToEdit != null) {
      loadAddressData();
    }
  }

  Future<void> loadAddressData() async {
    setState(() => _isLoading = true);
    try {
      final address = await UserDatabaseHelper().getAddressFromId(widget.addressIdToEdit!);
      _titleController.text = address.title;
      _receiverController.text = address.receiver;
      _addressLine1Controller.text = address.addresLine1;
      _addressLine2Controller.text = address.addressLine2;
      _landmarkController.text = address.landmark;
      _cityController.text = address.city;
      _districtController.text = address.district;
      _stateController.text = address.state;
      _pincodeController.text = address.pincode;
      _phoneController.text = address.phone;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading address")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final address = Address(
      id: widget.addressIdToEdit ?? '', // hoặc UUID mới nếu tạo mới
      title: _titleController.text,
      receiver: _receiverController.text,
      addresLine1: _addressLine1Controller.text,
      addressLine2: _addressLine2Controller.text,
      city: _cityController.text,
      district: _districtController.text,
      state: _stateController.text,
      landmark: _landmarkController.text,
      pincode: _pincodeController.text,
      phone: _phoneController.text,
    );

    setState(() => _isLoading = true);

    try {
      if (widget.addressIdToEdit == null) {
        await UserDatabaseHelper().addAddressForCurrentUser(address);
      } else {
        await UserDatabaseHelper().updateAddressForCurrentUser(address);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Address saved successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.addressIdToEdit == null ? "Add Address" : "Edit Address"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    buildField("Title (e.g. Nhà riêng)", _titleController),
                    buildField("Receiver Name", _receiverController),
                    buildField("Address Line 1", _addressLine1Controller),
                    buildField("Address Line 2", _addressLine2Controller),
                    buildField("Landmark", _landmarkController),
                    buildField("City", _cityController),
                    buildField("District", _districtController),
                    buildField("State", _stateController),
                    buildField("Pincode", _pincodeController),
                    buildField("Phone", _phoneController, type: TextInputType.phone),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: saveAddress,
                      child: Text("Save"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildField(String label, TextEditingController controller, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(labelText: label),
        validator: (value) => value == null || value.isEmpty ? "Enter $label" : null,
      ),
    );
  }
}
