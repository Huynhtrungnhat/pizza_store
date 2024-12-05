import 'package:pizza_store/models/hoadonModel.dart';
import 'package:pizza_store/models/sanphammodel.dart';

class ChiTietHoaDon {
  final int maChiTietHoaDon;
 final HoaDon? hoaDon;
  final Product ? sanpham;
  final int soLuong;
  final String gia;
  final String? loaiBanh;
  final String giaKhuyenMai;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChiTietHoaDon({
    required this.maChiTietHoaDon,
     this.hoaDon,
     this.sanpham,
    required this.soLuong,
    required this.gia,
    this.loaiBanh,
    required this.giaKhuyenMai,
    required this.createdAt,
    required this.updatedAt, HoaDon? Product,
  });

  factory ChiTietHoaDon.fromJson(Map<String, dynamic> json) {
    return ChiTietHoaDon(
      maChiTietHoaDon: json['ma_chi_tiet_hoa_don'],
       hoaDon: json['ma_hoa_don'] != null
          ? HoaDon.fromJson(json['ma_hoa_don'])
          : null,
      Product: json['ma_san_pham'] != null
          ? HoaDon.fromJson(json['ma_san_pham'])
          : null,
      soLuong: json['so_luong'],
      gia: json['gia'],
      loaiBanh: json['loai_banh'],
      giaKhuyenMai: json['gia_khuyen_mai'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class InvoiceDetail {
  final int maChiTietHoaDon;
  final int maHoaDon;
  final Product maSanPham;
  final int soLuong;
  final String gia;

  InvoiceDetail({
    required this.maChiTietHoaDon,
    required this.maHoaDon,
    required this.maSanPham,
    required this.soLuong,
    required this.gia,
  });

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) {
    return InvoiceDetail(
      maChiTietHoaDon: json['ma_chi_tiet_hoa_don'],
      maHoaDon: json['ma_hoa_don'],
      maSanPham: Product.fromJson(json['ma_san_pham']),
      soLuong: json['so_luong'],
      gia: json['gia'],
    );
  }
}


