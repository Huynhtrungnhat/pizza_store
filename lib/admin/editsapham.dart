import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductPage({super.key, required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  XFile? _image;
  TextEditingController promotionValueController = TextEditingController();
  String? _selectedPromotionType;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.product['ten_san_pham'];
    priceController.text = widget.product['gia'].toString();
    descriptionController.text = widget.product['mo_ta'] ?? '';
    stockController.text = widget.product['so_luong_ton_kho'].toString();
    imageUrlController.text = AppConstants.BASE_URL + widget.product['hinh_anh'] ?? '';
    _selectedPromotionType = widget.product['loai_khuyen_mai'];
    promotionValueController.text = widget.product['gia_tri_khuyen_mai'] ?? '0';
  }

  Future<String?> _convertImageToBase64(XFile imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(Uint8List.fromList(bytes));
    } catch (e) {
      print('Error converting image to base64: $e');
      return null;
    }
  }
  Future<String> _convertUrlToBase64(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      // Chuyển đổi dữ liệu hình ảnh thành base64
      return 'data:image/jpeg;base64,' + base64Encode(response.bodyBytes);
    } else {
      throw Exception('Không thể tải ảnh');
    }
  } catch (e) {
    print('Lỗi khi chuyển đổi URL thành base64: $e');
    return '';
  }
}


  // Pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }
  Future<void> updateProduct(String ten_san_pham, String mota, int gia, int so_luong_ton_kho,
      int ma_loai_san_pham, String ma_loai, String loai_khuyen_mai, int gia_tri_khuyen_mai, String Hinhanh) async {
    final url = Uri.parse('${AppConstants.ALL_PRODUCT_URI}/${widget.product['ma_san_pham']}'); 
    print(widget.product['ma_san_pham']);
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
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

      if (response.statusCode == 200) {
        print('Sản phẩm đã được cập nhật thành công');
      } else {
        print('Lỗi khi cập nhật sản phẩm. Mã lỗi: ${response.statusCode}');
      }
    } catch (error) {
      print('Lỗi khi thực hiện yêu cầu: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa sản phẩm'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(File(_image!.path)),
                            fit: BoxFit.cover,
                          )
                        : (imageUrlController.text.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(imageUrlController.text),
                                fit: BoxFit.cover,
                              )
                            : null),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _image == null && imageUrlController.text.isEmpty
                      ? Center(
                          child: Text(
                            'Chọn hình ảnh',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Giá sản phẩm'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Số lượng tồn kho'),
              ),
              DropdownButton<String>(
                value: _selectedPromotionType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedPromotionType = newValue;
                  });
                },
                items: ['PHANTRAM', 'GIATRI'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Chọn loại khuyến mãi'),
              ),
              SizedBox(height: 16),

              TextField(
                controller: promotionValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Giá trị khuyến mãi'),
              ),
              SizedBox(height: 16),

              // Save button
              ElevatedButton(
                onPressed: () async {
               
                  String? base64Image = '';
                  if (_image != null) {
                      // Nếu chọn ảnh mới, chuyển đổi nó thành base64
                      base64Image = 'data:image/jpeg;base64,${await _convertImageToBase64(_image!)}';
                    } else if (imageUrlController.text.isNotEmpty) {
                      // Nếu không chọn ảnh mới, lấy URL ảnh cũ và chuyển đổi nó thành base64
                      base64Image = await _convertUrlToBase64(imageUrlController.text);
                    }
                  String tenSanPham = nameController.text;
                  String moTa = descriptionController.text;
                  int gia = int.tryParse(priceController.text) ?? 0;
                  int soLuongTonKho = int.tryParse(stockController.text) ?? 0;
                  int maLoaiSanPham = widget.product['ma_loai_san_pham'] ?? 0;
                  String maLoai = widget.product['ma_loai'] ?? 0; 
                  String loaiKhuyenMai = _selectedPromotionType ?? '';
                  int giaTriKhuyenMai = int.tryParse(promotionValueController.text) ?? 0;

      
                  await updateProduct(
                    tenSanPham,
                    moTa,
                    gia,
                    soLuongTonKho,
                    maLoaiSanPham,
                    maLoai,
                    loaiKhuyenMai,
                    giaTriKhuyenMai,
                    base64Image ?? '',
                  );
                },
                
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
