             //import 'dart:ffi';
            import 'package:flutter/material.dart';
            import 'package:intl/intl.dart';
            import 'package:pizza_store/api/controller.dart';
            import 'package:pizza_store/login/login.dart';
            import 'package:pizza_store/models/sanphamcart.dart';
            import 'package:pizza_store/models/sanphammodel.dart';
            import 'package:pizza_store/statusgiohang/loadsave.dart';
            import 'package:shared_preferences/shared_preferences.dart';
            import '../navigationbottom/home_navigationbar.dart';

            class ProductDetailPage extends StatefulWidget {
              final Map<String, dynamic> product;

              ProductDetailPage({super.key, required this.product});

              @override
              _ProductDetailPageState createState() => _ProductDetailPageState();
            }

            class _ProductDetailPageState extends State<ProductDetailPage> {
              int quantity = 1;
              String selectedSize = 'Cỡ 9 inch';
              String selectedebanh = "Đế Vừa Bột Tươi";
              String maloaigg = "";

              void incrementQuantity() {
                setState(() {
                  quantity++;
                });
              }

              Future<bool> checkLoginStatus() async {
                final prefs = await SharedPreferences.getInstance();
                bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
                return isLoggedIn;
              }

              void decrementQuantity() {
                if (quantity > 1) {
                  setState(() {
                    quantity--;
                  });
                }
              }

              @override
              void initState() {
                super.initState();
                checkLoginStatus();
              }

              void addToCart(String displayPrice) async {
                bool isLoggedIn = await checkLoginStatus();

                if (!isLoggedIn) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                    (route) => false,
                  );
                } else {
                  double finalPrice = double.tryParse(displayPrice) ?? 0.0;
                  if (selectedSize == 'Cỡ 12 inch') {
                    finalPrice += 100000;
                  }

                  Product product = Product(
                    ma_san_pham: widget.product['ma_san_pham'],
                    ten_san_pham: widget.product['ten_san_pham'],
                    gia: double.tryParse(displayPrice) ?? 0.0,
                    so_luong_ton_kho: quantity,
                    hinh_anh: widget.product['hinh_anh'],
                    mo_ta: widget.product['mo_ta'] ?? '',
                    ma_loai: widget.product['ma_loai'],
                    selectedSize: selectedSize,
                    selectedebanh: selectedebanh,
                  );
                  cart.addsanpham(product);
                  await saveCartToSharedPreferences(cart.items);
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurveBar(),
                    ),
                    (route) => false,
                  );
                }
              }

              @override
              Widget build(BuildContext context) {
                final numberFormat = NumberFormat("#,##0", "vi_VN");

                double originalPrice = double.tryParse(widget.product['gia']) ?? 0.0;
                double discountedPrice = originalPrice;
                String saleLabel = "";
                if (widget.product['loai_khuyen_mai'] == 'PHANTRAM' &&
                    widget.product['gia_tri_khuyen_mai'] != null) {
                  double discount =
                      double.tryParse(widget.product['gia_tri_khuyen_mai']) ?? 0;
                  discountedPrice = originalPrice * (1 - discount / 100);
                  saleLabel = "${discount.toStringAsFixed(0)}% OFF";
                } else if (widget.product['loai_khuyen_mai'] == 'GIATRI' &&
                    widget.product['gia_tri_khuyen_mai'] != null) {
                  double discountValue =
                      double.tryParse(widget.product['gia_tri_khuyen_mai']) ?? 0;
                  discountedPrice = originalPrice - discountValue;
                  saleLabel = discountValue > 0 ? "SALE SỐC" : "";
                }

                if (selectedSize == 'Cỡ 12 inch') {
                  discountedPrice += 100000;
                }

                double displayPrice = discountedPrice * quantity;

                String formattedPrice = numberFormat.format(displayPrice);
                String discountInfo = '';

                return Scaffold(
                  appBar: AppBar(
                    title: Text("Chi tiết sản phẩm"),
                    centerTitle: true,
                    backgroundColor: Colors.orange,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 500,
                          child: Image.network(
                            '${AppConstants.BASE_URL}${widget.product['hinh_anh']}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            widget.product['ten_san_pham'],
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 8),
                        if (widget.product['ma_loai'] == 1) ...[
                          SizedBox(height: 8),
                          Text('Chọn kích cỡ:', style: TextStyle(fontSize: 18)),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedSize == 'Cỡ 9 inch'
                                          ? Colors.blue
                                          : Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedSize = 'Cỡ 9 inch';
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          color: selectedSize == 'Cỡ 9 inch'
                                              ? Colors.blue
                                              : Colors.black,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Cỡ 9 inch',
                                          style: TextStyle(
                                            color: selectedSize == 'Cỡ 9 inch'
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedSize == 'Cỡ 12 inch'
                                          ? Colors.blue
                                          : Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedSize = 'Cỡ 12 inch';
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          color: selectedSize == 'Cỡ 12 inch'
                                              ? Colors.blue
                                              : Colors.black,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Size Cỡ 12 inch',
                                          style: TextStyle(
                                            color: selectedSize == 'Cỡ 12 inch'
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Chọn đế bánh:', style: TextStyle(fontSize: 18)),
                          // Các tùy chọn đế bánh
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedebanh == 'Đế Dày Bột Tươi'
                                          ? Colors.blue
                                          : Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedebanh = 'Đế Dày Bột Tươi';
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.local_pizza,
                                          color: selectedebanh == 'Đế Dày Bột Tươi'
                                              ? Colors.blue
                                              : Colors.black,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Đế Dày Bột Tươi',
                                          style: TextStyle(
                                            color: selectedebanh == 'Đế Dày Bột Tươi'
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedebanh == 'Đế Vừa Bột Tươi'
                                          ? Colors.blue
                                          : Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedebanh = 'Đế Vừa Bột Tươi';
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.local_pizza,
                                          color: selectedebanh == 'Đế Vừa Bột Tươi'
                                              ? Colors.blue
                                              : Colors.black,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Đế Vừa Bột Tươi',
                                          style: TextStyle(
                                            color: selectedebanh == 'Đế Vừa Bột Tươi'
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedebanh == 'Đế Mỏng Giòn'
                                          ? Colors.blue
                                          : Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedebanh = 'Đế Mỏng Giòn';
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.local_pizza,
                                          color: selectedebanh == 'Đế Mỏng Giòn'
                                              ? Colors.blue
                                              : Colors.black,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Đế Mỏng Giòn',
                                          style: TextStyle(
                                            color: selectedebanh == 'Đế Mỏng Giòn'
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        SizedBox(height: 8),
                        Text(
                          'Mô tả :',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.product['mo_ta'] ?? 'Không có mô tả',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 16),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: decrementQuantity),
                                    Text('$quantity', style: TextStyle(fontSize: 20)),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: incrementQuantity,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Tổng cộng ',
                                        style:
                                            TextStyle(color: Colors.black, fontSize: 16)),
                                    Text('$displayPrice VND',
                                        style: TextStyle(color: Colors.red, fontSize: 20)),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () => addToCart(formattedPrice),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: Text(
                                'Thêm vào giỏ hàng',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
