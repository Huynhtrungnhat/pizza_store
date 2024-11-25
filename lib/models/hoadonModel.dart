import 'package:pizza_store/models/khachhnag.dart';

class HoaDon {
  final int ma_hoa_don;
  final String? ngay_lap_hd;
  final double tong_tien;
  final int ma_nhan_vien;
final KhachHang? khachHang;
  final String createdAt;
  final String updatedAt;
  String trang_thai;
  final String ten_khach_hang;

  HoaDon({
    required this.ma_hoa_don,
    this.ngay_lap_hd,
    required this.tong_tien,
    required this.ma_nhan_vien,
    this.khachHang,
    required this.createdAt,
    required this.updatedAt,
    required this.trang_thai,
    required this.ten_khach_hang
  });

  factory HoaDon.fromJson(Map<String, dynamic> json) {
    return HoaDon(
      ma_hoa_don: json['ma_hoa_don'] ?? '',
      ngay_lap_hd: json['ngay_lap_hd'],
      tong_tien: double.tryParse(json['tong_tien'].toString()) ?? 0.0,
      ma_nhan_vien: json['ma_nhan_vien'] ?? '',
       khachHang: json['ma_khach_hang'] != null
          ? KhachHang.fromJson(json['ma_khach_hang'])
          : null,
      createdAt: json['createdAt']?? '',
      updatedAt: json['updatedAt']?? '',
      trang_thai: json['trang_thai']?? '',
      ten_khach_hang: json['ten_khach_hang']?? ''
    );
  }
}