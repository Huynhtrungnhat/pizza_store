// import 'package:flutter/material.dart';
// import 'package:pizza_store/api/controller.dart';
// import 'package:pizza_store/models/sanphamcart.dart';

// class CartPage extends StatefulWidget {
//   @override
//   _CartPageState createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   double discount = 0.0; // Phần trăm giảm giá

//   // Tính tổng cộng sau khi áp dụng giảm giá
//   double getTotalAfterDiscount() {
//     double totalPrice = cart.getTotalPrice();
//     double discountAmount = totalPrice * (discount / 100);
//     return totalPrice - discountAmount;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Giỏ hàng"),
//       ),
//       body: cart.items.isEmpty
//           ? Center(child: Text('Giỏ hàng trống'))
//           : ListView.builder(
//               itemCount: cart.items.length,
//               itemBuilder: (context, index) {
//                 var item = cart.items[index];
//                 return ListTile(
//                   title: Text(item.ten_san_pham),
//                   subtitle: Text('Giá: ${item.gia} VND x ${item.so_luong_ton_kho}'),
//                   leading: Image.network(
//                     '${AppConstants.BASE_URL}${item.hinh_anh}',
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.remove),
//                         onPressed: () {
//                           setState(() {
//                             cart.updateQuantity(item, item.so_luong_ton_kho - 1);
//                           });
//                         },
//                       ),
//                       Text('${item.so_luong_ton_kho}'),
//                       IconButton(
//                         icon: Icon(Icons.add),
//                         onPressed: () {
//                           setState(() {
//                             cart.updateQuantity(item, item.so_luong_ton_kho + 1);
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(height: 10),
//             Text(
//               'Tổng cộng: ${cart.getTotalPrice().toStringAsFixed(2)} VND',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 5),
//             Text(
//               'Sau khuyến mãi: ${getTotalAfterDiscount().toStringAsFixed(2)} VND',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 // Thực hiện hành động thanh toán tại đây
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Thanh toán thành công! Tổng tiền: ${getTotalAfterDiscount().toStringAsFixed(2)} VND')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green, // Màu xanh lá cây
//                 padding: EdgeInsets.symmetric(vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 'Thanh Toán',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

