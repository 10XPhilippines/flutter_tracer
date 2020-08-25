import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_tracer/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';
import 'package:flutter_tracer/screens/main_screen.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  Uint8List bytes = Uint8List(0);
  Map profile = {};
  String data;
  String userId;
  String dateEntry;
  String dateExit;
  String soreThroat;
  String headAche;
  String fever;
  String cough;
  String exposure;
  String travelHistory;
  String bodyPain;
  var rawJson = [];

  List<SmartSelectOption<String>> options = [
    SmartSelectOption<String>(value: 'Yes', title: 'Yes'),
    SmartSelectOption<String>(value: 'No', title: 'No'),
  ];

  DateTime now = DateTime.now();

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
      userId = profile["id"].toString();
      dateEntry = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      rawJson.insert(0, userId);
      rawJson.insert(1, dateEntry);
    });
    print(data);
    print(rawJson);
    _generateBarCode(rawJson.toString());
  }

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }

  @override
  void initState() {
    getProfile();
    super.initState();
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
            SizedBox(
              height: 190,
              child: bytes.isEmpty
                  ? Center(
                      child: Text('No code generated.',
                          style: TextStyle(color: Colors.black38)),
                    )
                  : Image.memory(bytes),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                top: 25.0,
                left: 10.0,
              ),
              child: Text(
                "Required Questions",
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
                onChange: (val) => {
                      setState(() {
                        soreThroat = val;
                        if (rawJson.asMap().containsKey(2) == false) {
                          rawJson.insert(2, val);
                        } else {
                          rawJson.removeAt(2);
                          rawJson.insert(2, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(2));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have headache?',
                value: headAche,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        headAche = val;
                        if (rawJson.asMap().containsKey(3) == false) {
                          rawJson.insert(3, val);
                        } else {
                          rawJson.removeAt(3);
                          rawJson.insert(3, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(3));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have fever?',
                value: fever,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => fever = val)),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have travel history?',
                value: travelHistory,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => travelHistory = val)),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have exposure?',
                value: exposure,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => exposure = val)),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have cough or colds?',
                value: cough,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => cough = val)),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have body pain?',
                value: bodyPain,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => bodyPain = val)),
            SizedBox(height: 80.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print(rawJson);
        },
        label: Text('Save'),
        icon: Icon(Icons.check_circle),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
