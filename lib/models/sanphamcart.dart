import 'package:pizza_store/models/sanphammodel.dart';

class Cart {
  List<Product> items = [];

  void addsanpham(Product product) {
    // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    int index = items.indexWhere((item) => item.ten_san_pham == product.ten_san_pham);

    if (index != -1) {
      // Nếu sản phẩm đã có, tăng số lượng
      items[index].so_luong_ton_kho += product.so_luong_ton_kho;
    } else {
      // Nếu sản phẩm chưa có, thêm sản phẩm mới vào giỏ hàng
      items.add(product);
    }
  }

  void updateQuantity(Product product, int newQuantity) {
    int index = items.indexWhere((item) => item.ten_san_pham == product.ten_san_pham);
    if (index != -1) {
      if (newQuantity > 0) {
        // Cập nhật số lượng mới
        items[index].so_luong_ton_kho = newQuantity;
      } else {
        // Nếu số lượng là 0 hoặc ít hơn, xóa sản phẩm khỏi giỏ hàng
        items.removeAt(index);
      }
    }
  }

  double getTotalPrice() {
    double total = 0;
    for (var item in items) {
      total += item.gia * item.so_luong_ton_kho;
    }
    return total;
  }
  double getTotalPricekm() {
    double total = 0;
    for (var item in items) {
      total += item.gia * item.so_luong_ton_kho;
    }
    return total;
  }


  int getTotalQuantity() {
  Set<String> processedProductNames = {};
  int totalQuantity = 0;

  for (var item in items) {
    if (!processedProductNames.contains(item.ten_san_pham)) {
      // Nếu sản phẩm chưa được tính, thêm số lượng vào tổng
      totalQuantity += item.so_luong_ton_kho;
      // Đánh dấu tên sản phẩm đã được xử lý
      processedProductNames.add(item.ten_san_pham);
    }
  }
  return totalQuantity;
}
}

// Tạo một instance của Cart
Cart cart = Cart();
