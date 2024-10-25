import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/modeladdsanpham.dart';
import 'package:pizza_store/screen/productadd.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController motaController = TextEditingController();
  final TextEditingController giaController = TextEditingController();
  final TextEditingController soluongtonkhoController = TextEditingController();
  

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
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: giaController,
                decoration: InputDecoration(labelText: 'Mô tả'),
              ),
              TextField(
                controller: motaController,
                decoration: InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: soluongtonkhoController,
                decoration: InputDecoration(labelText: 'Số lượng tồn kho'),
                keyboardType: TextInputType.number,
              ),
              
              SizedBox(height: 16),
               ElevatedButton(
                onPressed: (){
                  Myaddproduct().Addproducrtdata(nameController.text.toString(), motaController.text.toString(), giaController.text.toString(), soluongtonkhoController.text.toString());
                },
                child: Text('Thêm sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
