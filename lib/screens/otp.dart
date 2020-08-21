import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter_tracer/network_utils/api.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<OtpScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  BuildContext _context;
  final PageController _pageController = PageController(initialPage: 1);
  int _pageIndex = 0;

  int otp;
  int userId;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getProfile();
    _checkIfConnected();
    super.initState();
  }

  Map profile = {};
  String data;

  verifyOtp() async {
    var input = { 'id': userId, 'otp': otp };

    print(input);

    var res = await Network().authData(data, '/verify');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return OtpScreen();
          },
        ),
      );
    }
  }

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
      otp = profile["otp"];
      userId = profile["id"];
    });
    print(profile);
    print(otp);
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

  Widget darkRoundedPinPut() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: Color.fromRGBO(25, 21, 99, 1),
      borderRadius: BorderRadius.circular(20),
    );
    return PinPut(
      eachFieldWidth: 65,
      eachFieldHeight: 65,
      fieldsCount: 4,
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      onSubmit: (String pin) => _showSnackBar(pin),
      submittedFieldDecoration: pinPutDecoration,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration,
      pinAnimationType: PinAnimationType.scale,
      textStyle: TextStyle(color: Colors.white, fontSize: 25),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pinPuts = [
      darkRoundedPinPut(),
    ];

    List<Color> _bgColors = [
      Colors.white,
      Color.fromRGBO(43, 36, 198, 1),
      Colors.white,
      Color.fromRGBO(75, 83, 214, 1),
      Color.fromRGBO(43, 46, 66, 1),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        platform: TargetPlatform.iOS,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.keyboard_backspace,
          //     color: Colors.black87,
          //   ),
          //   onPressed: () => Navigator.pop(context),
          // ),
          centerTitle: true,
          title: Text(
            "One Time Pin",
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Builder(
              builder: (context) {
                _context = context;
                return AnimatedContainer(
                  color: _bgColors[_pageIndex],
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(40),
                  child: PageView(
                    scrollDirection: Axis.vertical,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    children: _pinPuts.map((p) {
                      return FractionallySizedBox(
                        heightFactor: 1,
                        child: Center(child: p),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/otp.jpg',
                      height: 170.0,
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
              child: Center(
                  child: Text(
                "Type the code we've sent to your email\n" + profile["email"],
                style: TextStyle(
                    color: Color.fromRGBO(25, 21, 99, 1),
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              )),
            ),
            _bottomAppBar,
          ],
        ),
      ),
    );
  }

  Widget get _bottomAppBar {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // FlatButton(
          //   child: Text('Focus'),
          //   onPressed: () => _pinPutFocusNode.requestFocus(),
          // ),
          // FlatButton(
          //   child: Text('Unfocus'),
          //   onPressed: () => _pinPutFocusNode.unfocus(),
          // ),
          // FlatButton(
          //   child: Text('Clear All'),
          //   onPressed: () => _pinPutController.text = '',
          // ),
          FlatButton(
            child: Text("Didn't receive a code?"),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  void _showSnackBar(String pin) {
    if (pin == otp.toString()) {
      verifyOtp();
      final snackBar = SnackBar(
        duration: Duration(seconds: 3),
        content: Container(
            height: 50.0,
            child: Center(
              child: Text(
                'Verification success.',
                style: TextStyle(fontSize: 20.0),
              ),
            )),
        backgroundColor: Colors.greenAccent,
      );
      Scaffold.of(_context).hideCurrentSnackBar();
      Scaffold.of(_context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        duration: Duration(seconds: 3),
        content: Container(
            height: 50.0,
            child: Center(
              child: Text(
                'Verification failed.',
                style: TextStyle(fontSize: 20.0),
              ),
            )),
        backgroundColor: Colors.redAccent,
      );
      Scaffold.of(_context).hideCurrentSnackBar();
      Scaffold.of(_context).showSnackBar(snackBar);
    }
  }
}
