import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/sanphamcart.dart';
import 'package:pizza_store/screen/suaDiaChiNhanHang.dart';
import 'package:pizza_store/screen/trangTTThanhCong.dart';
import 'package:pizza_store/screen/trangThanhToan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';


class TrangThanhToanKetHop extends StatefulWidget {
  @override
  _TrangThanhToanKetHopState createState() => _TrangThanhToanKetHopState();
}

class _TrangThanhToanKetHopState extends State<TrangThanhToanKetHop> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? userId;
  double discount = 0.0;
  String promoMessage = '';
  TextEditingController mkmController = TextEditingController();
  bool isProcessingPayment = false;
   String selectedPaymentMethod = 'COD'; 
  final List<String> paymentMethods = ['COD', 'VNPay'];
  int makmai=0;
  int soluong=0; 
  bool kiemtrakhuyenmai=false;

  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    if (userId != null) {
      final response = await http.get(Uri.parse('${AppConstants.khachhang}/$userId'));

      if (response.statusCode == 201) {
        setState(() {
          userData = json.decode(response.body)['khachhang'];
        });
      }
    }

    setState(() => isLoading = false);
  }
Future<void> checkPromoCode(String code) async {
  try {
    final response = await http.get(Uri.parse(
        '${AppConstants.BASE_URL}/khuyen_mai/danh-sach-khuyen-mai/hoa-don'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final promotions = data['data'] as List<dynamic>;

      final promo = promotions.firstWhere(
        (item) => item['ten_khuyen_mai'] == code && item['trang_thai'] == 1,
        orElse: () => null,
      );

      if (promo != null) {
        makmai=promo['ma_khuyen_mai'];
        String apDungTuNgay = promo['ap_dung_tu_ngay'];
        String apDungDenNgay = promo['ap_dung_den_ngay'];
        int giaTriKhuyenMai = promo['gia_tri_khuyen_mai'];
        soluong=promo['gia_tri_khuyen_mai'];

    
        if (giaTriKhuyenMai == 0) {
          setState(() {
            discount = 0.0;
            promoMessage = "Voucher đã hết hạn hoặc không còn giá trị!";
          });
          return;
        }

        DateTime startDate = DateTime.parse(apDungTuNgay);
        DateTime endDate = DateTime.parse(apDungDenNgay);
        DateTime currentDate = DateTime.now();

        if (currentDate.isAfter(startDate) && currentDate.isBefore(endDate)) {
          final discountMatch = RegExp(r'\d+').firstMatch(code);
          if (discountMatch != null) {
            final discountValue = int.parse(discountMatch.group(0)!);
              kiemtrakhuyenmai=true;
            setState(() {
              discount = discountValue.toDouble();
              
              promoMessage =
                  "Mã hợp lệ: Giảm ${discountValue}K. Tổng mới: ${NumberFormat("#,##0", "vi_VN").format(getTotalAfterDiscount())} VND";
            });
          } else {
            setState(() {
              discount = 0.0;
              promoMessage = "Mã khuyến mãi không hợp lệ!";
            });
          }
        } else {
          setState(() {
            discount = 0.0;
            promoMessage = "Mã khuyến mãi đã hết hạn hoặc chưa bắt đầu!";
          });
        }
      } else {
        setState(() {
          discount = 0.0;
          promoMessage = "Mã khuyến mãi không hợp lệ hoặc đã hết hạn!";
        });
      }
    } else {
      setState(() {
        promoMessage = "Lỗi khi lấy danh sách khuyến mãi!";
      });
    }
  } catch (e) {
    setState(() {
      promoMessage = "Có lỗi xảy raffff: $e";
    });
  }
}



  double getTotalAfterDiscount() {
    double totalPrice = cart.getTotalPrice();
    double discountAmount = discount; 
    return totalPrice - discountAmount;
  }
   Widget dashedDivider({
    double dashWidth = 5,
    double dashHeight = 2,
    List<Color> colors = const [Colors.grey, Colors.blue], 

    double indent = 20,
    double endIndent = 20,
    double spaceBetweenDashes = 3,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: indent),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double dashCount =
              (constraints.constrainWidth() - indent - endIndent) /
                  (dashWidth + spaceBetweenDashes);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount.floor(), (index) {
              return Container(
                width: dashWidth,
                height: dashHeight,
                color: colors[index % colors.length], 
              );
            }),
          );
        },
      ),
    );
  }

  Future<void> addHoaDon(String tong_tien, int ma_khach_hang,String today,int manv,String phuongthuctt,String trangthai) async {
    final url = Uri.parse('${AppConstants.hoadon}');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      
      body: jsonEncode({
        'tong_tien': tong_tien, 
        'ma_khach_hang': ma_khach_hang,
        "ngay_lap_hd":today,
        'ma_nhan_vien': manv,
        'pttt':phuongthuctt,
        'trang_Thai':trangthai,
        'san_pham': cart.items
        }),
    );

  }
   Future<void> updatePromoCode(int promoId) async {

        final int soluongmoi=soluong-1;
        final updateResponse = await http.put(
          Uri.parse('${AppConstants.BASE_URL}/khuyen_mai/$promoId'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'gia_tri_khuyen_mai': soluongmoi,
          }),
        );

        if (updateResponse.statusCode == 200) {
          setState(() {
            promoMessage = "Cập nhật khuyến mãi thành công!";
          });
        } else {
          setState(() {
            promoMessage = "Lỗi khi cập nhật khuyến mãi!";
          });
        }
    }
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thành Công'),
        content: Text('Bạn đã thanh toán thành công'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showFailureDialog(String errorCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thất Bại'),
        content: Text('Lỗi thanh toán: $errorCode'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0.000", "vi_VN");
    return Scaffold(
      appBar: AppBar(
        title:Column(
          children: [
            Text("Tổng quan đơn hàng",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
            Row(
               mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Icon(FontAwesomeIcons.shieldHalved,color: Colors.green,size: 14,),SizedBox(width: 5),
                   Text("Thông tin của bạn sẽ được bảo mật ",style: TextStyle(fontSize: 12,color: Colors.green, ),),
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dashedDivider(
              colors: [Colors.red, Colors.green], 
              dashWidth: 10,
              dashHeight: 3,
              indent: 1,
              endIndent: 1,
              spaceBetweenDashes: 7,
            ),
            Row(
              children: [
                Icon(Icons.add_location_alt_outlined),
                SizedBox(width: 10),
                Text(
                  'Địa chỉ nhận hàng',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: 100),
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blueAccent,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SuaDiaChi(),
                                  ),
                                );
                              },
                            ),
              ],
            ),
            SizedBox(height: 2),
            Text(
              'Tên người nhận: ${userData?['ten_khach_hang'] ?? 'N/A'}',
            ),
            Text(
              'Sđt: ${userData?['sdt'] ?? 'N/A'}',
            ),
            Text(
              'Địa Chỉ: ${userData?['diachi'] ?? 'N/A'} ',
            ),
            dashedDivider(
              colors: [Colors.red, Colors.green], 
              dashWidth: 10,
              dashHeight: 3,
              indent: 1,
              endIndent: 1,
              spaceBetweenDashes: 7,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  var item = cart.items[index];
                  return SingleChildScrollView(
                      child: ListTile(
                    title: Text(
                      item.ten_san_pham,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'VND ${numberFormat.format(item.gia)}',
                    ),
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
                  ));
                },
              ),
            ),
            Column(
              children: [
                Text(
              'Mã khuyến mãi',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            TextFormField(
              controller: mkmController,
              decoration: InputDecoration(
                labelText: 'Nhập mã khuyến mãi',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                checkPromoCode(mkmController.text.trim().toUpperCase());
              },
              child: Text('Áp dụng mã'),
            ),
            if (promoMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  promoMessage,
                  style: TextStyle(
                    color: promoMessage.contains("hợp lệ")
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
              'Chọn phương thức thanh toán:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            DropdownButton<String>(
              value: selectedPaymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPaymentMethod = newValue!;
                });
              },
              items: paymentMethods.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
              ],
            ),
            
            if (!isProcessingPayment)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                        if (selectedPaymentMethod == 'COD') {
                          final tongTien = getTotalAfterDiscount().toStringAsFixed(3);
                          var tien=tongTien*10;
                         final maKh = userData?['ma_khach_hang'];
                         final pttt=selectedPaymentMethod.toString();
                         final trangthai="Chờ xác nhận";
                       String today = '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}';
                  addHoaDon(tien, maKh!,today,10,pttt,trangthai);
                              if (kiemtrakhuyenmai) {
                updatePromoCode(makmai);
              }

                  cart.clear();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThanhToanThanhCong(),
                    ),
                  );
                      } else if (selectedPaymentMethod == 'VNPay') {
                         final tongTienthanhtoan = getTotalAfterDiscount().toInt().toDouble();
                         var tien=tongTienthanhtoan*1000;
                         final makh=userData?['ma_khach_hang'];
                          final pttt=selectedPaymentMethod.toString();
                             if (kiemtrakhuyenmai) {
                updatePromoCode(makmai);
              }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  MobilePaymentScreen(makh:makh ,pttt:pttt ,amount: tien,onPaymentFailure: ()=>{},onPaymentSuccess: ()=>{
                              },saveData: ()=>{
                                
                              },)
                            ),
                          );
                         
                      }
                    },
                    style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                    child: Text(
                  '                        Thanh Toán ${numberFormat.format(getTotalAfterDiscount())}                               ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                  ),
                ],
              ),
            if (isProcessingPayment)
              Expanded(
                child: WebViewWidget(controller: _webViewController),
              ),
          ],
        ),
      ),
     
    );
  }
}
