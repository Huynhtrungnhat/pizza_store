import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pizza_store/models/sanphammodel.dart';
import 'package:pizza_store/screen/trangTTThanhCong.dart';
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
      final response = await http.get(Uri.parse('${AppConstants.User_id}/$userId'));

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

  double discount = 0.0;

  double getTotalAfterDiscount() {
    double totalPrice = cart.getTotalPrice();
    double discountAmount = totalPrice * (discount / 100);
    return totalPrice - discountAmount;
  }

  TextEditingController mkmController = TextEditingController();



  @override
  void initState() {
    super.initState();
    fetchUserData();
  }
  @override
  Widget build(BuildContext context) {
        final numberFormat = NumberFormat("#,##0.000", "vi_VN");
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết Thanh toán"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Địa chỉ nhận hàng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(height:2),
              Text(
                'Tên: ${userData?['name'] ?? 'N/A'}',
              ),
              Text(
                'id: ${userData?['id'] ?? 'N/A'} ' ,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    var item = cart.items[index];
                    return SingleChildScrollView(
                      child: ListTile(
                      title: Text(item.ten_san_pham,maxLines: 2,
                            overflow: TextOverflow.ellipsis,),

                      subtitle: Text('VND ${numberFormat.format(item.gia)}',),
                      leading: Image.network(
                        '${AppConstants.BASE_URL}${item.hinh_anh}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(' X ${item.so_luong_ton_kho}'),
                          ],
                        ),
                      )
                    );
                  },
                ),
              ),
          
              Text(
                  'Mã khuyến mãi',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
               Container(
                  width: 350, 
                  child: TextFormField(
                    controller: mkmController,
                    decoration: InputDecoration(
                      labelText: 'Nhập mã khuyến mãi',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), 
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('Áp dụng mã'),
                ),
          
            ],
          ),
      ),

      bottomNavigationBar: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: double.infinity, 
        height: 45, 
        child: ElevatedButton(
          onPressed: () {
            final tongTien = getTotalAfterDiscount().toStringAsFixed(2);
            final maKh = userData?['id'];
            final maNV = userData?['id'];
            addHoaDon(tongTien, maKh!, maNV!); 
           cart.clear(); 
            Navigator.pop(context); 
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ThanhToanThanhCong(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 12), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Thanh Toán ${numberFormat.format(cart.getTotalPrice())}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), 
          ),
        ),
      ),
    ],
  ),
),
    );
  }
}
