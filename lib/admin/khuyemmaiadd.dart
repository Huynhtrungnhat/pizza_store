import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pizza_store/api/controller.dart';

class AddKhuyenMaiPage extends StatefulWidget {
  @override
  _AddKhuyenMaiPageState createState() => _AddKhuyenMaiPageState();
}

class _AddKhuyenMaiPageState extends State<AddKhuyenMaiPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController tenKhuyenMaiController = TextEditingController();
  TextEditingController apDungTuNgayController = TextEditingController();
  TextEditingController apDungDenNgayController = TextEditingController();
  String? doiTuongApDungController;

  bool trangThai = true; 

  List<String> doiTuongList = ['HOADON', 'SANPHAM'];

  Future<void> addKhuyenMai() async {
    final url = '${AppConstants.khuyenmai}'; 
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'ten_khuyen_mai': tenKhuyenMaiController.text,
        'doi_tuong_ap_dung': doiTuongApDungController ?? '',
        'ap_dung_tu_ngay': apDungTuNgayController.text,
        'ap_dung_den_ngay': apDungDenNgayController.text,
        'trang_thai': trangThai ? 1 : 0,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {

      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Khuyến mãi đã được thêm thành công!')),
      );
     
      _formKey.currentState?.reset();
    } else {
 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${response.statusCode}')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        controller.text = "${selectedDate.toLocal()}".split(' ')[0]; // Format as yyyy-MM-dd
      });
    }
  }

 
  String? validateDates() {
    DateTime? startDate = DateTime.tryParse(apDungTuNgayController.text);
    DateTime? endDate = DateTime.tryParse(apDungDenNgayController.text);
    DateTime currentDate = DateTime.now();

    if (startDate == null || endDate == null) {
      return 'Vui lòng nhập đầy đủ ngày hợp lệ';
    }


    if (startDate.isBefore(currentDate)) {
      return 'Ngày bắt đầu phải là ngày hiện tại hoặc lớn hơn';
    }

    
    if (endDate.isBefore(startDate)) {
      return 'Ngày kết thúc phải lớn hơn ngày bắt đầu';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Khuyến Mãi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: tenKhuyenMaiController,
                decoration: InputDecoration(labelText: 'Tên Khuyến Mãi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên khuyến mãi';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: doiTuongApDungController,
                decoration: InputDecoration(labelText: 'Đối Tượng Áp Dụng'),
                items: doiTuongList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    doiTuongApDungController = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn đối tượng áp dụng';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: apDungTuNgayController,
                decoration: InputDecoration(labelText: 'Áp Dụng Từ Ngày'),
                readOnly: true,
                onTap: () => _selectDate(context, apDungTuNgayController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ngày áp dụng từ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: apDungDenNgayController,
                decoration: InputDecoration(labelText: 'Áp Dụng Đến Ngày'),
                readOnly: true,
                onTap: () => _selectDate(context, apDungDenNgayController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ngày áp dụng đến';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Text('Trạng thái: '),
                  Switch(
                    value: trangThai,
                    onChanged: (value) {
                      setState(() {
                        trangThai = value;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      String? dateValidationError = validateDates();
                      if (dateValidationError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(dateValidationError)),
                        );
                      } else {
                        addKhuyenMai(); 
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text('Thêm Khuyến Mãi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
