import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_store/admin/trangchitietphanquyen.dart';
import 'package:pizza_store/models/nhanvienModel.dart';
import 'package:pizza_store/screen/editnhanvien.dart';
import 'package:pizza_store/screen/fechdatakhhpadon.dart';
import 'package:pizza_store/screen/trangnguoidungphanquyen.dart';

import '../admin/addnhanvien.dart';

class NhanVienListScreen extends StatefulWidget {
  @override
  _NhanVienListScreenState createState() => _NhanVienListScreenState();
}

class _NhanVienListScreenState extends State<NhanVienListScreen> {
  late Future<List<NhanVien>> _futureNhanVien;

  @override
  void initState() {
    super.initState();
    _loadNhanVienList();
  }

  void _loadNhanVienList() {
    _futureNhanVien = ApiService().fetchNhanVien();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách nhân viên'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemNhanVienPage()),
              );
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<NhanVien>>(
        future: _futureNhanVien,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu'));
          }

          final nhanVienList = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: nhanVienList.length,
            itemBuilder: (context, index) {
              final nhanVien = nhanVienList[index];

              return GestureDetector(
                onTap: () async {
                  final updatedNhanVien = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditNhanVienScreen(nhanVien: nhanVien),
                    ),
                  );

                  if (updatedNhanVien != null) {
                    setState(() {
                      _loadNhanVienList();
                    });
                  }
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue[100],
                              child: Text(
                                nhanVien.tenNhanVien[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nhanVien.tenNhanVien,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Mã nhân viên: ${nhanVien.maNhanVien}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.security),
                              color: Colors.blueAccent,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserPermissionsScreen(
                                        nhanVien: nhanVien),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Divider(
                            height: 20, thickness: 1, color: Colors.grey[300]),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 18, color: Colors.grey),
                            SizedBox(width: 5),
                            Text('Ngày sinh: ${nhanVien.ngaySinh}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.male, size: 18, color: Colors.grey),
                            SizedBox(width: 5),
                            Text(
                                'Giới tính: ${nhanVien.gioiTinh == 1 ? "Nam" : "Nữ"}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.male, size: 18, color: Colors.grey),
                            SizedBox(width: 5),
                            Text(
                                'Trạng thái: ${nhanVien.trangThai == 1 ? "Hoạt Động" : "Đã Nghĩ"}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Icon(Icons.date_range_outlined,
                        //         size: 18, color: Colors.grey),
                        //     SizedBox(width: 5),
                        //     Text('Ngày cập Nhật: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(nhanVien.updated_at.toString()))}',
                        //         style: TextStyle(fontSize: 16)),
                        //   ],
                        // ),
                      ],
                    ),
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
