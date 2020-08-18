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
  String barcode = "";
  String dateEntry = "";
  String dateExit = "";

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

  _getBusiness() async {
    String url = '/business/' + barcode + '/' + profile["id"].toString();
    print("GET: " + url);
    var res = await Network().getData(url);
    var body = json.decode(res.body);
    if (body['success']) {
      setState(() {
        business = body;
      });
    }
    print(business);
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
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                top: 25.0, left: 10.0
              ),
              child: Text(
                business["business_name"] ?? "Business",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
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
                    labelText: profile["name"] ?? "Name",
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
                    hintText: "Enter your name",
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    // prefixIcon: Icon(
                    //   Icons.perm_identity,
                    //   color: Colors.black,
                    // ),
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
                    labelText: profile["email"] ?? "Email Address",
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
                    // prefixIcon: Icon(
                    //   Icons.call,
                    //   color: Colors.black,
                    // ),
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
                    labelText: profile["phone"] ?? "Phone Number",
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
                    hintText: "Enter your phone number",
                    // prefixIcon: Icon(
                    //   Icons.call,
                    //   color: Colors.black,
                    // ),
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
                    labelText: "Street (Optional)",
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
                    hintText: "Enter your street number",
                    // prefixIcon: Icon(
                    //   Icons.call,
                    //   color: Colors.black,
                    // ),
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
                    labelText: "Barangay",
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
                    hintText: "Enter your barangay",
                    // prefixIcon: Icon(
                    //   Icons.call,
                    //   color: Colors.black,
                    // ),
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
                    labelText: "Municipality",
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
                    hintText: "Enter your municipality",
                    // prefixIcon: Icon(
                    //   Icons.call,
                    //   color: Colors.black,
                    // ),
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
                    labelText: "Province",
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
                    hintText: "Enter your province",
                    // prefixIcon: Icon(
                    //   Icons.call,
                    //   color: Colors.black,
                    // ),
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
                    labelText: "Facebook (Optional)",
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
                    hintText: "Enter your facebook link",
                    // prefixIcon: Icon(
                    //   Icons.call,
                    //   color: Colors.black,
                    // ),
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
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                top: 25.0, left: 10.0,
              ),
              child: Text(
                "Questions",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            

            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  "Submit answers",
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

            // Container(
            //   height: 50.0,
            //   child: RaisedButton(
            //     child: Text(
            //       barcode,
            //       style: TextStyle(
            //         color: Colors.white,
            //       ),
            //     ),
            //     onPressed: () {
            //       _getBusiness();
            //     },
            //     color: Theme.of(context).accentColor,
            //   ),
            // ),

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
