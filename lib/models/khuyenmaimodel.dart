class KhuyenMai {
  final int maKhuyenMai;
  final String tenKhuyenMai;
  final String doiTuongApDung;
  final String? loaiKhuyenMai;
  final double? giaTriKhuyenMai;
  final String apDungTuNgay;
  final String apDungDenNgay;
  final String? moTa;
  final int trangThai;


  // Constructor
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

  // Hàm khởi tạo từ JSON
  factory KhuyenMai.fromJson(Map<String, dynamic> json) {
    return KhuyenMai(
      maKhuyenMai: json['ma_khuyen_mai'],
      tenKhuyenMai: json['ten_khuyen_mai'],
      doiTuongApDung: json['doi_tuong_ap_dung'],
      loaiKhuyenMai: json['loai_khuyen_mai'],
      giaTriKhuyenMai: json['gia_tri_khuyen_mai'],
      apDungTuNgay: json['ap_dung_tu_ngay'],
      apDungDenNgay: json['ap_dung_den_ngay'],
      moTa: json['mo_ta'],
      trangThai: json['trang_thai'],

    );
  }

  // Chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'ma_khuyen_mai': maKhuyenMai,
      'ten_khuyen_mai': tenKhuyenMai,
      'doi_tuong_ap_dung': doiTuongApDung,
      'loai_khuyen_mai': loaiKhuyenMai,
      'gia_tri_khuyen_mai': giaTriKhuyenMai,
      'ap_dung_tu_ngay': apDungTuNgay,
      'ap_dung_den_ngay': apDungDenNgay,
      'mo_ta': moTa,
      'trang_thai': trangThai,

    };
  }
}
