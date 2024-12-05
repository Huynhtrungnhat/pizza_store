import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/admin/khuyemmaiadd.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/khuyenmaimodel.dart';
import 'dart:convert';

import 'package:pizza_store/screen/editkhuyenmai.dart';
import 'package:pizza_store/screen/trangCTHD.dart';

class KhuyenMaiScreen extends StatefulWidget {
  const KhuyenMaiScreen({Key? key}) : super(key: key);

  @override
  _KhuyenMaiScreenState createState() => _KhuyenMaiScreenState();
}

class _KhuyenMaiScreenState extends State<KhuyenMaiScreen> {
  late Future<List<KhuyenMai>> _khuyenMaiFuture;

  @override
  void initState() {
    super.initState();
    _khuyenMaiFuture = fetchKhuyenMai(); 
  }

  Future<void> _deleteKhuyenMai(BuildContext context, int khuyenMaiId) async {
    final url = Uri.parse('${AppConstants.khuyenmai}/$khuyenMaiId');
    
    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
          setState(() {
        _khuyenMaiFuture = fetchKhuyenMai(); 
      });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Khuyến mãi đã được xóa')),
        );
        setState(() {
          _khuyenMaiFuture = fetchKhuyenMai(); 
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${json.decode(response.body)['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể kết nối với server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách khuyến mãi'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddKhuyenMaiPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<KhuyenMai>>(
        future: _khuyenMaiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có khuyến mãi nào'));
          } else {
            final khuyenMaiList = snapshot.data!;
            return ListView.builder(
              itemCount: khuyenMaiList.length,
              itemBuilder: (context, index) {
                final khuyenMai = khuyenMaiList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      khuyenMai.giaTriKhuyenMai?.toString() ?? 'N/A', 
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(khuyenMai.tenKhuyenMai),
                  subtitle: Text(
                      'Áp dụng: ${khuyenMai.apDungTuNgay} - ${khuyenMai.apDungDenNgay}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Trạng thái: ${khuyenMai.trangThai}'),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditKhuyenMaiScreen(khuyenMai: khuyenMai, makm: khuyenMai.maKhuyenMai),
                            ),
                                          ).then((value) {
                      setState(() {
                        _khuyenMaiFuture = fetchKhuyenMai();
                      });
                    });
                          
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                           _deleteKhuyenMai(context, khuyenMai.maKhuyenMai);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
