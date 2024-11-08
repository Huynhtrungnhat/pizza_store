import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/controller.dart';
import '../models/sanphamcart.dart';

class TrangThanhToan extends StatefulWidget {
  const TrangThanhToan({super.key});

  @override
  State<TrangThanhToan> createState() => _TrangThanhToanState();
}

class _TrangThanhToanState extends State<TrangThanhToan> {

   Future<void> addHoaDon(String tong_tien, int ma_khach_hang, int ma_nhan_vien) async {
    final url = Uri.parse('${AppConstants.BASE_URL}/hoadon');
    final response = await http.post(
      url, 
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tong_tien': tong_tien,
        'ma_khach_hang': ma_khach_hang,
        'ma_nhan_vien': ma_nhan_vien
      }),
    );
  }

  Map<String, dynamic>? userData;
  String? errorMessage;
  bool isLoading = true;
  String? userId;

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    if (userId != null) {
      final response = await http.get(Uri.parse('http://192.168.1.56:8000/api/user/$userId'));

      if (response.statusCode == 201) {
        setState(() {
          userData = json.decode(response.body)['user'];
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = 'Không thể tải thông tin người dùng. Mã trạng thái: ${response.statusCode}';
        });
      }
    } else {
      setState(() {
        errorMessage = 'ID người dùng không tìm thấy!';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }


  double discount = 0.0;

  double getTotalAfterDiscount() {
    double totalPrice = cart.getTotalPrice();
    double discountAmount = totalPrice * (discount / 100);
    return totalPrice - discountAmount;
  }

  TextEditingController mkmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng"),
      ),
      body: Column(
          children: [
        
            Text(
              'Địa chỉ nhận hàng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Tên: ${userData?['name'] ?? 'N/A'}',
            ),

            Text(
              'id: ${userData?['id'] ?? 'N/A'} ',
            ),
        
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  var item = cart.items[index];
                  return SingleChildScrollView(
                    child: ListTile(
                    title: Text(item.ten_san_pham),
                    subtitle: Text('Giá: ${item.gia} VND x ${item.so_luong_ton_kho}'),
                    leading: Image.network(
                      '${AppConstants.BASE_URL}${item.hinh_anh}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${item.so_luong_ton_kho}'),
                        ],
                      ),
                    )
                  );
                },
              ),
            ),
        
            Text(
                'Mã khuyến mãi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: mkmController,
                decoration: InputDecoration(
                  labelText: 'Nhập mã khuyến mãi',
                  border: OutlineInputBorder(),
                ),
              ),
              
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  String promoCode = mkmController.text;
                },
                child: Text('Áp dụng mã'),
              ),
        
          ],
        ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            ElevatedButton(
              onPressed: () {

                final tongTien = getTotalAfterDiscount().toStringAsFixed(2);
                final maKh = userData?['id'];
                final maNV = userData?['id'];
                addHoaDon(tongTien, maKh, maNV);

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Thanh Toán',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}