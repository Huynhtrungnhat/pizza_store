import 'package:flutter/material.dart';
import 'package:pizza_store/home/sanpham.dart';
import 'package:pizza_store/models/sanphamcart.dart';

class ThanhToanThanhCong extends StatefulWidget {

  @override
  State<ThanhToanThanhCong> createState() => _ThanhToanThanhCongState();
}

class _ThanhToanThanhCongState extends State<ThanhToanThanhCong> {

  void _quayveTrangChu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => detailsanpham(),
      ),
    ).then(
      (value) {
        setState(() {
          cart.getTotalQuantity();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            SizedBox(height: 100.0,),

            Icon(
              Icons.verified_outlined,
              color: Colors.green,
              size: 100.0,
            ),

            SizedBox(height: 30.0,),
          
            Text(
              'Đơn hàng đã được thanh toán thành công.', 
              style: 
                TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),
            ),

            SizedBox(height: 150.0,),
        
            ElevatedButton(
              onPressed: (){
                _quayveTrangChu();
              }, 
              child: Text('Về Trang Chủ', style: TextStyle(color: Colors.black),),
            )
          ],
        ),
      )
    );
  }
}