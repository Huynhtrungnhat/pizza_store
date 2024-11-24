class NhanVien {
  final int maNhanVien;
  final String tenNhanVien;
  final int maLoaiNhanVien;
  final int gioiTinh;
  final String? ngaySinh;
  final String diaChi;
  final String email;
  final String sdt;
  final int trangThai;
  final DateTime createdAt;
  final DateTime updatedAt;

  NhanVien({
    required this.maNhanVien,
    required this.tenNhanVien,
    required this.maLoaiNhanVien,
    required this.gioiTinh,
    required this.ngaySinh,
    required this.diaChi,
    required this.email,
    required this.sdt,
    required this.trangThai,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NhanVien.fromJson(Map<String, dynamic> json) {
    return NhanVien(
      maNhanVien: json['ma_nhan_vien'],
      tenNhanVien: json['ten_nhan_vien'],
      maLoaiNhanVien: json['ma_loai_nhan_vien'],
      gioiTinh: json['gioi_tinh'],
      ngaySinh: json['ngay_sinh'],
      diaChi: json['dia_chi'],
      email: json['email'],
      sdt: json['sdt'],
      trangThai: json['trang_thai'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
