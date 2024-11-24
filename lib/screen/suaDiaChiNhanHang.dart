import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SuaDiaChi extends StatefulWidget {
  const SuaDiaChi({Key? key}) : super(key: key);

  @override
  State<SuaDiaChi> createState() => _SuaDiaChiState();
}

class _SuaDiaChiState extends State<SuaDiaChi> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserAddress();
  }

  Future<void> _loadUserAddress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      
      if (userId != null) {
        final response = await http.get(
          Uri.parse('${AppConstants.khachhang}/$userId'),
        );

        if (response.statusCode == 201) {
          final userData = json.decode(response.body)['khachhang'];
          setState(() {
            _nameController.text = userData['ten_khach_hang'] ?? '';
            _phoneController.text = userData['sdt'] ?? '';
            _addressController.text = userData['diachi'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error loading user address: $e');
    }
  }

  Future<void> _updateAddress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        final response = await http.put(
          Uri.parse('${AppConstants.khachhang}/$userId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'ten_khach_hang': _nameController.text,
            'sdt': _phoneController.text,
            'diachi': _addressController.text,
          }),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context, true);
        } else {
          throw Exception('Failed to update address');
        }
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to update address: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sửa địa chỉ nhận hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên người nhận',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Địa chỉ',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateAddress,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Cập nhật địa chỉ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
