import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/cthoadonModel.dart';
import 'package:pizza_store/models/hoadonModel.dart';
import 'package:pizza_store/models/khachhnag.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  final int maHoaDon;
  final int makh;
  final HoaDon order;
  final Function(String) onUpdateStatus;

  const InvoiceDetailsScreen(
      {required this.maHoaDon, required this.makh,required this.order,
    required this.onUpdateStatus, Key? key})
      : super(key: key);

  @override
  _InvoiceDetailsScreenState createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  late Future<List<InvoiceDetail>> _futureInvoiceDetails;
  late Future<KhachHang> _khachHangDetails;
    final List<String> _statusList = [
    'Chờ xác nhận',
    'Đang vận chuyển',
    'Hoàn thành',
    'Đã hủy',
  ];
    String? userId;
    late String _selectedStatus;
  @override
  void initState() {
    super.initState();
    _futureInvoiceDetails = fetchInvoiceDetails(widget.maHoaDon);
    _khachHangDetails = fetchKhachHang(widget.makh); 
     _selectedStatus = _statusList.contains(widget.order.trang_thai)
      ? widget.order.trang_thai
      : _statusList.first;
  }
  Future<void> _updateStatusOnApi(String newStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    final url = Uri.parse('${AppConstants.hoadon}/${widget.order.ma_hoa_don}');

    try {
      final requestBody = jsonEncode({
        'ma_hoa_don': widget.order.ma_hoa_don,
        'ma_nhan_vien': userId,
        'trang_thai': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      });

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          widget.order.trang_thai = newStatus;
        });
        widget.onUpdateStatus(newStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trạng thái đơn hàng đã được cập nhật $userId.')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật trạng thái thất bại!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi cập nhật trạng thái. Chi tiết lỗi: $e')),
      );
    }
  }
  Future<KhachHang> fetchKhachHang(int makh) async {
    final response = await http.get(Uri.parse('${AppConstants.khachhang}/$makh'));

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return KhachHang.fromJson(data['khachhang']);
    } else {
      throw Exception('Không thể tải dữ liệu khách hàng');
    }
  }

  Future<List<InvoiceDetail>> fetchInvoiceDetails(int maHoaDon) async {
    final response = await http.get(
      Uri.parse('${AppConstants.cthoadondh}/hd/${widget.maHoaDon}'),
    );

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['cthoadon'];
      return data.map((json) => InvoiceDetail.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải dữ liệu từ API');
    }
  }
  Widget dashedDivider({
    double dashWidth = 5,
    double dashHeight = 2,
    List<Color> colors = const [Colors.grey, Colors.blue], 
    double indent = 20,
    double endIndent = 20,
    double spaceBetweenDashes = 3,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: indent),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double dashCount =
              (constraints.constrainWidth() - indent - endIndent) /
                  (dashWidth + spaceBetweenDashes);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount.floor(), (index) {
              return Container(
                width: dashWidth,
                height: dashHeight,
                color: colors[index % colors.length], 
              );
            }),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết hóa đơn'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           FutureBuilder<KhachHang>(
  future: _khachHangDetails,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Lỗi: ${snapshot.error}'));
    } else if (snapshot.hasData) {
      final customer = snapshot.data!;
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dashedDivider(
              colors: [Colors.red, Colors.green],
              dashWidth: 10,
              dashHeight: 3,
              indent: 1,
              endIndent: 1,
              spaceBetweenDashes: 7,
            ),
            Row(
              children: [
                Icon(Icons.add_location_alt_outlined), 
                SizedBox(width: 10),
                Text(
                  'Địa chỉ nhận hàng',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: 150),
              ],
            ),
            SizedBox(height: 2),
            Text('Tên người nhận: ${customer.tenKhachHang}'),
            Text('Sđt: ${customer.sdt}'),
            Text('Địa chỉ: ${customer.diaChi}'),
            Text('Điểm mua hàng: ${customer.diemMuaHang}'),

            dashedDivider(
              colors: [Colors.red, Colors.green],
              dashWidth: 10,
              dashHeight: 3,
              indent: 1,
              endIndent: 1,
              spaceBetweenDashes: 7,
            ),
          ],
        ),
      );
    } else {
      return Center(child: Text('Không có dữ liệu khách hàng'));
    }
  },
),


            FutureBuilder<List<InvoiceDetail>>(
              future: _futureInvoiceDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final details = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: details.length,
                    itemBuilder: (context, index) {
                      final detail = details[index];
                      final product = detail.maSanPham;
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    '${AppConstants.BASE_URL}${product.hinh_anh}',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.ten_san_pham,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Mô tả: ${product.mo_ta}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Giá gốc: ${product.gia} VND',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Số lượng: ${detail.soLuong}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  
                } else {
                  return Center(child: Text('Không có dữ liệu chi tiết hóa đơn'));
                }
              },
            ),
            DropdownButton<String>(
                value: _selectedStatus,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  }
                },
                items: _statusList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
               ElevatedButton(
                onPressed: () => _updateStatusOnApi(_selectedStatus),
                child: Text(
                          'Cập nhật trạng thái',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
              ),
          ],
        ),
      ),
    );
  }
}
