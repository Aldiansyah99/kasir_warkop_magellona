import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_pos/cubit/transaction_cubit.dart';
import 'package:si_pos/elements/config.dart';
import 'package:si_pos/elements/custom.dart';
import 'package:http/http.dart' as http;

class EditTransactionPage extends StatefulWidget {
  final int idTransaction;
  final String table;
  final String email;
  const EditTransactionPage(
      {Key key,
      @required this.idTransaction,
      @required this.table,
      @required this.email})
      : super(key: key);

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _tableController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void updateTransaction() async {
    LoadingIndicator.show(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";

    final response = await http.post(
      Uri.parse(
          "$url/api/auth/transaction-master/update/${widget.idTransaction}"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': key,
      },
      body: {
        'meja': _tableController.text.trim(),
        'email': _emailController.text.trim(),
      },
    );

    log(response.body);
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      await context.read<TransactionCubit>().getTransaction();
      // var data = jsonDecode(response.body);
      Navigator.pop(context);
      ShowToast.show(message: 'Update Successfully');
      Navigator.pop(context);

      log('berhasi');
    } else {
      log('gagal');
    }
  }

  @override
  void initState() {
    super.initState();
    _tableController.text = widget.table;
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar('Update Transaction'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: CustomTextField(
                controller: _tableController,
                hintText: "Example: Meja 1",
                obscureText: false,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            CustomTextField(
              controller: _emailController,
              hintText: "Email (Optional)",
              obscureText: false,
            ),
            SizedBox(
              height: 16,
            ),
            ButtonPrimary(
                buttonPressed: () {
                  if (_formKey.currentState.validate()) {
                    updateTransaction();
                  }
                },
                buttonText: "Update"),
          ],
        ),
      ),
    );
  }
}
