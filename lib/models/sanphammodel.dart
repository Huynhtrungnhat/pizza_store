class Product {
  final String hinh_anh;
  final String ten_san_pham;
  final double gia;
  final String mo_ta;
   int so_luong_ton_kho;

  

  Product({
    required this.hinh_anh,
    required this.ten_san_pham,
    required this.gia,
    required this.mo_ta,
    required this.so_luong_ton_kho,
  });
  
  // factory Product.fromJson(Map<String, dynamic> json) {
  //   return Product(
  //     hinh_anh: json['hinh_anh'] ?? '',
  //     ten_san_pham: json['ten_san_pham'] ?? '',
  //     gia: (json['gia'] ?? 0),
  //     mo_ta: json['mo_ta'] ?? '',
  //   );
  // }
}

