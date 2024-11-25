// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:pizza_store/api/controller.dart';

// class ProductApi {

  
//   static Future<bool> updateProduct(Map<String, dynamic> updatedProduct, int productId) async {
//     final url = Uri.parse('${AppConstants.ALL_PRODUCT_URI}/$productId'); 

//     try {
//       final response = await http.put(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(updatedProduct), 
//       );

//       if (response.statusCode == 200) {
//         return true;
//       } else {
       
//         print('Error: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('Error: $e');
//       return false;
//     }
//   }
// }
