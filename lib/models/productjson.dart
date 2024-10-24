// import 'dart:convert'; // Để sử dụng jsonDecode
// import 'package:http/http.dart' as http;
// import '../models/sanphammodel.dart'; // Đảm bảo import lớp Product
// import '../models/sanphamcart.dart'; // Import lớp Cart

// class ApiService {
//   Future<List<Product>> fetchProducts() async {
//     final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/sanpham'));

//     if (response.statusCode == 200) {
//       List<dynamic> jsonList = jsonDecode(response.body); // Phân tích dữ liệu JSON
//       List<Product> products = jsonList.map((json) => Product.fromJson(json)).toList(); // Chuyển đổi JSON sang Product
//       return products;
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }
// }
