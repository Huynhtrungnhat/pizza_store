import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/admin/adminlistscren.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/navigationbottom/home_navigationbar.dart';
import 'package:pizza_store/screen/tranggiohang.dart';

class ProductInputPage extends StatefulWidget {
  @override
  _ProductInputPageState createState() => _ProductInputPageState();
}

class _ProductInputPageState extends State<ProductInputPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(text: '0');
  final TextEditingController _promotionValueController = TextEditingController();

  File? _selectedImage;
  String? Chonkhuyenmai;
  String? _chonMALoai;
  String? sizepiza;
  int giasp=0;
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

  Future<void> ThemSanPham(
      String ten_san_pham,
      String mota,
      int gia,
      String ma_loai,
      String loai_khuyen_mai,
      int gia_tri_khuyen_mai,
      String Hinhanh) async {
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
          'size': "M",
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
        centerTitle: true,
        backgroundColor: Colors.green,
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
                child: Text('Chọn hình ảnh cần thêm'),
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
           
              SizedBox(height: 10),
              
              DropdownButtonFormField<String>(
                value: _chonMALoai,
                onChanged: (String? newValue) {
                  setState(() {
                    _chonMALoai = newValue;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: '1',
                    child: Text('Pizza'),
                  ),
                  DropdownMenuItem(
                    value: '2',
                    child: Text('Gà '),
                  ),
                  DropdownMenuItem(
                    value: '3',
                    child: Text('Mỳ Ý '),
                  ),
                  DropdownMenuItem(
                    value: '4',
                    child: Text('Thức uống '),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Loại sản Phẩm',
                  border: OutlineInputBorder(),
                ),
              ),
             
               SizedBox(height: 10),
              TextField(
                controller: _priceController,
                onChanged: (value) {
                  setState(() {
                    if(_priceController.text.isEmpty)
                    {
                    giasp=0;
                   
                    }
                    else{
                    giasp=int.parse(_priceController.text);
                    
                    }
                    _priceController.text=giasp.toString();

                  });
                },
                decoration: InputDecoration(
                  labelText: 'Giá', 
               
                  suffix:Text(_chonMALoai == '1'?'Size 9 Inch':''),
              
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
           
              if(_chonMALoai=='1')
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text("Size 12 Inch - ${giasp+100000}"),
                  ),
               SizedBox(height: 16),
              // if (_chonMALoai == '1') ...[
              
              //   DropdownButton<String>(
              //     value: sizepiza,
              //     onChanged: (newValue) {
              //       setState(() {
              //         sizepiza = newValue;
              //       });
              //     },
              //     items: [
              //       {'value': 'M', 'label': 'Size 9 inch'}
              //     ].map<DropdownMenuItem<String>>((items) {
              //       return DropdownMenuItem<String>(
              //         value: items['value'],
              //         child: Text(items['label']!),
              //       );
              //     }).toList(),
              //   ),
              //    Text('Size 12 Inch - ${int.parse(_priceController.text)+100000}'),
              // ],
              DropdownButtonFormField<String>(
                value: Chonkhuyenmai,
                onChanged: (String? newValue) {
                  setState(() {
                    Chonkhuyenmai = newValue;
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
                  final promotionType = Chonkhuyenmai ?? '';
                  final Maloai = _chonMALoai ?? '';
                  final promotionValue =int.parse(_promotionValueController.text);
                  String? base64Image = '';
                  if (_selectedImage != null) {
                    base64Image = 'data:image/jpeg;base64,' +
                        await _convertImageToBase64(_selectedImage!);
                  }
                 await ThemSanPham(productName, description, price, Maloai,promotionType, promotionValue, base64Image);
                  Navigator.pop(context,true);

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
                child: Text( '            Thêm sản phẩm mới          '),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
