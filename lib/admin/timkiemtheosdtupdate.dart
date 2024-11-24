import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';

class CustomerManagementPage extends StatefulWidget {
  @override
  _CustomerManagementPageState createState() => _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
 // final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String customerDetails = "";
  bool isCustomerFound = false;
  var customerId; 

  final String apiUrl = '${AppConstants.khachhang}/sdt';


  Future<void> updateCustomer(int customerId) async {
    var response = await http.put(
      Uri.parse('${AppConstants.khachhang}/$customerId'),
      body: json.encode({
        'ten_khach_hang': nameController.text,
        'sdt': phoneController.text,
        'diachi': addressController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thông tin khách hàng thành công')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi khi cập nhật thông tin')));
    }
  }

  // Tìm kiếm khách hàng theo số điện thoại
  Future<void> searchCustomerByPhone() async {
    var response = await http.get(Uri.parse('$apiUrl/${searchController.text}'));
    print('Response body: ${response.body}');

    if (response.statusCode == 201) { // Kiểm tra mã trạng thái 200 (thành công)
      var data = json.decode(response.body);

      if (data['khachhang'] != null) {
        var customer = data['khachhang'];

        setState(() {
          nameController.text = customer['ten_khach_hang'] ?? '';
          phoneController.text = customer['sdt'] ?? '';
       //   emailController.text = ''; // Giả sử bạn không nhận email từ API
          addressController.text = customer['diachi'] ?? '';
          customerId = customer['ma_khach_hang']; // Lưu lại mã khách hàng
          customerDetails = 'Thông tin khách hàng đã được tìm thấy';
          isCustomerFound = true;
        });
      } else {
        setState(() {
          customerDetails = 'Không tìm thấy khách hàng';
          isCustomerFound = false;
        });
      }
    } else {
      setState(() {
        customerDetails = 'Không tìm thấy khách hàng';
        isCustomerFound = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quản lý khách hàng")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tìm kiếm khách hàng theo số điện thoại
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Nhập số điện thoại để tìm kiếm',
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: searchCustomerByPhone,
                child: Text('Tìm kiếm'),
              ),
              SizedBox(height: 20),
      
              if (!isCustomerFound) 
                Text(customerDetails, style: TextStyle(color: Colors.red)),
              if (isCustomerFound) ...[
               
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thông tin khách hàng:', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Tên khách hàng',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  
                    SizedBox(height: 10),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Địa chỉ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal, 
                      child: Row(
                        children: [
                           ElevatedButton(
                        onPressed: () async {
                          if (customerId != null) {
                            updateCustomer(customerId); 
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Không tìm thấy mã khách hàng')));
                          }
                        },
                        child: Text('Cập nhật thông\ntin Khách hàng'),
                      ),
                      SizedBox(width: 10),
                       ElevatedButton(
                        onPressed: () async {
                          if (customerId != null) {
                            updateCustomer(customerId); 
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Không tìm thấy mã khách hàng')));
                          }
                        },
                        child: Text('Xem Đơn Hàng',style: TextStyle(color: Colors.orange,),),
                        ) ,
                        ],
                      ),
                    ),
                   
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
