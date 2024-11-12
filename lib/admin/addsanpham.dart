import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';

class ProductInputPage extends StatefulWidget {
  @override
  _ProductInputPageState createState() => _ProductInputPageState();
}

class _ProductInputPageState extends State<ProductInputPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockQuantityController =TextEditingController();
  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _promotionValueController =TextEditingController();

  File? _selectedImage;
  String? _selectedPromotionType;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<String> _convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<void> ThemSanPham( String ten_san_pham,String mota,int gia,int so_luong_ton_kho,int ma_loai_san_pham,int ma_loai,String loai_khuyen_mai,int gia_tri_khuyen_mai,String Hinhanh) async {
    final url = Uri.parse('${AppConstants.ALL_PRODUCT_URI}');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          
          'ten_san_pham': ten_san_pham,
          'mo_ta': mota,
          'gia': gia,
          'so_luong_ton_kho': so_luong_ton_kho,
          'ma_loai_san_pham': ma_loai_san_pham,
          'ma_loai': ma_loai,
          'loai_khuyen_mai': loai_khuyen_mai,
          'gia_tri_khuyen_mai': gia_tri_khuyen_mai,
          'hinh_anh': Hinhanh,
        }),
      );

      if (response.statusCode == 201) {
        print('Sản phẩm đã được thêm thành công');
        print('Response body: ${response.body}');
      } else {
          print('Lỗi khi thêm sản phẩm. Mã lỗi: ${response.statusCode}');
          print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Lỗi khi thực hiện yêu cầu: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập thông tin sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : Center(
                        child: Text('Chưa chọn hình ảnh'),
                      ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Chọn hình ảnh'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Tên sản phẩm',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Giá',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _stockQuantityController,
                decoration: InputDecoration(
                  labelText: 'Số lượng tồn kho',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _categoryIdController,
                decoration: InputDecoration(
                  labelText: 'Mã loại sản phẩm',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              // DropdownMenu cho loại khuyến mãi
              DropdownButtonFormField<String>(
                value: _selectedPromotionType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPromotionType = newValue;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'PHANTRAM',
                    child: Text('Phần Trăm'),
                  ),
                  DropdownMenuItem(
                    value: 'GIATRI',
                    child: Text('Giá Trị '),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Loại khuyến mãi',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _promotionValueController,
                decoration: InputDecoration(
                  labelText: 'Giá trị khuyến mãi',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final productName = _productNameController.text;
                  final description = _descriptionController.text;
                  final price = int.parse(_priceController.text);
                  final stockQuantity = int.parse(_stockQuantityController.text);
                  final categoryId = int.parse(_categoryIdController.text);
                  final promotionType = _selectedPromotionType ?? '';
                  final promotionValue = int.parse(_promotionValueController.text);
                  String? base64Image = '';
                  if (_selectedImage != null) {
                    base64Image = 'data:image/jpeg;base64,' + await _convertImageToBase64(_selectedImage!);
                  }

                  ThemSanPham(productName,description, price,stockQuantity, categoryId,1,promotionType,
 promotionValue, base64Image);
                  // print('Tên sản phẩm: $productName');
                  // print('Mô tả: $description');
                  // print('Giá: $price');
                  // print('Số lượng tồn kho: $stockQuantity');
                  // print('Mã loại sản phẩm: $categoryId');
                  // print('Loại khuyến mãi: $promotionType');
                  // print('Giá trị khuyến mãi: $promotionValue');
                  // print('Giá trị khuyến mãi: $base64Image');
                  if (_selectedImage != null) {
                    print('Hình ảnh đã chọn: ${_selectedImage!.path}');
                    // print('Base64 Hình ảnh: $base64Image');
                  } else {
                    print('Chưa chọn hình ảnh');
                  }
                },
                child: Text('Lưu sản phẩm'),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
