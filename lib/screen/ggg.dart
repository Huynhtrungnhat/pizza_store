// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class AddProductPage extends StatefulWidget {
//   @override
//   _AddProductPageState createState() => _AddProductPageState();
// }

// class _AddProductPageState extends State<AddProductPage> {
//   final TextEditingController _productNameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _stockController = TextEditingController();
//   String? _categoryId;
//   String? _subCategoryId;

//   XFile? _imageFile;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage() async {
//     try {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       setState(() {
//         _imageFile = pickedFile;
//       });
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }

//   Future<void> _addProduct() async {
//     if (_imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Vui lòng chọn hình ảnh')),
//       );
//       return;
//     }

//     String apiUrl = 'http://your_api_url_here/products'; // Thay đổi URL API của bạn

//     var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//     request.fields['ten_san_pham'] = _productNameController.text;
//     request.fields['mo_ta'] = _descriptionController.text;
//     request.fields['gia'] = _priceController.text;
//     request.fields['so_luong_ton_kho'] = _stockController.text;
//     request.fields['ma_loai_san_pham'] = _categoryId ?? '';
//     request.fields['ma_loai'] = _subCategoryId ?? '';

//     // Thêm hình ảnh vào request
//     if (_imageFile != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath('hinh_anh', _imageFile!.path),
//       );
//     }

//     try {
//       final response = await request.send();
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Thêm sản phẩm thành công')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Thêm sản phẩm thất bại')),
//         );
//       }
//     } catch (e) {
//       print("Error adding product: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Có lỗi xảy ra')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Thêm Sản Phẩm"),
//       ),
//       body: SingleChildScrollView( // Đảm bảo SingleChildScrollView bao quanh toàn bộ nội dung
    
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Hiển thị hình ảnh đã chọn
//               Container(
//                 width: double.infinity,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 child: _imageFile == null
//                     ? Center(child: Text('Chưa chọn hình ảnh'))
//                     : ClipRect(
//                         child: Image.file(
//                           File(_imageFile!.path),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _pickImage,
//                 child: Text('Chọn hình ảnh'),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _productNameController,
//                 decoration: InputDecoration(labelText: 'Tên sản phẩm'),
//               ),
//               TextField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Mô tả'),
//               ),
//               TextField(
//                 controller: _priceController,
//                 decoration: InputDecoration(labelText: 'Giá'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: _stockController,
//                 decoration: InputDecoration(labelText: 'Số lượng tồn kho'),
//                 keyboardType: TextInputType.number,
//               ),
//               // ComboBox cho loại sản phẩm
//               DropdownButton<String>(
//                 value: _categoryId,
//                 hint: Text('Chọn mã loại sản phẩm'),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _categoryId = newValue;
//                   });
//                 },
//                 items: <String>['1', '2', '3 '] // Thay đổi với dữ liệu thực
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               DropdownButton<String>(
//                 value: _subCategoryId,
//                 hint: Text('Chọn mã loại'),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _subCategoryId = newValue;
//                   });
//                 },
//                 items: <String>['1 ', '2 ', '3'] // Thay đổi với dữ liệu thực
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _addProduct,
//                 child: Text('Thêm sản phẩm'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
