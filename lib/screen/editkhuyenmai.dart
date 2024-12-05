import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/khuyenmaimodel.dart';

class EditKhuyenMaiScreen extends StatefulWidget {
  final KhuyenMai khuyenMai;
  final int makm;

  const EditKhuyenMaiScreen({Key? key, required this.khuyenMai,required this.makm}) : super(key: key);

  @override
  _EditKhuyenMaiScreenState createState() => _EditKhuyenMaiScreenState();
}

class _EditKhuyenMaiScreenState extends State<EditKhuyenMaiScreen> {
  late TextEditingController tenKhuyenMaiController;
  late TextEditingController doiTuongController;
  late TextEditingController moTaController;
  late DateTime tuNgay;
  late DateTime denNgay;

  @override
  void initState() {
    super.initState();
    tenKhuyenMaiController = TextEditingController(text: widget.khuyenMai.tenKhuyenMai);
    doiTuongController = TextEditingController(text: widget.khuyenMai.doiTuongApDung ?? '');
    moTaController = TextEditingController(text: widget.khuyenMai.moTa ?? '');
    tuNgay = DateTime.parse(widget.khuyenMai.apDungTuNgay);
    denNgay = DateTime.parse(widget.khuyenMai.apDungDenNgay);
  }

  @override
  void dispose() {
    tenKhuyenMaiController.dispose();
    doiTuongController.dispose();
    moTaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = isStartDate ? tuNgay : denNgay;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          tuNgay = pickedDate;
        } else {
          denNgay = pickedDate;
        }
      });
    }
  }
  Future<void> _updateKhuyenMai() async {
  try {
    final response = await http.put(
      Uri.parse('${AppConstants.khuyenmai}/${widget.makm}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ten_khuyen_mai': tenKhuyenMaiController.text,
        'doi_tuong_ap_dung': doiTuongController.text,
        'mo_ta': moTaController.text,
        'ap_dung_tu_ngay': DateFormat('yyyy-MM-dd').format(tuNgay),
        'ap_dung_den_ngay': DateFormat('yyyy-MM-dd').format(denNgay),
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true); 
      throw Exception('Failed to update khuyến mãi');
    }
  } catch (e) {
   
  }
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa khuyến mãi: ${widget.khuyenMai.tenKhuyenMai}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: tenKhuyenMaiController,
                decoration: const InputDecoration(labelText: 'Tên khuyến mãi'),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: doiTuongController,
                decoration: const InputDecoration(labelText: 'Đối tượng áp dụng'),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: moTaController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ngày bắt đầu:'),
                  TextButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(DateFormat('yyyy-MM-dd').format(tuNgay)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ngày kết thúc:'),
                  TextButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(DateFormat('yyyy-MM-dd').format(denNgay)),
                  ),
                ],
              ),
              const SizedBox(height: 16),


              ElevatedButton(
                onPressed: () async {
                  await _updateKhuyenMai();
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
