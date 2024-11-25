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
  final String? updated_at;
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
     this.updated_at,
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
      updated_at: json['updated_at'],
    );
  }
  // Phương thức để chuyển từ NhanVien object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'ma_nhan_vien': maNhanVien,
      'ten_nhan_vien': tenNhanVien,
      'ngay_sinh': ngaySinh,
      'gioi_tinh': gioiTinh,
      'dia_chi': diaChi,
      'email': email,
      'sdt': sdt,
      'trang_thai': trangThai,
    };
  }
}
