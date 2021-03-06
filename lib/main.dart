import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:si_pos/cubit/delete_product_transaction_cubit.dart';
import 'package:si_pos/cubit/delete_transaction_cubit.dart';
import 'package:si_pos/cubit/detail_transaction_cubit.dart';
import 'package:si_pos/cubit/done_transaction_cubit.dart';
import 'package:si_pos/cubit/report_cubit.dart';
import 'package:si_pos/cubit/send_invoice_cubit.dart';
import 'package:si_pos/cubit/send_report_to_email_cubit.dart';
import 'package:si_pos/cubit/transaction_cubit.dart';
import 'elements/custom.dart' as custom;
import 'elements/config.dart';
import 'page/home.dart' as home;

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => TransactionCubit()),
      BlocProvider(create: (_) => DetailTransactionCubit()),
      BlocProvider(create: (_) => DeleteProductTransactionCubit()),
      BlocProvider(create: (_) => DoneTransactionCubit()),
      BlocProvider(create: (_) => DeleteTransactionCubit()),
      BlocProvider(create: (_) => ReportCubit()),
      BlocProvider(create: (_) => SendInvoiceCubit()),
      BlocProvider(create: (_) => SendReportToEmailCubit()),
    ],
    child: new MaterialApp(
        title: 'Warkop Magellona',
        home: new Splash(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.blue,
            backgroundColor: Colors.white,
            fontFamily: "DMSans",
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.white))),
  ));
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    setSplash();
  }

  setSplash() async {
    var duration = Duration(seconds: 2);
    return Timer(duration, checkLogin);
  }

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("loginToken") != null) {
      await getUser();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return home.Home();
      }));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return Prepage();
      }));
    }
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";
    Map<String, dynamic> json;

    final response = await http.get(
      Uri.parse("$url/api/auth/user"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    if (response.statusCode == 200) {
      json = jsonDecode(response.body);
      prefs.setInt('userId', json['id']);
      prefs.setString('userName', json['username']);
      prefs.setString('userEmail', json['email']);
      prefs.setInt('role', json['role']);
    } else {
      logout();
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return Prepage();
    }));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return (new Center(
      child: Container(
        padding: EdgeInsets.all(24),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/logo.jpeg",
            ),
          ],
        ),
      ),
    ));
  }
}

class Prepage extends StatefulWidget {
  @override
  _PrepageState createState() => new _PrepageState();
}

class _PrepageState extends State<Prepage> {
  void gotoLogin() {
    Navigator.push(
        context,
        PageTransition(
            child: Login(),
            type: PageTransitionType.rightToLeft,
            inheritTheme: true,
            ctx: context));
  }

  void gotoRegister() {
    Navigator.push(
        context,
        PageTransition(
            child: Register(),
            type: PageTransitionType.rightToLeft,
            inheritTheme: true,
            ctx: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(30),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              Image.asset(
                "images/logo.jpeg",
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  custom.ButtonPrimary(
                      buttonPressed: gotoLogin, buttonText: "Sign in"),
                  SizedBox(height: 20),
                  Text('Version 1.0.0 - Build.1',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              )),
            ],
          )),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool showStatus = false;

  void forceLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> json;
    String username = usernameController.value.text;
    String password = passwordController.value.text;

    final response = await http.post(Uri.parse("$url/api/auth/login"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));

    isLoading = true;

    if (this.mounted) {
      setState(() {
        if (response.statusCode == 200) {
          json = jsonDecode(response.body);
          prefs.setString("loginToken", json["access_token"]);
          getUser();
        } else {
          isLoading = false;
          json = {"message": "Login failed wrong username/password"};
          showStatus = true;
        }
      });
    }
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";
    Map<String, dynamic> json;

