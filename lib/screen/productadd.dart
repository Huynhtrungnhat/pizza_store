import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final int maHoaDon; // Truyền mã hóa đơn vào màn hình

  const InvoiceDetailScreen({required this.maHoaDon, Key? key}) : super(key: key);

  @override
  _InvoiceDetailScreenState createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late Future<List<dynamic>> _invoiceDetails;

  @override
  void initState() {
    super.initState();
    _invoiceDetails = fetchInvoiceDetails(widget.maHoaDon);
  }

  Future<List<dynamic>> fetchInvoiceDetails(int maHoaDon) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.10:8000/api/cthoadon/${widget.maHoaDon}'), // API của bạn
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['cthoadon'];
    } else {
      throw Exception('Failed to load invoice details');
    }
  }
  Widget dashedDivider({
    double dashWidth = 5,
    double dashHeight = 2,
    List<Color> colors = const [Colors.grey, Colors.blue], // Màu xen kẽ
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
                color: colors[index % colors.length], // Xen kẽ màu
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
      title: Text('Chi Tiết Hóa Đơn #${widget.maHoaDon}'),
    ),
    body: FutureBuilder<List<dynamic>>(
      future: _invoiceDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có dữ liệu.'));
        }

        final invoiceDetails = snapshot.data!;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Address section (moved to the top)
                Row(
                  children: [
                    Icon(Icons.add_location_alt_outlined),
                    SizedBox(width: 10),
                    Text(
                      'Địa chỉ nhận hàng',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(width: 150),
                    Icon(Icons.edit),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                //  'Tên người nhận: ${userData?['ten_khach_hang'] ?? 'N/A'}',
                    'Tên người nhận: hhhhhhhhh}',
                ),
                Text(
                 // 'Sđt: ${userData?['sdt'] ?? 'N/A'}',
                 'Tên người nhận: hhhhhhhhh}',
                ),
                Text(
               //   'Địa Chỉ: ${userData?['diachi'] ?? 'N/A'} ',
               'Tên người nhận: hhhhhhhhh}',
                ),
                dashedDivider(
                  colors: [Colors.red, Colors.green], // Màu sắc xen kẽ
                  dashWidth: 10,
                  dashHeight: 3,
                  indent: 1,
                  endIndent: 1,
                  spaceBetweenDashes: 7,
                ),
                
                // Invoice details section
                ...invoiceDetails.map((detail) {
                  final product = detail['ma_san_pham'];
                  final hoadon = detail['ma_hoa_don'];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                '${AppConstants.BASE_URL}${product['hinh_anh']}',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Text(
                                  product['ten_san_pham'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Tổng tiền: ${hoadon['tong_tien']}đ',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                          Text(
                            'Số lượng: ${detail['so_luong']}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    ),
  );
}
}