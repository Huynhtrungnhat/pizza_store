import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api/controller.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); 
  final _formKey = GlobalKey<FormState>();

  Future<void> addUser(String name, String email, String password) async {
    final url = Uri.parse('${AppConstants.BASE_URL}/register');
    final response = await http.post(
      url, 
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User added successfully!')),
      );
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear(); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add user.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chào Mừng bạn đến với Pizza DND'),
        backgroundColor: Colors.red, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 100,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 150,
                    backgroundImage: AssetImage("assets/images/pizzalogin.jpg"), // Đường dẫn hình ảnh
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Họ và Tên',
                  border: OutlineInputBorder(), 
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ và tên.';
                  }
                  return null; 
                },
              ),
              SizedBox(height: 16), 
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email.';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Vui lòng nhập địa chỉ email hợp lệ.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu.';
                  } else if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), 
              TextFormField(
                controller: _confirmPasswordController, 
                decoration: InputDecoration(
                  labelText: 'Xác Nhận Mật Khẩu',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu.';
                  } else if (value != _passwordController.text) {
                    return 'Mật khẩu và xác nhận mật khẩu không khớp.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text;
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    addUser(name, email, password);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Màu của nút
                  padding: EdgeInsets.symmetric(vertical: 15), // Kích thước nút
                ),
                child: Text('Tạo Tài khoản ', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
