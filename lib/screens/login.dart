import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tracer/screens/main_screen.dart';
import 'package:flutter_tracer/screens/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tracer/network_utils/api.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();
  var email;
  var password;
  Map profile = {};
  String datas;
  String dataOtp;
  int userId;
  int isVerified;
  bool _isLoading = false;

  String responseName = "Enter your name";
  String responsePassword = "Enter your password";

  Future getFuture() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 2));
      return 'Hello, Future Progress Dialog!';
    });
  }

  Future<void> showProgress(BuildContext context) async {
    await showDialog(
        context: context,
        child: FutureProgressDialog(getFuture(), message: Text('Loading...')));
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    var data = {'email': email, 'password': password};

    print(data);

    var res = await Network().authData(data, '/login');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));

      SharedPreferences preferences = await SharedPreferences.getInstance();
      datas = preferences.getString("user");
      setState(() {
        profile = json.decode(datas);
        isVerified = int.parse(profile["is_verified"].toString());
        userId = int.parse(profile["id"].toString());
      });

      if (isVerified == 1) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return MainScreen();
            },
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              resendOtp();
              return OtpScreen();
            },
          ),
        );
      }
    } else {
      // showProgress(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Failed"),
              content: Text("Invalid credentials. Try again."),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            );
          });
    }

    print("Debug login");
    print(body);

    setState(() {
      _isLoading = false;
    });
  }

  resendOtp() async {
    var input = {'id': userId};
    print(input);

    var res = await Network().authData(input, '/resend');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      dataOtp = preferences.getString("user");
    }
    print('Debug OTP resend');
    print(userId);
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Reset Password',
                  hintText: "Enter your email",
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  _checkIfConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Network"),
              content: Text("You are not connected to the internet."),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            );
          });
    }
  }

  @override
  void initState() {
    _checkIfConnected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: 25.0,
            ),
            child: Text(
              "Log in to your account",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),

          SizedBox(height: 30.0),

          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Enter your email",
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                  ),
                  // prefixIcon: Icon(
                  //   Icons.perm_identity,
                  //   color: Colors.black,
                  // ),
                ),
                maxLines: 1,
                controller: _usernameControl,
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
          ),

          SizedBox(height: 10.0),

          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Enter your password",
                  // prefixIcon: Icon(
                  //   Icons.lock_outline,
                  //   color: Colors.black,
                  // ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                  ),
                ),
                obscureText: true,
                maxLines: 1,
                controller: _passwordControl,
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
          ),

          SizedBox(height: 10.0),

          Container(
            alignment: Alignment.centerRight,
            child: FlatButton(
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () {
                _showDialog();
              },
            ),
          ),

          SizedBox(height: 30.0),

          Container(
            height: 50.0,
            child: RaisedButton(
              child: Text(
                _isLoading ? 'Login'.toUpperCase() : 'Login'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                _login();
                // await pr.show();
              },
              color: Theme.of(context).accentColor,
            ),
          ),

          SizedBox(height: 10.0),
          // Divider(
          //   color: Theme.of(context).accentColor,
          // ),
          // SizedBox(height: 10.0),

          // Center(
          //   child: Container(
          //     width: MediaQuery.of(context).size.width/2,
          //     child: Row(
          //       children: <Widget>[
          //         RawMaterialButton(
          //           onPressed: (){},
          //           fillColor: Colors.blue[800],
          //           shape: CircleBorder(),
          //           elevation: 4.0,
          //           child: Padding(
          //             padding: EdgeInsets.all(15),
          //             child: Icon(
          //               FontAwesomeIcons.facebookF,
          //               color: Colors.white,
          //               //size: 24.0,
          //             ),
          //           ),
          //         ),

          //         RawMaterialButton(
          //           onPressed: (){},
          //           fillColor: Colors.white,
          //           shape: CircleBorder(),
          //           elevation: 4.0,
          //           child: Padding(
          //             padding: EdgeInsets.all(15),
          //             child: Icon(
          //               FontAwesomeIcons.google,
          //               color: Colors.blue[800],
          //               //size: 24.0,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
