import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:restaurant_ui_kit/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  Map profile = {};
  Map business = {};
  Map user = {};
  String data;
  String business_data;
  String barcode = "";

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
    });
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);
    _getBusiness();
  }

  void _getBusiness() async {
    String url = '/business/' + barcode + '/' + profile["id"].toString();
    print("GET: " + url);
    var res = await Network().getData(url);
    var body = json.decode(res.body);
    if (body['success']) {
      setState(() {
        business = body;
      });
    }
    print(body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Contact Tracing",
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
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
                  decoration: InputDecoration(
                    labelText: "Email",
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
                    hintText: "Email",
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    prefixIcon: Icon(
                      Icons.perm_identity,
                      color: Colors.black,
                    ),
                  ),
                  maxLines: 1,
                  onChanged: (value) {},
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
                  decoration: InputDecoration(
                    labelText: "Password",
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
                    hintText: "Password",
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  obscureText: true,
                  maxLines: 1,
                  onChanged: (value) {},
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
                onPressed: () {},
              ),
            ),

            SizedBox(height: 30.0),

            Container(
              height: 50.0,
              child: RaisedButton(
                child: Text(
                  barcode,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _getBusiness();
                },
                color: Theme.of(context).accentColor,
              ),
            ),

            SizedBox(height: 10.0),
            Divider(
              color: Theme.of(context).accentColor,
            ),
            SizedBox(height: 10.0),

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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _scan();
        },
        label: Text('Scan Now'),
        icon: Icon(Icons.camera),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
