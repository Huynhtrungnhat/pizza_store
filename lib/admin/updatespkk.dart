// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pizza_store/api/controller.dart';
// import 'package:pizza_store/models/hoadonModel.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HoaDonDetailPage extends StatefulWidget {
//   final HoaDon order;
//   final Function(String) onUpdateStatus;

//   HoaDonDetailPage({
//     required this.order,
//     required this.onUpdateStatus,
//   });

//   @override
//   _HoaDonDetailPageState createState() => _HoaDonDetailPageState();
// }

// class _HoaDonDetailPageState extends State<HoaDonDetailPage> {

//   final List<String> _statusList = [
//     'Chờ xác nhận',
//     'Đang vận chuyển',
//     'Hoàn thành',
//     'Đã hủy',
//   ];
//   var customerId; 
//   String? userId;

//   late String _selectedStatus;

//  @override
// void initState() {
//   super.initState();
//   _selectedStatus = _statusList.contains(widget.order.trang_thai)
//       ? widget.order.trang_thai
//       : _statusList.first;
// }

//   Future<void> _updateStatusOnApihuymuahang(String newStatus) async {
//     final url = Uri.parse('${AppConstants.hoadon}/${widget.order.ma_hoa_don}');

//     try {
//       final requestBody = jsonEncode({
//         'ma_hoa_don': widget.order.ma_hoa_don,
//         'trang_thai': newStatus,
//       });

//       final response = await http.put(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: requestBody,
//       );

//       if (response.statusCode == 200 || response.statusCode == 204) {
//         setState(() {
//           widget.order.trang_thai = newStatus;
//         });
//         widget.onUpdateStatus(newStatus);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Trạng thái đơn hàng đã được cập nhật $userId.')),
//         );
//         Navigator.pop(context, true);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Cập nhật trạng thái thất bại!')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Có lỗi xảy ra khi cập nhật trạng thái. Chi tiết lỗi: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chi tiết Đơn hàng'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Mã đơn hàng: ${widget.order.ma_hoa_don}', style: TextStyle(fontSize: 18)),
//               SizedBox(height: 10),
//               Text('Tổng tiền: ${widget.order.tong_tien.toStringAsFixed(2)} đ', style: TextStyle(fontSize: 18)),
//               SizedBox(height: 10),
//               Text('Trạng thái:', style: TextStyle(fontSize: 18)),
//               SizedBox(height: 5),
//               DropdownButton<String>(
//                 value: _selectedStatus,
//                 onChanged: (String? newValue) {
//                   if (newValue != null) {
//                     setState(() {
//                       _selectedStatus = newValue;
//                     });
//                   }
//                 },
//                 items: _statusList.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () => _updateStatusOnApi(_selectedStatus),
//                 child: Text('Cập nhật trạng thái'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }