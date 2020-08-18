import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:restaurant_ui_kit/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';

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
  String businessName = "Business";
  String dateEntry = "";
  String dateExit = "";
  String soreThroat = "No";
  String headAche = "No";
  String fever = "No";
  String cough = "No";
  String exposure = "No";
  String travelHistory = "No";
  String bodyPain = "No";

  List<SmartSelectOption<String>> options = [
    SmartSelectOption<String>(value: 'No', title: 'No'),
    SmartSelectOption<String>(value: 'Yes', title: 'Yes'),
  ];

  @override
  void initState() {
    getProfile();
    _scan();
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
        businessName = business["business"]["business_name"];
      });
    }
    print(business);
    print(business["business"]["business_name"]);
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
              margin: EdgeInsets.only(top: 25.0, left: 10.0),
              child: Text(
                businessName,
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
                    hintText: "Enter your street",
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
                top: 25.0,
                left: 10.0,
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

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
              title: 'Do you have sore throat?',
              value: soreThroat,
              options: options,
              modalType: SmartSelectModalType.bottomSheet,
              choiceType: SmartSelectChoiceType.radios,
              onChange: (val) => setState(() => soreThroat = val)
            ),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
              title: 'Do you have headache?',
              value: headAche,
              options: options,
              modalType: SmartSelectModalType.bottomSheet,
              choiceType: SmartSelectChoiceType.radios,
              onChange: (val) => setState(() => headAche = val)
            ),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
              title: 'Do you have fever?',
              value: fever,
              options: options,
              modalType: SmartSelectModalType.bottomSheet,
              choiceType: SmartSelectChoiceType.radios,
              onChange: (val) => setState(() => fever = val)
            ),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
              title: 'Do you have travel history?',
              value: travelHistory,
              options: options,
              modalType: SmartSelectModalType.bottomSheet,
              choiceType: SmartSelectChoiceType.radios,
              onChange: (val) => setState(() => travelHistory = val)
            ),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
              title: 'Do you have exposure?',
              value: exposure,
              options: options,
              modalType: SmartSelectModalType.bottomSheet,
              choiceType: SmartSelectChoiceType.radios,
              onChange: (val) => setState(() => exposure = val)
            ),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
              title: 'Do you have cough or colds?',
              value: cough,
              options: options,
              modalType: SmartSelectModalType.bottomSheet,
              choiceType: SmartSelectChoiceType.radios,
              onChange: (val) => setState(() => cough = val)
            ),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
              title: 'Do you have body pain?',
              value: bodyPain,
              options: options,
              modalType: SmartSelectModalType.bottomSheet,
              choiceType: SmartSelectChoiceType.radios,
              onChange: (val) => setState(() => bodyPain = val)
            ),

            // Container(
            //   alignment: Alignment.centerRight,
            //   child: FlatButton(
            //     child: Text(
            //       "Submit answers",
            //       style: TextStyle(
            //         fontSize: 14.0,
            //         fontWeight: FontWeight.w500,
            //         color: Theme.of(context).accentColor,
            //       ),
            //     ),
            //     onPressed: () {},
            //   ),
            // ),

            SizedBox(height: 80.0),

      
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          
        },
        label: Text('Submit'),
        icon: Icon(Icons.check_circle),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
