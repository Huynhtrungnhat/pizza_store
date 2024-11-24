import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';

class nhanvienpermetion extends StatefulWidget {
  @override
  _nhanvienpermetionState createState() => _nhanvienpermetionState();
}

class _nhanvienpermetionState extends State<nhanvienpermetion> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String customerDetails = "";
  bool isCustomerFound = false;
  String? selectedRole;
  var customer;
  var customerId;

  final String apiUrl = '${AppConstants.User_all}';

  // Danh sách quyền
  final List<String> roles = ['admin', 'user', 'nv', ''];

  Future<void> searchCustomerByPhone() async {
    try {
      var response = await http.get(Uri.parse('$apiUrl/${searchController.text}'));

      if (response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data['user'] != null) {
          customer = data['user'];
          setState(() {
            nameController.text = customer['name'] ?? '';
            addressController.text = customer['email'] ?? '';
            customerId = customer['id'];
            selectedRole = customer['quyen'];
            isCustomerFound = true;

            // Kiểm tra quyền
            if (selectedRole != 'admin') {
              customerDetails = 'Tài khoản không có quyền admin. Không thể chỉnh sửa.';
              isCustomerFound = false;
            } else {
              customerDetails = 'Thông tin nhân viên đã được tìm thấy.';
            }
          });
        } else {
          setState(() {
            customerDetails = 'Không tìm thấy nhân viên.';
            isCustomerFound = false;
          });
        }
      } else {
        setState(() {
          customerDetails = 'Không tìm thấy nhân viên.';
          isCustomerFound = false;
        });
      }
    } catch (e) {
      setState(() {
        customerDetails = 'Có lỗi xảy ra khi tìm kiếm.';
        isCustomerFound = false;
      });
    }
  }

  Future<void> updateCustomer(int customerId) async {
    try {
      var response = await http.put(
        Uri.parse('${AppConstants.userpermison}/$customerId'),
        body: json.encode({
          'ten_nhan_vien': nameController.text,
          'quyen': selectedRole,
          'email': addressController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thông tin nhân viên thành công.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật thông tin.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quản lý Nhân viên phân quyền")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Nhập mã nhân viên để tìm kiếm',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: searchCustomerByPhone,
                child: Text('Tìm kiếm'),
              ),
              SizedBox(height: 20),
              Text(
                customerDetails,
                style: TextStyle(color: isCustomerFound ? Colors.green : Colors.red),
              ),
              if (isCustomerFound && selectedRole == 'admin') ...[
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên Nhân viên',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Quyền của nhân viên',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (customerId != null) {
                      updateCustomer(customerId!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Không tìm thấy mã nhân viên.')),
                      );
                    }
                  },
                  child: Text('Cập nhật thông tin Nhân viên'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
