import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/login/regisiter.dart';
import 'package:pizza_store/models/layidnguoidung.dart';
import 'package:pizza_store/navigationbottom/home_navigationbar.dart';
import 'package:pizza_store/screen/Trangcanhan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _message;
  bool _obscurePassword = true; 
  final _formKey = GlobalKey<FormState>(); 
  bool _isLoading = false; 



Future<void> login() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true; 
    });

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.Login}'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 202) {
        final responseData = jsonDecode(response.body);
       final String userId = responseData['user']['id'].toString(); 

        await AuthService.saveUserId(userId);
        await setLoginStatus(true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CurveBar()),
        );
      } else {
        setState(() {
          _message = 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin tài khoản.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Đã xảy ra lỗi: $e';
      });
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }
}

Future<void> setLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
     await prefs.setBool('isLoggedIn', isLoggedIn); // Lưu trạng thái đăng nhập
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 120,
                      backgroundImage: AssetImage("assets/images/pizzalogin.jpg"),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email.'; 
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Vui lòng nhập địa chỉ email hợp lệ.'; // Kiểm tra định dạng email
                    }
                    return null; 
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: Icon(Icons.lock, color: Colors.blue),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword; 
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu.';
                    } else if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự.'; 
                           }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: _isLoading ? null : login ,
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: _isLoading 
                        ? CircularProgressIndicator(color: Colors.white) 
                        : Text(
                          'Đăng nhập',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddUserScreen()), 
                    );
                  },
                  child: Text('Tạo tài khoản mới', style: TextStyle(color: Colors.amber)),
                ),
                if (_message != null) ...[
                  SizedBox(height: 20),
                  Text(_message!, style: TextStyle(color: Colors.red)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
