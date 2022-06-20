import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import '../elements/custom.dart' as custom;
import '../page/product.dart' as productPage;
import 'transaction.dart' as transaction;
import '../elements/config.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddTransaction extends StatefulWidget {
  @override
  AddTransaction({this.productsId, this.name = ""});
  final String productsId, name;
  _AddTransaction createState() => _AddTransaction();
}

class _AddTransaction extends State<AddTransaction> {
  final transactionCode = TextEditingController();
  final countController = TextEditingController();
  final totalPrice = TextEditingController();
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  final productStockController = TextEditingController();
  String generatedNumber;
  bool isLoading = true;
  int totalPrices = 0;
  List<dynamic> product;
  int totalProduct = 0;
  bool haveItem = false;
  int productCount;
  bool isEmpty = true;
  var selectedProduct;
  var transactionCount = 1;

  @override
  void initState() {
    super.initState();
    generateNumber();
    getProducts();
    // setState(() {
    //   transactionCode.text = generatedNumber;
    //   totalPrice.text = totalPrices.toString();
    // });
  }

  void getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";
    List<dynamic> json;

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
        setState(() {
          Map<String, dynamic> data = jsonDecode(response.body);
          json = data["data"];
          if (json.length > 0) {
            haveItem = true;
            isEmpty = false;
            productCount = json.length;
            product = json;
            dev.log('product : ${product.toString()}');
            isLoading = false;
          } else {
            isLoading = false;
          }
        });
      } on PlatformException {
        print("Something was wrong");
      }
    }
  }

  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     getProducts(barcodeScanRes);
  //   } on PlatformException {
  //     print('sjdjsk');
  //   }
  // }

  // void getProducts(productsId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('loginToken');
  //   String key = "Bearer $token";

  //   if (productsId != "-1") {
  //     final response = await http.get(
  //       Uri.parse("$url/api/auth/products/get/$productsId"),
  //       headers: <String, String>{
  //         'Accept': 'application/json',
  //         'Authorization': key,
  //       },
  //     );
  //     Map<String, dynamic> json = jsonDecode(response.body);
  //     if (json["data"] != null) {
  //       setState(() {
  //         totalPrices += json["data"]["price"];
  //         totalPrice.text = totalPrices.toString();
  //         if (product == null) {
  //           product = [json["data"]];
  //         } else {
  //           product.add(json["data"]);
  //         }

  //         totalProduct += 1;
  //       });
  //     } else {
  //       AlertDialog noItems = AlertDialog(
  //         title: Text("Sorry"),
  //         content: Text("Items not found in your inventory."),
  //         actions: [
  //           TextButton(
  //             child: Text("Close"),
  //             onPressed: () => Navigator.pop(context),
  //           )
  //         ],
  //       );
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return noItems;
  //         },
  //       );
  //     }
  //   }
  // }

  void saveTransaction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final response = await http.post(
      Uri.parse('$url/api/auth/transaction'),
      body: <String, dynamic>{
        'price': totalPrice.value.text,
        'count': productCount.toString(),
        'sell_at': formattedDate,
        'products_id': selectedProduct,
        // 'tipe': 'pemasukan'
      },
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    Map<String, dynamic> json = jsonDecode(response.body);

    product.forEach((value) async {
      await http.post(
        Uri.parse('$url/api/auth/transaction/insertItem'),
        body: <String, dynamic>{
          'id': json["data"]["id"].toString(),
          'products': value["id"].toString(),
        },
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': key,
        },
      );
    });

    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
    Navigator.push(
        context,
        PageTransition(
            child: transaction.Transaction(),
            type: PageTransitionType.rightToLeft));
  }

  void generateNumber() {
    var random = new Random();
    int min = 10000;
    int max = 99999;
    setState(() {
      generatedNumber = "#${(min + random.nextInt(max - min)).toString()}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: custom.customAppBar("Add Transaction"),
      body: Stack(children: [
        isLoading
            ? LinearProgressIndicator(
                minHeight: 1, backgroundColor: Colors.blue)
            : SizedBox(height: 0),
        if (isLoading == false)
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter form below to add transaction",
                      style: TextStyle(color: Colors.black87, fontSize: 15)),
                  SizedBox(height: 10),
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
                    child: DropdownButtonFormField<dynamic>(
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
                      value: selectedProduct,
                      isDense: true,
                      hint: Text(
                        'Select Product',
                      ),
                      items: product
                          .map(
                            (e) => DropdownMenuItem(
                              onTap: () {
                                dev.log('value : $e');
                                setState(() {
                                  totalPrices = e['price'];
                                  totalPrice.text =
                                      (transactionCount * totalPrices)
                                          .toString();
                                  dev.log(totalPrices.toString());
                                  dev.log(totalPrice.text);
                                });
                              },
                              value: e['products_id'],
                              child: Text(
                                e['name'],
                                // style: t,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (dynamic value) {
                        selectedProduct = value;
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
            )),
          )
      ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: saveTransaction,
          child: Icon(Icons.save, color: Colors.white)),
    );
  }
}
