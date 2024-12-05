import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/khachhnag.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final int maHoaDon;
  final int makh;
  const InvoiceDetailScreen(
      {required this.maHoaDon, required this.makh, Key? key})
      : super(key: key);

  @override
  _InvoiceDetailScreenState createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late Future<Map<String, dynamic>> _invoiceDetails;
  late Future<KhachHang> _khachHangDetails;

  @override
  void initState() {
    super.initState();
    _invoiceDetails = fetchInvoiceDetails(widget.maHoaDon);
    _khachHangDetails = fetchkhanghang(widget.makh);
  }

  Future<void> _updateStatusOnApihuymuahang() async {
    final url = Uri.parse('${AppConstants.hoadon}/${widget.maHoaDon}');

    try {
      final requestBody = jsonEncode({
        'ma_hoa_don': widget.maHoaDon,
        'trang_thai': "Đã hủy",
      });

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trạng thái đơn hàng đã được cập nhật.')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật trạng thái thất bại!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Có lỗi xảy ra khi cập nhật trạng thái. Chi tiết lỗi: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> fetchInvoiceDetails(int maHoaDon) async {
    final response = await http.get(
      Uri.parse('${AppConstants.cthoadondh}/hdct/${widget.maHoaDon}'),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load invoice details');
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

  Future<KhachHang> fetchkhanghang(int makh) async {
    final response =
        await http.get(Uri.parse('${AppConstants.khachhang}/$makh'));

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return KhachHang.fromJson(data['khachhang']);
    } else {
      throw Exception('Không thể tải dữ liệu khách hàng');
    }
  }

  // Future<void> cancelInvoice(int maHoaDon) async {
  //   final response = await http.post(
  //     Uri.parse('http://192.168.1.10:8000/api/huyhoadon/$maHoaDon'),
  //   );

  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Hóa đơn đã được hủy.')),
  //     );
  //     setState(() {
  //       _invoiceDetails = fetchInvoiceDetails(widget.maHoaDon);
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Hủy hóa đơn thất bại.')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết Hóa Đơn #${widget.maHoaDon}'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _invoiceDetails,
        builder: (context, invoiceSnapshot) {
          if (invoiceSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (invoiceSnapshot.hasError) {
            return Center(child: Text('Lỗi hoadon: ${invoiceSnapshot.error}'));
          } else if (!invoiceSnapshot.hasData) {
            return Center(child: Text('Không có dữ liệu.'));
          }

          return FutureBuilder<KhachHang>(
            future: _khachHangDetails,
            builder: (context, customerSnapshot) {
              if (customerSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (customerSnapshot.hasError) {
                print(customerSnapshot.error);
                return Center(child: Text('Lỗi kh: ${customerSnapshot.error}'));
              } else if (!customerSnapshot.hasData) {
                return Center(child: Text('Không có dữ liệu khách hàng.'));
              }

              final khachHang = customerSnapshot.data!;
              final data = invoiceSnapshot.data!;
              final invoiceDetails = data['cthoadon'];
              final trangThai =
                  invoiceDetails.first['ma_hoa_don']['trang_thai'];
              final ngayLap = invoiceDetails.first['ma_hoa_don']['ngay_lap_hd'];
              final tongTien = invoiceDetails.first['ma_hoa_don']['tong_tien'];
              final pttt = invoiceDetails.first['ma_hoa_don']['pttt'];

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
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
                                      color: Colors.red),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(width: 150),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Tên người nhận: ${khachHang.tenKhachHang}',
                            ),
                            Text(
                              'Sđt: ${khachHang.sdt}',
                            ),
                            Text(
                              'Dịa chỉ : ${khachHang.diaChi}',
                            ),
                            dashedDivider(
                              colors: [
                                Colors.red,
                                Colors.green
                              ], // Màu sắc xen kẽ
                              dashWidth: 10,
                              dashHeight: 3,
                              indent: 1,
                              endIndent: 1,
                              spaceBetweenDashes: 7,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Chi tiết sản phẩm:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...invoiceDetails.map((detail) {
                        final product = detail['ma_san_pham'];
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
                                  'Số lượng: ${detail['so_luong']}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                                Text(
                                  'Trạng Thái: ${trangThai}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                                Text(
                                  'Phương thức thanh toán: ${pttt}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Tổng tiền Hóa đơn: ${tongTien}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (trangThai == 'Chờ xác nhận') ...[
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _updateStatusOnApihuymuahang();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                            ),
                            child: Text(
                              'Hủy Hóa Đơn',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
