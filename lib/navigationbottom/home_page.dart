import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 22, 233),
      appBar: AppBar(
        title: const Text("Trang chủ "),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Home",
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
