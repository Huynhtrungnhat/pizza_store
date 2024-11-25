import 'package:flutter/material.dart';
import 'package:pizza_store/models/nhanvienModel.dart';
import 'package:pizza_store/screen/fechdatakhhpadon.dart';


class EditNhanVienScreen extends StatefulWidget {
  final NhanVien nhanVien;

  EditNhanVienScreen({required this.nhanVien});

  @override
  _EditNhanVienScreenState createState() => _EditNhanVienScreenState();
}

class _EditNhanVienScreenState extends State<EditNhanVienScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _tenController;
  late TextEditingController _ngaySinhController;
  late TextEditingController _diaChiController;
  late TextEditingController _emailController;
  late TextEditingController _sdtController;
  int _gioiTinh = 1;
  int _trangThai = 1;

  @override
  void initState() {
    super.initState();
    _tenController = TextEditingController(text: widget.nhanVien.tenNhanVien);
    _ngaySinhController = TextEditingController(text: widget.nhanVien.ngaySinh);
    _diaChiController = TextEditingController(text: widget.nhanVien.diaChi);
    _emailController = TextEditingController(text: widget.nhanVien.email);
    _sdtController = TextEditingController(text: widget.nhanVien.sdt);
    _gioiTinh = widget.nhanVien.gioiTinh;
    _trangThai = widget.nhanVien.trangThai;
  }

  @override
  void dispose() {
    _tenController.dispose();
    _ngaySinhController.dispose();
    _diaChiController.dispose();
    _emailController.dispose();
    _sdtController.dispose();
    super.dispose();
  }

  Future<void> _updateNhanVien() async {
    if (_formKey.currentState!.validate()) {
      NhanVien updatedNhanVien = NhanVien(
        maNhanVien: widget.nhanVien.maNhanVien,
        tenNhanVien: _tenController.text,
        maLoaiNhanVien: widget.nhanVien.maLoaiNhanVien,
        ngaySinh: _ngaySinhController.text,
        gioiTinh: _gioiTinh,
        diaChi: _diaChiController.text,
        email: _emailController.text,
        sdt: _sdtController.text,
        trangThai: _trangThai,
      );

      final success = await ApiService().updateNhanVien(updatedNhanVien);

      if (success) {
       
        Navigator.pop(context, updatedNhanVien); 
      } 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa thông tin nhân viên'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tenController,
                decoration: InputDecoration(labelText: 'Tên nhân viên'),
                validator: (value) =>
                    value!.isEmpty ? 'Tên không được để trống' : null,
              ),
              TextFormField(
                controller: _ngaySinhController,
                decoration: InputDecoration(labelText: 'Ngày sinh'),
                validator: (value) =>
                    value!.isEmpty ? 'Ngày sinh không được để trống' : null,
              ),
              DropdownButtonFormField<int>(
                value: _gioiTinh,
                decoration: InputDecoration(labelText: 'Giới tính'),
                items: [
                  DropdownMenuItem(value: 1, child: Text('Nam')),
                  DropdownMenuItem(value: 0, child: Text('Nữ')),
                ],
                onChanged: (value) {
                  setState(() {
                    _gioiTinh = value!;
                  });
                },
              ),
              TextFormField(
                controller: _diaChiController,
                decoration: InputDecoration(labelText: 'Địa chỉ'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _sdtController,
                decoration: InputDecoration(labelText: 'Số điện thoại'),
              ),
              Row(
              children: [
                Text('Trạng thái: '),
                Switch(
                  value: _trangThai == 1,
                  onChanged: (value) {
                    setState(() {
                      _trangThai = value ? 1 : 0;
                    });
                  },
                ),
              ],
            ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateNhanVien,
                child: Text('Cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
