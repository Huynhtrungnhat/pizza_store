import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  String? _categoryId;
  String? _subCategoryId;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không có ảnh nào được chọn')),
        );
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi chọn ảnh')),
      );
    }
  }

  Future<void> _addProduct() async {
    String apiUrl = AppConstants.ALL_PRODUCT_URI;

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['ten_san_pham'] = _productNameController.text;
    request.fields['mo_ta'] = _descriptionController.text;
    request.fields['gia'] = _priceController.text;
    request.fields['so_luong_ton_kho'] = _stockController.text;
    request.fields['ma_loai_san_pham'] = _categoryId ?? '';
    request.fields['ma_loai'] = _subCategoryId ?? '';

    if (_selectedImage != null) {
      try {
        request.files.add(
          await http.MultipartFile.fromPath('hinh_anh', _selectedImage!.path),
        );
      } catch (e) {
        print("Error adding image to request: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra khi thêm ảnh')),
        );
        return;
      }
    }

    try {
      final response = await request.send();
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm sản phẩm thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm sản phẩm thất bại')),
        );
      }
    } catch (e) {
      print("Error adding product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi thêm sản phẩm')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Sản Phẩm"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _selectedImage != null && _selectedImage!.existsSync()
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(child: Text('Không thể hiển thị ảnh'));
                          },
                        )
                      : Center(child: Text('Chọn ảnh')),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Số lượng tồn kho'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: _categoryId,
                hint: Text('Chọn mã loại sản phẩm'),
                onChanged: (String? newValue) {
                  setState(() {
                    _categoryId = newValue;
                  });
                },
                items: <String>['1', '2', '3']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: _subCategoryId,
                hint: Text('Chọn mã loại'),
                onChanged: (String? newValue) {
                  setState(() {
                    _subCategoryId = newValue;
                  });
                },
                items: <String>['1', '2', '3']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addProduct,
                child: Text('Thêm sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
