import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/nhanvienModel.dart';
import 'package:http/http.dart' as http;

class UserPermissionsScreen extends StatefulWidget {
  final NhanVien nhanVien;

  UserPermissionsScreen({required this.nhanVien});

  @override
  _UserPermissionsScreenState createState() => _UserPermissionsScreenState();
}

class _UserPermissionsScreenState extends State<UserPermissionsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedPermission;

  // Danh sách quyền
  final List<String> permissions = ['admin', 'user', 'nv'];

  Future<void> _loadUserAddress() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.User_id}/${widget.nhanVien.maNhanVien}'),
      );

      if (response.statusCode == 201) {
        final userData = json.decode(response.body)['user'];
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _phoneController.text = userData['email'] ?? '';
          _selectedPermission = userData['quyen'] ?? ''; // Giả sử 'quyen' là giá trị quyền
        });
      }
    } catch (e) {
      print('Error loading user address: $e');
    }
  }

  Future<void> _updateAddress() async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.userpermison}/${widget.nhanVien.maNhanVien}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'email': _phoneController.text,
          'quyen': _selectedPermission, // Sử dụng quyền đã chọn
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to update address');
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
  void initState() {
    super.initState();
    _loadUserAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân quyền cho tài khoản'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên tài khoản',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPermission,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPermission = newValue;
                });
              },
              items: permissions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Quyền',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateAddress,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Cập nhật quyền'),
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
    super.dispose();
  }
}
