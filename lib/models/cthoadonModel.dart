class ChiTietHoaDon {
  final int maChiTietHoaDon;
  final int maHoaDon;
  final int maSanPham;
  final int soLuong;
  final String gia;
  final String? loaiBanh;
  final String giaKhuyenMai;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChiTietHoaDon({
    required this.maChiTietHoaDon,
    required this.maHoaDon,
    required this.maSanPham,
    required this.soLuong,
    required this.gia,
    this.loaiBanh,
    required this.giaKhuyenMai,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChiTietHoaDon.fromJson(Map<String, dynamic> json) {
    return ChiTietHoaDon(
      maChiTietHoaDon: json['ma_chi_tiet_hoa_don'],
      maHoaDon: json['ma_hoa_don'],
      maSanPham: json['ma_san_pham'],
      soLuong: json['so_luong'],
      gia: json['gia'],
      loaiBanh: json['loai_banh'],
      giaKhuyenMai: json['gia_khuyen_mai'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}


