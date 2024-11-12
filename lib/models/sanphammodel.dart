class Product {
  final String hinh_anh;
  late final String ten_san_pham;
  late final double gia;
  final String mo_ta;
    int so_luong_ton_kho;
    int ma_san_pham; 
  

  Product({
    required this.hinh_anh,
    required this.ten_san_pham,
    required this.gia,
    required this.mo_ta,
    required this.so_luong_ton_kho,
    required this.ma_san_pham,
  });

  Map<String, dynamic> toJson() {
    return {
       'ma_san_pham': ma_san_pham,
      'ten_san_pham': ten_san_pham,
      'gia': gia,
      'so_luong_ton_kho': so_luong_ton_kho,
      'hinh_anh': hinh_anh,
      'mo_ta': mo_ta,
    };
  }


  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      ma_san_pham:int.tryParse(json['ma_san_pham'].toString())??0 ,
      ten_san_pham: json['ten_san_pham'],
      gia: double.tryParse(json['gia'].toString()) ?? 0.0,
      so_luong_ton_kho: json['so_luong_ton_kho'],
      hinh_anh: json['hinh_anh'],
      mo_ta: json['mo_ta'],
    );
  }

}

