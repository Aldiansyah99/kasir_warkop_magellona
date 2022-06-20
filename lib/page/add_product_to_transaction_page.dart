import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_pos/cubit/detail_transaction_cubit.dart';
import 'package:si_pos/elements/config.dart';
import 'package:si_pos/elements/custom.dart';
import 'package:si_pos/models/product.dart';
import '../elements/custom.dart' as custom;
import 'package:http/http.dart' as http;

class AddProductToTransactionPage extends StatefulWidget {
  final int idTransaction;
  const AddProductToTransactionPage({Key key, @required this.idTransaction})
      : super(key: key);

  @override
  State<AddProductToTransactionPage> createState() =>
      _AddProductToTransactionPageState();
}

class _AddProductToTransactionPageState
    extends State<AddProductToTransactionPage> {
  final transactionCode = TextEditingController();
  final countController = TextEditingController();
  final totalPrice = TextEditingController();
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  final productStockController = TextEditingController();
  String generatedNumber;
  bool isLoading = true;
  int totalPrices = 0;
  List<Product> product;
  int totalProduct = 0;
  bool haveItem = false;
  bool isEmpty = true;
  var idProduct;
  var transactionCount = 1;

  void getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";

    final response = await http.get(
      Uri.parse("$url/api/auth/products"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    setState(() {
      isLoading = true;
    });

    if (this.mounted) {
      try {
        var data = jsonDecode(response.body);
        product =
            List<Product>.from(data["data"].map((x) => Product.fromJson(x)));
        log(product.toString());
        if (product.length > 0) {
          haveItem = true;
          isEmpty = false;
          log('product : ${product.toString()}');
          isLoading = false;
        } else {
          isLoading = false;
        }
      } on PlatformException {
        print("Something was wrong");
      }
    }
  }

  void addProductToTransaction() async {
    LoadingIndicator.show(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final response = await http.post(
      Uri.parse('$url/api/auth/transaction'),
      body: {
        'transaction_id': widget.idTransaction.toString(),
        'price': totalPrice.text.trim(),
        'count': transactionCount.toString(),
        'sell_at': formattedDate.toString(),
        'products_id': idProduct.toString(),
      },
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    if (response.statusCode == 200) {
      await context
          .read<DetailTransactionCubit>()
          .getDetailTransaction(widget.idTransaction);
      Navigator.pop(context);
      Navigator.pop(context);
      log('berhasil');
    } else {
      Navigator.pop(context);
      log('gagal');
    }

    // product.forEach((value) async {
    //   await http.post(
    //     Uri.parse('$url/api/auth/transaction/insertItem'),
    //     body: <String, dynamic>{
    //       'id': json["data"]["id"].toString(),
    //       'products': value["id"].toString(),
    //     },
    //     headers: <String, String>{
    //       'Accept': 'application/json',
    //       'Authorization': key,
    //     },
    //   );
    // });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Add Product'),
      backgroundColor: Colors.white,
      floatingActionButton: (isLoading != true)
          ? FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                addProductToTransaction();
              },
              child: Icon(Icons.save, color: Colors.white),
            )
          : null,
      body: isLoading == true
          ? LinearProgressIndicator(minHeight: 1, backgroundColor: Colors.blue)
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Transaction Data",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey[200])),
                    child: DropdownButtonFormField<int>(
                      validator: ((value) =>
                          (value == null) ? 'Select Product' : null),
                      icon: Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent))),
                      value: idProduct,
                      isDense: true,
                      hint: Text(
                        'Select Product',
                      ),
                      items: product
                          .map(
                            (e) => DropdownMenuItem(
                              onTap: () {
                                setState(() {
                                  totalPrices = e.price;
                                  totalPrice.text =
                                      (transactionCount * totalPrices)
                                          .toString();
                                });
                              },
                              value: e.id,
                              child: Text(
                                e.name,
                                // style: t,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (dynamic value) {
                        idProduct = value;
                        log(idProduct.toString());
                      },
                    ),
                  ),

                  SizedBox(height: 20),
                  Text('Count'),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (transactionCount > 1) {
                              transactionCount--;
                              totalPrice.text =
                                  (transactionCount * totalPrices).toString();
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(transactionCount.toString()),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            transactionCount++;
                            totalPrice.text =
                                (transactionCount * totalPrices).toString();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  custom.CustomTextField(
                      controller: totalPrice,
                      hintText: "Total",
                      obscureText: false,
                      enabled: false),
                  SizedBox(height: 20),
                  //   custom.ButtonPrimary(buttonText: "Add Product", buttonPressed: scanBarcodeNormal),
                  //   SizedBox(height: 20),
                  //   ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount: totalProduct,
                  //     itemBuilder: (context, index) {
                  //       return custom.ListProduct(
                  //         img: "https://bwipjs-api.metafloor.com/?bcid=code128&text=${product[index]["products_id"]}",
                  //         name: product[index]["name"],
                  //         price: product[index]["price"].toString(),
                  //         buttonPressed: null
                  //       );
                  //     }
                  //   ),
                ],
              ),
            ),
    );
  }
}
