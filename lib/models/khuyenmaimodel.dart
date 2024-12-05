class KhuyenMai {
  final int maKhuyenMai;
  final String tenKhuyenMai;
  final String doiTuongApDung;
  final String? loaiKhuyenMai;
  final String? giaTriKhuyenMai; 
  final String apDungTuNgay;
  final String apDungDenNgay;
  final String? moTa;
  final int trangThai;

  KhuyenMai({
    required this.maKhuyenMai,
    required this.tenKhuyenMai,
    required this.doiTuongApDung,
    this.loaiKhuyenMai,
    this.giaTriKhuyenMai,
    required this.apDungTuNgay,
    required this.apDungDenNgay,
    this.moTa,
    required this.trangThai,
  });


  factory KhuyenMai.fromJson(Map<String, dynamic> json) {
    return KhuyenMai(
      maKhuyenMai: json['ma_khuyen_mai'],
      tenKhuyenMai: json['ten_khuyen_mai'],
      doiTuongApDung: json['doi_tuong_ap_dung'],
      loaiKhuyenMai: json['loai_khuyen_mai'],
      giaTriKhuyenMai: json['gia_tri_khuyen_mai']?.toString(),
      apDungTuNgay: json['ap_dung_tu_ngay'],
      apDungDenNgay: json['ap_dung_den_ngay'],
      moTa: json['mo_ta'],
      trangThai: json['trang_thai'],
    );
  }
}
