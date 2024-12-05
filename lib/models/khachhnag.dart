class KhachHang {
  final int maKhachHang;
  final String tenKhachHang;
  final String? diaChi;
  final String sdt;
  final int diemMuaHang;
  final DateTime createdAt;
  final DateTime updatedAt;

  KhachHang({
    required this.maKhachHang,
    required this.tenKhachHang,
    this.diaChi,
    required this.sdt,
    required this.diemMuaHang,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KhachHang.fromJson(Map<String, dynamic> json) {
    return KhachHang(
      maKhachHang: json['ma_khach_hang'],
      tenKhachHang: json['ten_khach_hang'],
      diaChi: json['diachi'],
      sdt: json['sdt'],
      diemMuaHang: json['diem_mua_hang'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  
}
