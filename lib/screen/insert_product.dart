import 'dart:convert';

import 'package:applabtest/apiurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertProduct extends StatefulWidget {
  const InsertProduct({super.key});

  @override
  State<InsertProduct> createState() => _InsertProductState();
}

class _InsertProductState extends State<InsertProduct> {
  // Define the form key and text controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtProName = TextEditingController();
  final TextEditingController txtDes = TextEditingController();
  final TextEditingController txtCatId = TextEditingController();
  final TextEditingController txtBar = TextEditingController();
  final TextEditingController txtExDate = TextEditingController();
  final TextEditingController txtQty = TextEditingController();
  final TextEditingController txtPriceIn = TextEditingController();
  final TextEditingController txtPriceOut = TextEditingController();

  Future<void> registerproduct(
    String proname,
    String des,
    String catid,
    String bar,
    String expire,
    String qty,
    String pricein,
    String priceout,
  ) async {
    var uri = Uri.parse("${Apiurl.url}add_product.php");
    final response = await http.post(
      uri,
      body: {
        //key : value
        'ProductName': proname,
        'Descriptions': des,
        'CategoryID': catid,
        'Barcode': bar,
        'ExpiredDate': expire,
        'Qty': qty,
        'UnitPriceIn': pricein,
        'UnitPriceOut': priceout,
      },
    );
    if (!mounted) return;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${data['msg_success']}"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${data['msg_error']}"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to send requests to server"),
        ),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Insert Product'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: <Widget>[
              _buildTextField(
                controller: txtProName,
                label: 'Product Name',
                validatorMessage: 'Product Name is required',
              ),
              _buildTextField(
                controller: txtDes,
                label: 'Product Description',
                validatorMessage: 'Product Description is required',
              ),
              _buildTextField(
                controller: txtCatId,
                label: 'Category ID',
                validatorMessage: 'Category ID is required',
              ),
              _buildTextField(
                controller: txtBar,
                label: 'Barcode',
                validatorMessage: 'Barcode is required',
              ),
              _buildDateField(
                context: context,
                controller: txtExDate,
                label: 'Expire Date',
                validatorMessage: 'Expire Date is required',
              ),
              _buildTextField(
                controller: txtQty,
                label: 'Quantity',
                validatorMessage: 'Quantity is required',
              ),
              _buildTextField(
                controller: txtPriceIn,
                label: 'Unit Price In',
                validatorMessage: 'Unit Price In is required',
              ),
              _buildTextField(
                controller: txtPriceOut,
                label: 'Unit Price Out',
                validatorMessage: 'Unit Price Out is required',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String strProName = txtProName.text.trim();
                    String strDes = txtDes.text.trim();
                    String strCatid = txtCatId.text.trim();
                    String strBar = txtBar.text.trim();
                    String strExpire = txtExDate.text.trim();
                    String strQty = txtQty.text.trim();
                    String strPriceIn = txtPriceIn.text.trim();
                    String strPriceOut = txtPriceOut.text.trim();

                    registerproduct(strProName, strDes, strCatid, strBar,
                        strExpire, strQty, strPriceIn, strPriceOut);
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a text field with validation
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
      ),
    );
  }

  // Helper method to create a date picker field
  Widget _buildDateField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String validatorMessage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                controller.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
        ),
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
      ),
    );
  }
}
