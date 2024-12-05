class HoaDon {
  final int maHoaDon;
  final String? ngayLapHd;
  final double tongTien;
  final String? trangThai;
  final String? pttt;

  HoaDon({
    required this.maHoaDon,
    this.ngayLapHd,
    required this.tongTien,
    this.trangThai,
     this.pttt,
  });

  factory HoaDon.fromJson(Map<String, dynamic> json) {

    double parsedTongTien = 0.0;
    if (json['tong_tien'] != null) {

      if (json['tong_tien'] is String) {
        parsedTongTien = double.tryParse(json['tong_tien']) ?? 0.0;
      } else if (json['tong_tien'] is num) {
        parsedTongTien = json['tong_tien'].toDouble();
      }
    }

    return HoaDon(
      maHoaDon: json['ma_hoa_don'],
      ngayLapHd: json['ngay_lap_hd'],
      tongTien: parsedTongTien,
      trangThai: json['trang_thai'],
      pttt: json['pttt'],
    );
  }
}
