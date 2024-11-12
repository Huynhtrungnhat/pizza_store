import 'package:flutter/material.dart';

class SuaDiaChi extends StatefulWidget {
  @override
  _SuaDiaChiState createState() => _SuaDiaChiState();
}

class _SuaDiaChiState extends State<SuaDiaChi> {
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController name = TextEditingController();
  TextEditingController sodienthoai = TextEditingController();
  TextEditingController diachi = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sửa Thông Tin Người Nhận Hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: sodienthoai,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: diachi,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ giao hàng',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã lưu thông tin')),
                    );
                  }
                },
                child: Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
