class addproduct {
  int? maSanPham;
  String? tenSanPham;
  String? moTa;
  String? gia;
  int? soLuongTonKho;
  int? maLoaiSanPham;
  String? hinhAnh;
  int? maLoai;
  String? createdAt;
  String? updatedAt;

  addproduct(
      {this.maSanPham,
      this.tenSanPham,
      this.moTa,
      this.gia,
      this.soLuongTonKho,
      this.maLoaiSanPham,
      this.hinhAnh,
      this.maLoai,
      this.createdAt,
      this.updatedAt});

  addproduct.fromJson(Map<String, dynamic> json) {
    maSanPham = json['ma_san_pham'];
    tenSanPham = json['ten_san_pham'];
    moTa = json['mo_ta'];
    gia = json['gia'];
    soLuongTonKho = json['so_luong_ton_kho'];
    maLoaiSanPham = json['ma_loai_san_pham'];
    hinhAnh = json['hinh_anh'];
    maLoai = json['ma_loai'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ma_san_pham'] = this.maSanPham;
    data['ten_san_pham'] = this.tenSanPham;
    data['mo_ta'] = this.moTa;
    data['gia'] = this.gia;
    data['so_luong_ton_kho'] = this.soLuongTonKho;
    data['ma_loai_san_pham'] = this.maLoaiSanPham;
    data['hinh_anh'] = this.hinhAnh;
    data['ma_loai'] = this.maLoai;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
