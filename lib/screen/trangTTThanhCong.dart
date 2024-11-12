import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pizza_store/navigationbottom/home_navigationbar.dart';

class ThanhToanThanhCong extends StatefulWidget {

  @override
  State<ThanhToanThanhCong> createState() => _ThanhToanThanhCongState();
}

class _ThanhToanThanhCongState extends State<ThanhToanThanhCong> {

void _quayveTrangChu() {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => CurveBar(),
    ),
    (route) => false, 
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(

          children: [

            Lottie.network(
              'https://lottie.host/96ac8faa-0762-431d-9037-69c6b7c20e4a/xsX7tCGShJ.json', 
              width: 200.0, 
              height: 200.0
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