    final response = await http.get(
      Uri.parse("$url/api/auth/user"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    if (response.statusCode == 200) {
      json = jsonDecode(response.body);
      prefs.setInt('userId', json['id']);
      prefs.setString('userName', json['username']);
      prefs.setString('userEmail', json['email']);
      prefs.setInt('role', json['role']);
    }

    setState(() {
      isLoading = false;
      showStatus = false;
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 1);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return home.Home();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Stack(children: [
              isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          backgroundColor: Colors.blue,
                          minHeight: 1,
                        )
                      ],
                    )
                  : SizedBox(height: 4),
              Container(
                padding: EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Image.asset(
                      "images/logo.jpeg",
                      // width: 300,
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showStatus
                              ? Container(
                                  child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Text("Login failed wrong username/password",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 14)),
                                  ],
                                ))
                              : SizedBox(height: 0),
                          SizedBox(height: 20),
                          custom.CustomTextField(
                              controller: usernameController,
                              hintText: "Username",
                              obscureText: false),
                          SizedBox(height: 20),
                          custom.CustomTextField(
                              controller: passwordController,
                              hintText: "Password",
                              obscureText: true),
                          SizedBox(height: 30),
                          custom.ButtonPrimary(
                              buttonPressed: isLoading ? null : forceLogin,
                              buttonText: "Sign In"),
                          SizedBox(height: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text('Version 1.0.0 - Build.1',
                                    style: TextStyle(
                                        color: Colors.grey[500], fontSize: 12)),
                              ),
                              SizedBox(height: 20),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]))));
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => new _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  bool showStatus = false;
  Map<String, dynamic> json;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final cpasswordController = TextEditingController();
  String message = " ";

  void forceRegister() async {
    String username = usernameController.value.text;
    String password = passwordController.value.text;
    String cpassword = cpasswordController.value.text;
    String email = emailController.value.text;

    final response = await http.post(
      Uri.parse("$url/api/auth/signup"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'email': email,
        'password_confirmation': cpassword,
      }),
    );

    isLoading = true;

    setState(() {
      message = " ";
      showStatus = false;
    });

    if (this.mounted) {
      json = jsonDecode(response.body);
      setState(() {
        var duration = new Duration(seconds: 2);
        Timer(duration, (() {
          setState(() {
            if (response.statusCode == 201) {
              forceLogin();
            } else {
              isLoading = false;
              showStatus = true;
              try {
                json["errors"].forEach((key, value) {
                  if (message == " ") {
                    message = value[0];
                  }
                });
              } on PlatformException {
                message = "Something was wrong pleasr check your input";
              }
            }
          });
        }));
      });
    }
  }

  void forceLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> json;
    String username = usernameController.value.text;
    String password = passwordController.value.text;

    final response = await http.post(Uri.parse("$url/api/auth/login"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));

    if (this.mounted) {
      setState(() {
        if (response.statusCode == 200) {
          json = jsonDecode(response.body);
          prefs.setString("loginToken", json["access_token"]);
          getUser();
        } else {
          isLoading = false;
          json = {"message": "Login failed wrong username/password"};
          showStatus = true;
        }
      });
    }
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('loginToken');
    String key = "Bearer $token";
    Map<String, dynamic> json;

    final response = await http.get(
      Uri.parse("$url/api/auth/user"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': key,
      },
    );

    if (response.statusCode == 200) {
      json = jsonDecode(response.body);
      prefs.setInt('userId', json['id']);
      prefs.setString('userName', json['username']);
      prefs.setString('userEmail', json['email']);
      prefs.setInt('role', json['role']);
    }

    setState(() {
      isLoading = false;
      showStatus = false;
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 1);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return home.Home();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
            elevation: 3,
            shadowColor: Colors.black54,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            title: Text("Sign Up",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold))),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: SingleChildScrollView(
                child: Stack(children: [
              isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          backgroundColor: Colors.blue,
                          minHeight: 1,
                        )
                      ],
                    )
                  : SizedBox(height: 4),
              Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hello please complete form below",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15)),
                          SizedBox(height: 10),
                          Text("User Data",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          showStatus
                              ? Container(
                                  child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Text(message,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 14)),
                                  ],
                                ))
                              : SizedBox(height: 0),
                          SizedBox(height: 20),
                          custom.CustomTextField(
                              controller: usernameController,
                              hintText: "Username",
                              obscureText: false),
                          SizedBox(height: 20),
                          custom.CustomTextField(
                              controller: emailController,
                              hintText: "Email",
                              obscureText: false),
                          SizedBox(height: 20),
                          custom.CustomTextField(
                              controller: passwordController,
                              hintText: "Password",
                              obscureText: true),
                          SizedBox(height: 20),
                          custom.CustomTextField(
                              controller: cpasswordController,
                              hintText: "Password Confirmation",
                              obscureText: true),
                          SizedBox(height: 30),
                          custom.ButtonPrimary(
                              buttonPressed: isLoading ? null : forceRegister,
                              buttonText: "Sign Up"),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ])))));
  }
}
