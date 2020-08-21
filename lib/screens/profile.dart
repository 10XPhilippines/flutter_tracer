import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tracer/providers/app_provider.dart';
import 'package:flutter_tracer/screens/splash.dart';
import 'package:flutter_tracer/screens/login.dart';
import 'package:flutter_tracer/screens/otp.dart';
import 'package:flutter_tracer/util/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tracer/network_utils/api.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map profile = {};
  String data;
  int userId;
  int isVerified;
  String path;

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
      isVerified = int.parse(profile["is_verified"].toString());
      userId = int.parse(profile["id"].toString());
      path = Network().qrCode() + "/code/" + profile["user_barcode_path"];
    });
    if (isVerified == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            resendOtp();
            return OtpScreen();
          },
        ),
      );
    }
  }

  resendOtp() async {
    var input = {'id': userId};
    print(input);

    var res = await Network().authData(input, '/resend');
    var body = json.decode(res.body);
    if (body['success']) {
      print('Debug OTP resend');
      print(userId);
    }
  }

  void logout() async {
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return SplashScreen();
          },
        ),
      );
    }
  }

  _checkIfConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        getProfile();
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
                  labelText: 'Full Name',
                  hintText: "Enter full name",
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
              child: const Text('Save'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    getProfile();
    _checkIfConnected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Image.network(
                    profile["image"] ??
                        "https://img.icons8.com/fluent/48/000000/user-male-circle.png",
                    fit: BoxFit.cover,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            profile["name"] ?? "No data available",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          int.parse(profile["is_verified"].toString()) == 1
                              ? Icon(
                                  Icons.verified_user,
                                  color: Colors.greenAccent,
                                )
                              : Icon(Icons.verified_user,
                                  color: Colors.redAccent),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            profile["email"] ?? "No data available",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Logout"),
                                      content: Text("You are about to logout."),
                                      actions: <Widget>[
                                        new FlatButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                        new FlatButton(
                                            child: const Text('Logout'),
                                            onPressed: () {
                                              logout();
                                            })
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).accentColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  flex: 3,
                ),
              ],
            ),
            // Divider(),
            Container(height: 15.0),
            Padding(
              padding: EdgeInsets.all(0.0),
              child: ListTile(
                title: Text(
                  "Account Information".toUpperCase(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.mode_edit,
                    size: 20.0,
                  ),
                  onPressed: () {
                    _showDialog();
                  },
                  tooltip: "Edit",
                ),
              ),
            ),

            ListTile(
              title: Text(
                "Name",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                profile["name"] ?? "No data available",
              ),
            ),
            ListTile(
              title: Text(
                "Email",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                profile["email"] ?? "No data available",
              ),
            ),
            ListTile(
              title: Text(
                "Phone",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                profile["phone"] ?? "No data available",
              ),
            ),
            ListTile(
              title: Text(
                "Address",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                profile["province"] ?? "No data available",
              ),
            ),
            ListTile(
              title: Text(
                "Gender",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                profile["sex"] ?? "No data available",
              ),
            ),
            // MediaQuery.of(context).platformBrightness == Brightness.dark
            //     ? SizedBox()
            //     : ListTile(
            //         title: Text(
            //           "Dark Theme",
            //           style: TextStyle(
            //             fontSize: 17,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //         trailing: Switch(
            //           value: Provider.of<AppProvider>(context).theme ==
            //                   Constants.lightTheme
            //               ? false
            //               : true,
            //           onChanged: (v) async {
            //             if (v) {
            //               Provider.of<AppProvider>(context, listen: false)
            //                   .setTheme(Constants.darkTheme, "dark");
            //             } else {
            //               Provider.of<AppProvider>(context, listen: false)
            //                   .setTheme(Constants.lightTheme, "light");
            //             }
            //           },
            //           activeColor: Theme.of(context).accentColor,
            //         ),
            //       ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Image.network(path),
                  actions: <Widget>[
                    new FlatButton(
                        child: const Text('Export'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    new FlatButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                );
              });
        },
        label: Text('My QR'),
        icon: Icon(Icons.camera),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
