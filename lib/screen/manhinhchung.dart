import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/screen/chitietsanpham.dart';

class Screenn extends StatefulWidget {
  final List list;
  const Screenn({super.key, required this.list});

  @override
  State<Screenn> createState() => _ScreennState();
}

class _ScreennState extends State<Screenn> {
  String selectedCategory = 'Tất cả';
  List filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = widget.list; // Khởi tạo danh sách ban đầu
  }

  void filterProducts(String category) {
    setState(() {
      selectedCategory = category;

      // In giá trị để kiểm tra (debugging)
      log('Selected category: $category');

      if (category == 'Tất cả') {
        filteredList = widget.list;
      } else {
        filteredList = widget.list.where((product) {
          // In ra giá trị của ma_loai_san_pham để kiểm tra
          log('Product category: ${product['ma_loai']}');

          // So sánh chuỗi với chuỗi, hoặc số với số
          return product['ma_loai'].toString() == category;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0", "vi_VN");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel Slider
            // Container(
            //   width: double.infinity,
            //   height: MediaQuery.of(context).size.height / 2.5,
            //   child: CarouselSlider(
            //     items: filteredList.map((product) {
            //       return Image(
            //         image: NetworkImage(
            //             "${AppConstants.BASE_URL}${product['hinh_anh']}"),
            //         fit: BoxFit.cover,
            //         width: double.infinity,
            //       );
            //     }).toList(),
            //     options: CarouselOptions(
            //       height: MediaQuery.of(context).size.height / 2.5,
            //       enlargeCenterPage: true,
            //       autoPlay: true,
            //       aspectRatio: 16 / 9,
            //       autoPlayCurve: Curves.fastOutSlowIn,
            //       enableInfiniteScroll: true,
            //       autoPlayAnimationDuration: const Duration(milliseconds: 800),
            //       viewportFraction: 1,
            //     ),
            //   ),
            // ),

            // Buttons to filter products
         Container(
  padding: EdgeInsets.symmetric(vertical: 8),
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,  // Cho phép cuộn ngang
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ElevatedButton(
        //   onPressed: () => filterProducts('Tất cả'),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Icon(
        //         Icons.all_inclusive,
        //         color: selectedCategory == 'Tất cả' ? Colors.white : Colors.black, // Màu icon
        //       ),
        //       SizedBox(width: 8), // Khoảng cách giữa icon và chữ
        //       Text(
        //         'Tất cả',
        //         style: TextStyle(
        //           color: selectedCategory == 'Tất cả' ? Colors.white : Colors.white, // Màu chữ
        //         ),
        //       ),
        //     ],
        //   ),
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: selectedCategory == 'Tất cả' ? Colors.amber[400] : Colors.grey, // Màu nền nút
        //   ),
        // ),
         SizedBox(width: 12), 
        ElevatedButton(
          onPressed: () => filterProducts('1'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.pizzaSlice,
                color: selectedCategory == '1' ? Colors.orange : Colors.black, // Màu icon
              ),
              SizedBox(width: 8),
              Text(
                'pizza',
                style: TextStyle(
                  color: selectedCategory == '1' ? Colors.white : Colors.white, // Màu chữ
                ),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCategory == '1' ? Colors.amber[400] : Colors.grey, // Màu nền nút
          ),
        ),
        SizedBox(width: 12), 
        ElevatedButton(
          onPressed: () => filterProducts('2'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.drumstickBite,
                color: selectedCategory == '2' ? Colors.blue : Colors.black, // Màu icon
              ),
              SizedBox(width: 8),
              Text(
                'Gà',
                style: TextStyle(
                  color: selectedCategory == '2' ? Colors.white : Colors.black, // Màu chữ
                ),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCategory == '2' ?Colors.amber[400]: Colors.grey, // Màu nền nút
          ),
        ),
        SizedBox(width: 12), 
        ElevatedButton(
          onPressed: () => filterProducts('3'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.bowlRice,
                color: selectedCategory == '3' ? Colors.white : Colors.black, // Màu icon
              ),
              SizedBox(width: 8),
              Text(
                'Mỳ',
                style: TextStyle(
                  color: selectedCategory == '3' ? Colors.white : Colors.white, // Màu chữ
                ),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCategory == '3' ? Colors.amber : Colors.grey, // Màu nền nút
          ),
        ),
        SizedBox(width: 12), 
        ElevatedButton(
          onPressed: () => filterProducts('4'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.glassMartini,
                color: selectedCategory == '4' ? Colors.white : Colors.black, // Màu icon
              ),
              SizedBox(width: 8),
              Text(
                'Thức uống',
                style: TextStyle(
                  color: selectedCategory == '4' ? Colors.white : Colors.white, // Màu chữ
                ),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCategory == '4' ? Colors.amber : Colors.grey, // Màu nền nút
          ),
        ),
        // Bạn có thể thêm các nút khác nếu cần
      ],
    ),
  ),
),


            // Product Grid
            Container(
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final product = filteredList[index];
                  double originalPrice = double.tryParse(product['gia']) ?? 0;
                  double discountedPrice = originalPrice;
                  String saleLabel = "";
                  double discountPercentage = 0;

                  // Kiểm tra và xử lý phần trăm giảm giá
                  if (product['loai_khuyen_mai'] == 'PHANTRAM' &&
                      product['gia_tri_khuyen_mai'] != null) {
                    double discount =
                        double.tryParse(product['gia_tri_khuyen_mai']) ?? 0;
                    discountedPrice = originalPrice * (1 - discount / 100);
                    discountPercentage = discount;

                    if (discountedPrice == originalPrice) {
                      saleLabel = "";
                    } else {
                      saleLabel = "${discountPercentage.toStringAsFixed(0)}% OFF";
                    }
                  } else if (product['loai_khuyen_mai'] == 'GIATRI' &&
                      product['gia_tri_khuyen_mai'] != null) {
                    double discountValue =
                        double.tryParse(product['gia_tri_khuyen_mai']) ?? 0;
                    discountedPrice = originalPrice - discountValue;

                    if (discountedPrice < 0) {
                      discountedPrice = 0;
                    }

                    if (discountValue > 0) {
                      saleLabel = "SALE SỐC";
                    }
                  }

                  bool isOutOfStock = product['so_luong_ton_kho'] == 0;

                  return GestureDetector(
                    onTap: isOutOfStock
                        ? null
                        : () {
                            final updatedProduct =
                                Map<String, dynamic>.from(product);
                            updatedProduct['discountPercentage'] = discountPercentage;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailPage(product: updatedProduct),
                              ),
                            );
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isOutOfStock
                            ? Colors.grey.withOpacity(0.5)
                            : Color.fromARGB(255, 215, 169, 0),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 12,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width / 2,
                            child: Image(
                              image: NetworkImage(
                                  '${AppConstants.BASE_URL}${product['hinh_anh']}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (isOutOfStock)
                            Container(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          if (isOutOfStock)
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  color: Colors.black.withOpacity(0.7),
                                  child: Text(
                                    "Hết hàng",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (saleLabel.isNotEmpty)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  saleLabel,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 50,
                            left: 8,
                            right: 8,
                            child: Text(
                              product['ten_san_pham'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Positioned(
                            bottom: 1,
                            left: 8,
                            right: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  discountedPrice != originalPrice
                                      ? '${numberFormat.format(discountedPrice.toInt())} VND'
                                      : '${numberFormat.format(originalPrice.toInt())} VND',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: discountedPrice < originalPrice
                                        ? Colors.red
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (discountedPrice != originalPrice)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          '${numberFormat.format(originalPrice.toInt())} VND',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                    if (discountPercentage > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          " -$discountPercentage%",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
