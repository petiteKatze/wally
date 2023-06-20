import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Nav extends StatefulWidget {
  final Function(int) onIndexChanged; // New callback function
  final int activeIndex;

  const Nav({
    Key? key,
    required this.onIndexChanged,
    required this.activeIndex,
  }) : super(key: key);

  @override
  NavState createState() => NavState();
}

class NavState extends State<Nav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(1, 3), // changes position of shadow
          ),
        ],
        border: Border.all(color: Colors.black),
        color: const Color(0xFFEC7357),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 68,
            child: InkWell(
              onTap: () {
                widget.onIndexChanged(0); // Call the callback function
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(
                    widget.activeIndex == 0
                        ? PhosphorIcons.fill.houseLine
                        : PhosphorIcons.regular.houseLine,
                    size: widget.activeIndex == 0 ? 25 : 20,
                    color:
                        widget.activeIndex == 0 ? Colors.white : Colors.black54,
                    semanticLabel: 'Home',
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      color: widget.activeIndex == 0
                          ? Colors.white
                          : Colors.black54,
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
                widget.onIndexChanged(1); // Call the callback function
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(
                    widget.activeIndex == 1
                        ? PhosphorIcons.fill.gridFour
                        : PhosphorIcons.regular.gridFour,
                    size: widget.activeIndex == 1 ? 25 : 20,
                    color:
                        widget.activeIndex == 1 ? Colors.white : Colors.black54,
                    semanticLabel: 'Category',
                  ),
                  Text(
                    "Category",
                    style: TextStyle(
                      color: widget.activeIndex == 1
                          ? Colors.white
                          : Colors.black54,
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
                widget.onIndexChanged(2); // Call the callback function
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(
                    widget.activeIndex == 2
                        ? PhosphorIcons.fill.heart
                        : PhosphorIcons.regular.heart,
                    size: widget.activeIndex == 2 ? 25 : 20,
                    color:
                        widget.activeIndex == 2 ? Colors.white : Colors.black54,
                    semanticLabel: 'Favorites',
                  ),
                  Text(
                    "Favs",
                    style: TextStyle(
                      color: widget.activeIndex == 2
                          ? Colors.white
                          : Colors.black54,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
