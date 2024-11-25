// import 'package:flutter/material.dart';

// import 'package:pizza_store/models/khuyenmaiModel.dart';
// import 'package:pizza_store/screen/fechdatakhhpadon.dart'; // Giả sử bạn đã tạo model KhuyenMai

// class KhuyenMaiListScreen extends StatefulWidget {
//   @override
//   _KhuyenMaiListScreenState createState() => _KhuyenMaiListScreenState();
// }

// class _KhuyenMaiListScreenState extends State<KhuyenMaiListScreen> {
//   late Future<List<KhuyenMai>> _futureKhuyenMai;

//   @override
//   void initState() {
//     super.initState();
//     _loadKhuyenMaiList();
//   }

//   void _loadKhuyenMaiList() {
//     _futureKhuyenMai =ApiService().fetchKhuyenmai() ; // Hàm này gọi API để lấy dữ liệu khuyến mãi
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Danh sách khuyến mãi'),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: FutureBuilder<List<KhuyenMai>>(
//         future: _futureKhuyenMai,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Lỗi: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Không có dữ liệu'));
//           }

//           final khuyenMaiList = snapshot.data!;

//           return ListView.builder(
//             padding: EdgeInsets.all(10),
//             itemCount: khuyenMaiList.length,
//             itemBuilder: (context, index) {
//               final khuyenMai = khuyenMaiList[index];

//               return GestureDetector(
//                 onTap: () async {
//                   // Điều hướng đến màn hình chi tiết khuyến mãi nếu cần
//                   // final updatedKhuyenMai = await Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => EditKhuyenMaiScreen(khuyenMai: khuyenMai),
//                   //   ),
//                   // );
//                 },
//                 child: Card(
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 30,
//                               backgroundColor: Colors.blue[100],
//                               child: Text(
//                                 khuyenMai.tenKhuyenMai[0].toUpperCase(),
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blueAccent,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 15),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   khuyenMai.tenKhuyenMai,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   'Mã khuyến mãi: ${khuyenMai.maKhuyenMai}',
//                                   style: TextStyle(color: Colors.grey[600]),
//                                 ),
//                               ],
//                             ),
//                             Spacer(),
//                           ],
//                         ),
//                         Divider(
//                             height: 20, thickness: 1, color: Colors.grey[300]),
//                         SizedBox(height: 5),
//                         Row(
//                           children: [
//                             Icon(Icons.calendar_today,
//                                 size: 18, color: Colors.grey),
//                             SizedBox(width: 5),
//                             Text(
//                                 'Áp dụng từ: ${khuyenMai.apDungTuNgay}',
//                                 style: TextStyle(fontSize: 16)),
//                           ],
//                         ),
//                         SizedBox(height: 5),
//                         Row(
//                           children: [
//                             Icon(Icons.calendar_today_outlined,
//                                 size: 18, color: Colors.grey),
//                             SizedBox(width: 5),
//                             Text(
//                                 'Áp dụng đến: ${khuyenMai.apDungDenNgay}',
//                                 style: TextStyle(fontSize: 16)),
//                           ],
//                         ),
//                         SizedBox(height: 5),
//                         Row(
//                           children: [
//                             Icon(Icons.description, size: 18, color: Colors.grey),
//                             SizedBox(width: 5),
//                             Text(
//                                 'Mô tả: ${khuyenMai.moTa ?? "Không có mô tả"}',
//                                 style: TextStyle(fontSize: 16)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
