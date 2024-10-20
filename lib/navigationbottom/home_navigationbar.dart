import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:pizza_store/navigationbottom/donhang_page.dart';
import 'package:pizza_store/home/home_page.dart';
import 'package:pizza_store/navigationbottom/profile_page.dart';
import 'package:pizza_store/navigationbottom/shopcash.dart';

import '../home/sanpham.dart';

class CurveBar extends StatefulWidget {
  const CurveBar({super.key});

  @override
  State<CurveBar> createState() => _CurveBarState();
}

class _CurveBarState extends State<CurveBar> {
  int index = 0;
  final screen = const [
  detailsanpham(),
   SearchPage(),
   ProfilePage(),
   shophistory(),
   
  ];

  @override
  Widget build(BuildContext context) {
    final items = [
      const Icon(Icons.home, size: 30),
      const Icon(Icons.search, size: 30),
      const Icon(Icons.person, size: 30),
      const Icon(Icons.shopping_cart_rounded, size: 30),
    ];
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 200, 233, 239),
      extendBody: true,
      body: screen[index],
      // Center(
      //   child: Text(
      //     '$index',
      //     style: const TextStyle(
      //         fontSize: 110, fontWeight: FontWeight.bold, color: Colors.white),
      //   ),
      // ),
      bottomNavigationBar: Theme(
        // this them is for to change icon colors.
        data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(
          color: Colors.white,
        )),
        child: CurvedNavigationBar(
          // navigationBar colors
          color: Color.fromARGB(255, 16, 127, 144),
          //selected times colors
          buttonBackgroundColor: Color.fromARGB(255, 55, 14, 6),
          backgroundColor: Colors.transparent,
          items: items,
          height: 60,
          index: index,
          onTap: (index) => setState(
            () => this.index = index,
          ),
        ),
      ),
    );
  }
}
