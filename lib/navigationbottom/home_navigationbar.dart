import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pizza_store/admin/addnhanvien.dart';
import 'package:pizza_store/admin/addsanpham.dart';
import 'package:pizza_store/admin/adminscreen.dart';
import 'package:pizza_store/admin/timkhtheohoadon.dart';
import 'package:pizza_store/admin/trangQuanLyDonHang.dart';

import 'package:pizza_store/login/regisiter.dart';
import 'package:pizza_store/models/layidnguoidung.dart';
import 'package:pizza_store/models/sanphamcart.dart';
import 'package:pizza_store/navigationbottom/donhang_page.dart';
import 'package:pizza_store/home/home_page.dart';
import 'package:pizza_store/navigationbottom/profile_page.dart';
import 'package:pizza_store/navigationbottom/shopcash.dart';
import 'package:pizza_store/screen/Trangcanhan.dart';
import 'package:pizza_store/admin/adminlistscren.dart';
import 'package:pizza_store/screen/fechdatakhhpadon.dart';
import 'package:pizza_store/screen/thanhtoankethop.dart';
import 'package:pizza_store/screen/themkhuyenmai.dart';
import 'package:pizza_store/screen/trangCTHD.dart';
import 'package:pizza_store/screen/trangdonhang.dart';
import 'package:pizza_store/screen/tranggiohang.dart';

 // Đảm bảo import AuthService

class CurveBar extends StatefulWidget {
  const CurveBar({super.key});

  @override
  State<CurveBar> createState() => _CurveBarState();
}

class _CurveBarState extends State<CurveBar> {
  int index = 0;
  String? userId; 
  int madangnhap=0;// Khai báo biến userId

  @override
  void initState() {
    super.initState();
    _loadUserId(); 
  }

  Future<void> _loadUserId() async {
    userId = await AuthService.getUserId(); 
    // madangnhap = (await AuthService.getUserId()) as int; 
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      const Icon(Icons.home, size: 30),
      const Icon(Icons.search, size: 30),
      const Icon(Icons.person, size: 30),
      const Icon(Icons.shopping_cart_rounded, size: 30),
    ];

    final screen = [
      detailsanpham(),
      AdminPage(),
      userId != null ? UserProfilePage(userId: userId!) : Center(child: Text('Chưa đăng nhập')),
      QuanLyDonHangkh(),
    ];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 200, 233, 239),
      extendBody: true,
      body: screen[index], 
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        child: CurvedNavigationBar(
          color: Color.fromARGB(255, 16, 127, 144),
          buttonBackgroundColor: Color.fromARGB(255, 55, 14, 6),
          backgroundColor: Colors.transparent,
          items: items,
          height: 60,
          index: index,
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
    );
  }
}
