import 'sanphammodel.dart';

class Cart {
  List<Product> items = [];

  void addItem(Product product) {
    items.add(product);
  }
}