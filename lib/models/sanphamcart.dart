import 'sanphammodel.dart';

class Cart {
  List<Product> items = [];

  void addsanpham(Product product) {
    items.add(product);
  }

  double getTotalPrice() {
    double total = 0;
    for (var item in items) {
      total += item.gia * item.so_luong_ton_kho; // Tính tổng giá
    }
    return total;
  }
}

// Tạo một instance của Cart
Cart cart = Cart();
