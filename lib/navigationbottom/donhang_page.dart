import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromARGB(255, 22, 233, 222),
      appBar: AppBar(
        title: const Text("Đơn hàng của bạn"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Search",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 60,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
