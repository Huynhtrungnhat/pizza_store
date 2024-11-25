import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/models/modelloaigiatri.dart';

class DoiTuongApDung {
  final String key;
  final String label;

  DoiTuongApDung(this.key, this.label);
}

class Addkhuyenmaiad extends StatefulWidget {
  const Addkhuyenmaiad({super.key});

  @override
  State<Addkhuyenmaiad> createState() => _AddkhuyenmaiadState();
}

class _AddkhuyenmaiadState extends State<Addkhuyenmaiad> {
  late Future<List<LoaiGiaTri>> loaiGiaTriFuture;
  late Future<List<DoiTuongApDung>> doiTuongApDungFuture;
  LoaiGiaTri? selectedLoaiGiaTri;
  DoiTuongApDung? selectedDoiTuong;

  DateTime? startDate;
  DateTime? endDate;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<List<LoaiGiaTri>> fetchLoaiGiaTri() async {
    final response = await http.get(Uri.parse('http://192.168.1.9:8000/api/khuyen_mai/hang-so-cau-hinh'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['loai_gia_tri'];
      return data.entries.map((entry) => LoaiGiaTri(entry.key, entry.value)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<DoiTuongApDung>> fetchDoiTuongApDung() async {
    final response = await http.get(Uri.parse('http://192.168.1.9:8000/api/khuyen_mai/hang-so-cau-hinh'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['doi_tuong_ap_dung'];
      return data.entries.map((entry) => DoiTuongApDung(entry.key, entry.value)).toList();
    } else {
      throw Exception('Failed to load data ${response.statusCode} ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    loaiGiaTriFuture = fetchLoaiGiaTri();
    doiTuongApDungFuture = fetchDoiTuongApDung();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          startDateController.text = "${picked.day}/${picked.month}/${picked.year}";
        } else {
          endDate = picked;
          endDateController.text = "${picked.day}/${picked.month}/${picked.year}";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Sản Phẩm"),
      ),
      body: SingleChildScrollView(
        //scrollDirection: Axis.vertical, // Vertical scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              SizedBox(height: 16),

              // Dropdown for doi_tuong_ap_dung
              FutureBuilder<List<DoiTuongApDung>>(
                future: doiTuongApDungFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final doiTuongList = snapshot.data!;
                    return Container(
                      width: double.infinity, // Ensure full width for dropdown
                      child: DropdownButton<DoiTuongApDung>(
                        hint: Text('Chọn đối tượng áp dụng'),
                        value: selectedDoiTuong,
                        isExpanded: true, // Make dropdown full width
                        items: doiTuongList.map((doiTuong) {
                          return DropdownMenuItem<DoiTuongApDung>(
                            value: doiTuong,
                            child: Text(doiTuong.label),
                          );
                        }).toList(),
                        onChanged: (selected) {
                          setState(() {
                            selectedDoiTuong = selected;
                          });
                        },
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16),

              // Dropdown for loai_gia_tri
              FutureBuilder<List<LoaiGiaTri>>(
                future: loaiGiaTriFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final loaiGiaTriList = snapshot.data!;
                    return Container(
                      width: double.infinity,
                      child: DropdownButton<LoaiGiaTri>(
                        hint: Text('Chọn loại giá trị'),
                        value: selectedLoaiGiaTri,
                        isExpanded: true,
                        items: loaiGiaTriList.map((loai) {
                          return DropdownMenuItem<LoaiGiaTri>(
                            value: loai,
                            child: Text(loai.label),
                          );
                        }).toList(),
                        onChanged: (selected) {
                          setState(() {
                            selectedLoaiGiaTri = selected;
                          });
                        },
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16),

              // TextField for start date
              GestureDetector(
                onTap: () => _selectDate(context, true),
                child: AbsorbPointer(
                  child: TextField(
                    controller: startDateController,
                    decoration: InputDecoration(
                      labelText: 'Ngày áp dụng',
                      hintText: 'Chọn ngày',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // TextField for end date
              GestureDetector(
                onTap: () => _selectDate(context, false),
                child: AbsorbPointer(
                  child: TextField(
                    controller: endDateController,
                    decoration: InputDecoration(
                      labelText: 'Ngày kết thúc',
                      hintText: 'Chọn ngày',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả khuyến mãi'),
                maxLines:3,
              ),
              SizedBox(height: 100),

              // Uncomment and implement your button logic here if needed
              // ElevatedButton(
              //   onPressed: () {
              //     // Your logic to add product data
              //   },
              //   child: Text('Thêm sản phẩm'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
