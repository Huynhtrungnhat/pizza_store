import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNamePage extends StatefulWidget {
  final String currentName;
  final String email;

  EditNamePage({required this.currentName, required this.email});

  @override
  _EditNamePageState createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final TextEditingController _nameController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
  }

  Future<void> updateName() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      setState(() {
        errorMessage = "ID người dùng không tìm thấy!";
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('${AppConstants.User_all}/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': _nameController.text, 'email': widget.email}),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, _nameController.text);
      } else {
        setState(() {
          errorMessage = 'Không thể cập nhật thông tin. Mã trạng thái: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi kết nối: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa Thông Tin'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên mới',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                hintText: widget.email,
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: updateName,
                    child: Text('Cập nhật'),
                  ),
          ],
        ),
      ),
    );
  }
}
