class Product {
  final String hinh_anh;
  late final String ten_san_pham;
  late final double gia;
  final String mo_ta;
  int so_luong_ton_kho;
  int ma_san_pham; 
 int ma_loai;
  final String selectedSize; 
  final String selectedebanh; 

  Product({
    required this.hinh_anh,
    required this.ten_san_pham,
    required this.gia,
    required this.mo_ta,
    required this.so_luong_ton_kho,
    required this.ma_san_pham,
    required this.ma_loai,
    required this.selectedSize,
    required this.selectedebanh,
  });

  Map<String, dynamic> toJson() {
    return {
      'ma_san_pham': ma_san_pham,
      'ten_san_pham': ten_san_pham,
      'gia': gia,
      'so_luong_ton_kho': so_luong_ton_kho,
      'hinh_anh': hinh_anh,
      'mo_ta': mo_ta,
      'ma_loai':ma_loai,
      'selectedSize': selectedSize,  
      'selectedebanh': selectedebanh, 
    };
  }

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      ma_san_pham: int.tryParse(json['ma_san_pham'].toString()) ?? 0,
      ten_san_pham: json['ten_san_pham'],
      gia: double.tryParse(json['gia'].toString()) ?? 0.0,
      so_luong_ton_kho: json['so_luong_ton_kho'],
      hinh_anh: json['hinh_anh'],
      mo_ta: json['mo_ta'],
      ma_loai: int.tryParse(json['ma_loai'].toString()) ?? 0,
      selectedSize: json['selectedSize'] ?? 'Cỡ 9 inch', 
      selectedebanh: json['selectedebanh'] ?? 'Đế dày bột tươi',
    );
  }
}
class Productct {
  final int maSanPham;
  final String tenSanPham;
  final String moTa;
  final String gia;
  final String hinhAnh;
  final String? loaiKhuyenMai;
  final String? giaTriKhuyenMai;

  Productct({
    required this.maSanPham,
    required this.tenSanPham,
    required this.moTa,
    required this.gia,
    required this.hinhAnh,
    this.loaiKhuyenMai,
    this.giaTriKhuyenMai,
  });

  factory Productct.fromJson(Map<String, dynamic> json) {
    return Productct(
      maSanPham: json['ma_san_pham'],
      tenSanPham: json['ten_san_pham'],
      moTa: json['mo_ta'],
      gia: json['gia'],
      hinhAnh: json['hinh_anh'],
      loaiKhuyenMai: json['loai_khuyen_mai'],
      giaTriKhuyenMai: json['gia_tri_khuyen_mai'],
    );
  }
}