// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/sanphamcart.dart';
// import '../api/controller.dart';

// class TrangThanhToangiamgia extends StatefulWidget {
//   const TrangThanhToangiamgia({super.key});

//   @override
//   State<TrangThanhToangiamgia> createState() => _TrangThanhToangiamgiaState();
// }

// class _TrangThanhToangiamgiaState extends State<TrangThanhToangiamgia> {
//   double discount = 0.0;
//   String promoMessage = '';
//   TextEditingController mkmController = TextEditingController();

//   // Hàm tính tổng sau khi áp dụng giảm giá
//   double getTotalAfterDiscount() {
//     double totalPrice = cart.getTotalPrice();
//     return totalPrice - discount;
//   }

//   // Hàm kiểm tra mã khuyến mãi
//   Future<void> kiemTraMaKhuyenMai(String maKhuyenMai) async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://192.168.1.20:8000/api/khuyen_mai/danh-sach-khuyen-mai/hoa-don'),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final apDungTuNgay = data['ap_dung_tu_ngay']; // Chuỗi ngày từ API
//         final apDungDenNgay = data['ap_dung_den_ngay']; // Chuỗi ngày từ API
//         final giamGia = data['giam_gia']; // Số tiền giảm giá

//         final now = DateTime.now();
//         final dateFormat = DateFormat("yyyy-MM-dd");

//         DateTime? tuNgay =
//             apDungTuNgay != null ? dateFormat.parse(apDungTuNgay) : null;
//         DateTime? denNgay =
//             apDungDenNgay != null ? dateFormat.parse(apDungDenNgay) : null;

//         // Kiểm tra ngày hợp lệ
//         if ((tuNgay == null || now.isAfter(tuNgay)) &&
//             (denNgay == null || now.isBefore(denNgay))) {
//           setState(() {
//             discount = giamGia.toDouble();
//             promoMessage =
//                 'Áp dụng mã thành công! Giảm ${NumberFormat("#,##0").format(discount)} VND';
//           });
//         } else {
//           setState(() {
//             discount = 0.0;
//             promoMessage = 'Mã khuyến mãi đã hết hạn!';
//           });
//         }
//       } else {
//         setState(() {
//           discount = 0.0;
//           promoMessage = 'Mã khuyến mãi không hợp lệ!';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         discount = 0.0;
//         promoMessage = 'Có lỗi xảy ra, vui lòng thử lại!';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final numberFormat = NumberFormat("#,##0.000", "vi_VN");

//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           children: [
//             Text(
//               "Tổng quan đơn hàng",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   FontAwesomeIcons.shieldHalved,
//                   color: Colors.green,
//                   size: 14,
//                 ),
//                 SizedBox(width: 5),
//                 Text(
//                   "Thông tin của bạn sẽ được bảo mật ",
//                   style: TextStyle(fontSize: 12, color: Colors.green),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Nhập mã khuyến mãi
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: mkmController,
//                       decoration: InputDecoration(
//                         hintText: 'Nhập mã khuyến mãi',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       kiemTraMaKhuyenMai(mkmController.text.trim());
//                     },
//                     child: Text('Áp dụng'),
//                   ),
//                 ],
//               ),
//             ),
//             // Thông báo kết quả kiểm tra mã khuyến mãi
//             Text(
//               promoMessage,
//               style: TextStyle(
//                 color: promoMessage.contains('thành công')
//                     ? Colors.green
//                     : Colors.red,
//               ),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cart.items.length,
//                 itemBuilder: (context, index) {
//                   var item = cart.items[index];
//                   return ListTile(
//                     title: Text(
//                       item.ten_san_pham,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     subtitle: Text(
//                       'VND ${numberFormat.format(item.gia)}',
//                     ),
//                     leading: Image.network(
//                       '${AppConstants.BASE_URL}${item.hinh_anh}',
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                     ),
//                     trailing: Text('X ${item.so_luong_ton_kho}'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ElevatedButton(
//           onPressed: () {
//             final tongTien = getTotalAfterDiscount().toStringAsFixed(2);
//             // Xử lý logic thanh toán tại đây
//           },
//           child: Text(
//             'Thanh Toán ${numberFormat.format(getTotalAfterDiscount())} VND',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }
// }
