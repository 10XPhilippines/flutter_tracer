import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tracer/screens/cart.dart';
import 'package:flutter_tracer/screens/favorite_screen.dart';
import 'package:flutter_tracer/screens/home.dart';
import 'package:flutter_tracer/screens/notifications.dart';
import 'package:flutter_tracer/screens/profile.dart';
import 'package:flutter_tracer/screens/search.dart';
import 'package:flutter_tracer/util/const.dart';
import 'package:flutter_tracer/widgets/badge.dart';
import 'package:flutter_tracer/screens/questions.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Uint8List bytes = Uint8List(0);
  PageController _pageController;
  int _page = 0;

  @override
  initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.camera, size: 20.0),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Questions();
                    },
                  ),
                );
              },
            );
          }),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            Constants.appName,
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: IconBadge(
                icon: Icons.notifications,
                size: 22.0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Notifications();
                    },
                  ),
                );
              },
              tooltip: "Notifications",
            ),
          ],
        ),

        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            Profile(),
            Home(),
            FavoriteScreen(),
            SearchScreen(),
            CartScreen(),
          ],
        ),

        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 7),
              // IconButton(
              //   icon: Icon(
              //     Icons.home,
              //     size: 24.0,
              //   ),
              //   color: _page == 0
              //       ? Theme.of(context).accentColor
              //       : Theme
              //       .of(context)
              //       .textTheme.caption.color,
              //   onPressed: ()=>_pageController.jumpToPage(0),
              // ),

              // IconButton(
              //   icon:Icon(
              //     Icons.favorite,
              //     size: 24.0,
              //   ),
              //   color: _page == 1
              //       ? Theme.of(context).accentColor
              //       : Theme
              //       .of(context)
              //       .textTheme.caption.color,
              //   onPressed: ()=>_pageController.jumpToPage(1),
              // ),

              // IconButton(
              //   icon: Icon(
              //     Icons.search,
              //     size: 24.0,
              //     color: Theme.of(context).primaryColor,
              //   ),
              //   color: _page == 2
              //       ? Theme.of(context).accentColor
              //       : Theme
              //       .of(context)
              //       .textTheme.caption.color,
              //   onPressed: ()=>_pageController.jumpToPage(2),
              // ),

              // IconButton(
              //   icon: IconBadge(
              //     icon: Icons.shopping_cart,
              //     size: 24.0,
              //   ),
              //   color: _page == 3
              //       ? Theme.of(context).accentColor
              //       : Theme
              //       .of(context)
              //       .textTheme.caption.color,
              //   onPressed: ()=>_pageController.jumpToPage(3),
              // ),

              IconButton(
                icon: Icon(
                  Icons.person,
                  size: 24.0,
                ),
                color: _page == 4
                    ? Theme.of(context).accentColor
                    : Theme.of(context).textTheme.caption.color,
                onPressed: () => _pageController.jumpToPage(4),
              ),

              SizedBox(width: 7),
            ],
          ),
          color: Theme.of(context).primaryColor,
          //shape: CircularNotchedRectangle(),
        ),

        // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   elevation: 4.0,
        //   child: Icon(
        //     Icons.search,
        //   ),
        //   onPressed: ()=>_pageController.jumpToPage(2),
        // ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
