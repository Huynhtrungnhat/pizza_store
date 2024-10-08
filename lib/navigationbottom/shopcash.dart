import 'package:flutter/material.dart';

class shophistory extends StatelessWidget {
  const shophistory({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 233, 22),
      appBar: AppBar(
        title: const Text("Lịch sử mua hàng"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Shop history",
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
