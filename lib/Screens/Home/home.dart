import 'package:flutter/material.dart';

import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:wally/Screens/Home/catagory.dart';
import 'package:wally/Screens/Home/favs.dart';
import 'package:wally/Screens/Home/featured.dart';

import '../../widgets/nav.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _activeIndex = 0;
  final pages = <Widget>[const Featured(), const Catagory(), const Favs()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_activeIndex],
      extendBody: true,
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Nav(
          onIndexChanged: (index) {
            setState(() {
              Vibrate.feedback(FeedbackType.success);
              _activeIndex = index;
            });
          },
          activeIndex: _activeIndex,
        ),
      ),
    );
  }
}
