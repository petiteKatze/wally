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
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.25, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: widget.activeIndex == 0
            ? const Color(0xFFA040B0)
            : widget.activeIndex == 1
                ? const Color(0xFFAC5A37)
                : widget.activeIndex == 2
                    ? const Color(0xFFAC3753)
                    : const Color(0xFFF7C351),
        borderRadius: BorderRadius.circular(50),
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
              child: PhosphorIcon(
                widget.activeIndex == 0
                    ? PhosphorIcons.fill.houseLine
                    : PhosphorIcons.regular.houseLine,
                size: widget.activeIndex == 0 ? 25 : 20,
                color: widget.activeIndex == 0 ? Colors.white : Colors.black54,
                semanticLabel: 'Home',
              ),
            ),
          ),
          SizedBox(
            height: 68,
            child: InkWell(
              onTap: () {
                widget.onIndexChanged(1); // Call the callback function
              },
              child: PhosphorIcon(
                widget.activeIndex == 1
                    ? PhosphorIcons.fill.gridFour
                    : PhosphorIcons.regular.gridFour,
                size: widget.activeIndex == 1 ? 25 : 20,
                color: widget.activeIndex == 1 ? Colors.white : Colors.black54,
                semanticLabel: 'Category',
              ),
            ),
          ),
          SizedBox(
            height: 68,
            child: InkWell(
              onTap: () {
                widget.onIndexChanged(2); // Call the callback function
              },
              child: PhosphorIcon(
                widget.activeIndex == 2
                    ? PhosphorIcons.fill.heart
                    : PhosphorIcons.regular.heart,
                size: widget.activeIndex == 2 ? 25 : 20,
                color: widget.activeIndex == 2 ? Colors.white : Colors.black54,
                semanticLabel: 'Favorites',
              ),
            ),
          ),
          SizedBox(
            height: 68,
            child: InkWell(
              onTap: () {
                widget.onIndexChanged(3); // Call the callback function
              },
              child: PhosphorIcon(
                widget.activeIndex == 3
                    ? PhosphorIcons.fill.gear
                    : PhosphorIcons.regular.gear,
                size: widget.activeIndex == 3 ? 25 : 20,
                color: widget.activeIndex == 3 ? Colors.white : Colors.black54,
                semanticLabel: 'Favorites',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
