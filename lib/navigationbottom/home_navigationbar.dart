import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pizza_store/admin/addnhanvien.dart';
import 'package:pizza_store/admin/addsanpham.dart';
import 'package:pizza_store/admin/adminscreen.dart';
import 'package:pizza_store/admin/tim_khach_hang_co_hoa_don/timkhtheohoadon.dart';
import 'package:pizza_store/admin/tim_khach_hang_co_hoa_don/timkiemtheosdtupdate.dart';
import 'package:pizza_store/admin/trangQuanLyDonHang.dart';
import 'package:pizza_store/login/login.dart';

import 'package:pizza_store/login/regisiter.dart';
import 'package:pizza_store/models/layidnguoidung.dart';
import 'package:pizza_store/models/sanphamcart.dart';
import 'package:pizza_store/models/usermodel.dart';
import 'package:pizza_store/navigationbottom/donhang_page.dart';
import 'package:pizza_store/home/home_page.dart';
import 'package:pizza_store/navigationbottom/profile_page.dart';
import 'package:pizza_store/navigationbottom/shopcash.dart';
import 'package:pizza_store/screen/Trangcanhan.dart';
import 'package:pizza_store/admin/adminlistscren.dart';
import 'package:pizza_store/screen/fechdatakhhpadon.dart';
import 'package:pizza_store/screen/chitiethoadonme.dart';
import 'package:pizza_store/screen/listkhuyenmai.dart';
import 'package:pizza_store/screen/thanhtoankethop.dart';
import 'package:pizza_store/screen/themkhuyenmai.dart';
import 'package:pizza_store/screen/trangCTHD%20(1).dart';
import 'package:pizza_store/screen/trangCTHD.dart';
import 'package:pizza_store/screen/trangdonhang.dart';
import 'package:pizza_store/screen/tranggiohang.dart';
import 'package:pizza_store/screen/trangtimcuakhachhang.dart';

import '../screen/listnhanvien.dart';


class CurveBar extends StatefulWidget {
  const CurveBar({super.key});

  @override
  State<CurveBar> createState() => _CurveBarState();
}

class _CurveBarState extends State<CurveBar> {
  int index = 0;
  String? userId; 

  @override
  void initState() {
    super.initState();
    _loadUserId(); 
  }

  Future<void> _loadUserId() async {
    userId = await AuthService.getUserId(); 
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      const Icon(Icons.home, size: 30),
      const Icon(Icons.search, size: 30),
      const Icon(Icons.shopping_cart_rounded, size: 30),
       const Icon(Icons.person, size: 30),
    ];
    
    final screen = [
      detailsanpham(),

      theodoidonhangcuaban(),
     timkhtheohdkhmy(),
     userId != null ? UserProfilePage(userId: userId!) : Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(' Bạn chưa đăng nhập'),
          const SizedBox(height: 20), 
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), 
              );
            },
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    ),
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
