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
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController promotionValueController = TextEditingController();
  XFile? _image;
  String? _selectedPromotionType;
  String? maloaisp;
  String? sizepiza;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.product['ten_san_pham'] ?? '';
    priceController.text = widget.product['gia']?.toString() ?? '0';
    descriptionController.text = widget.product['mo_ta'] ?? '';
    imageUrlController.text =AppConstants.BASE_URL + (widget.product['hinh_anh'] ?? '');
    maloaisp = widget.product['ma_loai']?.toString();
    _selectedPromotionType = widget.product['loai_khuyen_mai'];
    promotionValueController.text =widget.product['gia_tri_khuyen_mai']?.toString() ?? '0';
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
        return 'data:image/jpeg;base64,' + base64Encode(response.bodyBytes);
      } else {
        throw Exception('Không thể tải ảnh');
      }
    } catch (e) {
      print('Lỗi khi chuyển đổi URL thành base64: $e');
      return '';
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> updateProduct(
    String tenSanPham,
    String moTa,
    int gia,
   // String size,
    String maLoai,
    String loaiKhuyenMai,
    int giaTriKhuyenMai,
    String hinhAnh,
  ) async {
    final url = Uri.parse(
        '${AppConstants.ALL_PRODUCT_URI}/${widget.product['ma_san_pham']}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ten_san_pham': tenSanPham,
          'mo_ta': moTa,
          'gia': gia,
          'size': "M",
          'ma_loai': maLoai,
          'loai_khuyen_mai': loaiKhuyenMai,
          'gia_tri_khuyen_mai': giaTriKhuyenMai,
          'hinh_anh': hinhAnh,
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
              SizedBox(height: 16),
              Text('Mã loại sản phẩm'),
              DropdownButton<String>(
                value: maloaisp,
                onChanged: (newValue) {
                  setState(() {
                    maloaisp = newValue;
                  });
                },
                items: [
                  {'value': '1', 'label': 'Pizza'},
                  {'value': '2', 'label': 'Gà'},
                  {'value': '3', 'label': 'Mỳ'},
                  {'value': '4', 'label': 'Thức uống'}
                ].map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['value'],
                    child: Text(item['label']!),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              if (maloaisp == '1') ...[
                Text('Chọn size pizza'),
                DropdownButton<String>(
                  value: sizepiza,
                  onChanged: (newValue) {
                    setState(() {
                      sizepiza = newValue;
                    });
                  },
                  items: [
                    {'value': 'M', 'label': 'Size 9 inch'}
                  ].map<DropdownMenuItem<String>>((items) {
                    return DropdownMenuItem<String>(
                      value: items['value'],
                      child: Text(items['label']!),
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 16),
              Text('Chọn loại khuyến mãi'),
              DropdownButton<String>(
                value: _selectedPromotionType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedPromotionType = newValue;
                  });
                },
                items: [
                  {'value': 'PHANTRAM', 'label': 'Phần trăm sản phẩm'},
                  {'value': 'GIATRI', 'label': 'Giá trị sản phẩm'}
                ].map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['value'],
                    child: Text(item['label']!),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              TextField(
                controller: promotionValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _selectedPromotionType == 'PHANTRAM'
                      ? 'Nhập phần trăm giảm giá'
                      : 'Nhập giá trị giảm giá',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String base64Image = '';
                  if (_image != null) {
                    base64Image =
                        'data:image/jpeg;base64,${await _convertImageToBase64(_image!)}';
                  } else if (imageUrlController.text.isNotEmpty) {
                    base64Image =
                        await _convertUrlToBase64(imageUrlController.text);
                  }
                  await updateProduct(
                    nameController.text,
                    descriptionController.text,
                    int.tryParse(priceController.text) ?? 0,
                    maloaisp ?? '',
                    _selectedPromotionType ?? '',
                    int.tryParse(promotionValueController.text) ?? 0,
                    base64Image,
                  );

                  Navigator.pop(context);
                },
                child: Text('Lưu sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
