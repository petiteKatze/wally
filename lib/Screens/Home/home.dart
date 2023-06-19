import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E9EC),
      bottomNavigationBar: SafeArea(bottom: true, child: nav()),
    );
  }

  Container nav() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 20,
              offset: Offset(1, 3), // changes position of shadow
            ),
          ],
          border: Border.all(color: Colors.black),
          color: const Color(0xFFEC7357),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 68,
            child: InkWell(
              onTap: () {
                setState(() {
                  Vibrate.feedback(FeedbackType.success);
                  _activeIndex = 0;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(
                    _activeIndex == 0
                        ? PhosphorIcons.fill.houseLine
                        : PhosphorIcons.regular.houseLine,
                    size: _activeIndex == 0 ? 25 : 20,
                    color: _activeIndex == 0 ? Colors.white : Colors.black54,
                    semanticLabel: 'Home',
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      color: _activeIndex == 0 ? Colors.white : Colors.black54,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 68,
            child: InkWell(
              onTap: () {
                setState(() {
                  Vibrate.feedback(FeedbackType.success);
                  _activeIndex = 1;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(
                      _activeIndex == 1
                          ? PhosphorIcons.fill.gridFour
                          : PhosphorIcons.regular.gridFour,
                      size: _activeIndex == 1 ? 25 : 20,
                      color: _activeIndex == 1 ? Colors.white : Colors.black54,
                      semanticLabel: 'Category'),
                  Text(
                    "Category",
                    style: TextStyle(
                      color: _activeIndex == 1 ? Colors.white : Colors.black54,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 68,
            child: InkWell(
              onTap: () {
                setState(() {
                  Vibrate.feedback(FeedbackType.success);
                  _activeIndex = 2;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(
                      _activeIndex == 2
                          ? PhosphorIcons.fill.heart
                          : PhosphorIcons.regular.heart,
                      size: _activeIndex == 2 ? 25 : 20,
                      color: _activeIndex == 2 ? Colors.white : Colors.black54,
                      semanticLabel: 'Favorities'),
                  Text(
                    "Favs",
                    style: TextStyle(
                      color: _activeIndex == 2 ? Colors.white : Colors.black54,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
