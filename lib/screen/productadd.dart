import 'dart:convert';

import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/modeladdsanpham.dart';
import 'package:pizza_store/models/sanphammodel.dart';
import 'package:http/http.dart' as http;
class Myaddproduct{

  Future<addproduct?> Addproducrtdata (String tenSanPham,String moTa,String gia,String soLuongTonKho)async{
    var url=Uri.parse(AppConstants.ALL_PRODUCT_URI);
    var response = await http.post(url,body: {
    "ten_san_pham":tenSanPham ,
    "mo_ta":moTa ,
    "gia":gia ,
    "so_luong_ton_kho":soLuongTonKho,
    },
    );
    try{
      if(response.statusCode==201){
        addproduct model=addproduct.fromJson(jsonDecode(response.body));
        print(response.body);
        print("thêm san phảm thanh công");
        return model;
      }
      

    }catch(e){
      print(e.toString());
    }
    return null;

}
}