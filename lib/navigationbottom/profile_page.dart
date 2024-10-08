import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 233, 22),
      appBar: AppBar(
        title: const Text("Trang cá nhân"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Profile",
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
