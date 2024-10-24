import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/screen/chitietsanpham.dart';

class Screenn extends StatefulWidget {
  final List list;
  const Screenn({super.key, required this.list});

  @override
  State<Screenn> createState() => _ScreennState();
}

class _ScreennState extends State<Screenn> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // list=list!.map((product) {
    //                 return Image(image: NetworkImage("${AppConstants.PRODUCT_IMG}${product['hinh_anh']}"), fit: BoxFit.cover);
    //               }).toList();
    // log(list.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                child: CarouselSlider(
                  items: widget.list.map((product) {
                    return Image(
                        image: NetworkImage(
                            "${AppConstants.BASE_URL}${product['hinh_anh']}"),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        );
                  }).toList(),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    viewportFraction: 1,
                  ),
                )),
            Container(
               width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/9*widget.list.length*2+90,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Mỗi hàng có 2 container
                  childAspectRatio: 2 / 2, // Tỉ lệ chiều rộng/chiều cao của mỗi container
                  crossAxisSpacing: 8, // Khoảng cách ngang giữa các container
                  mainAxisSpacing: 8, // Khoảng cách dọc giữa các container
                ),
                padding: EdgeInsets.all(16),
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  final product = widget.list[index];
                  return GestureDetector(
                    onTap: () {
                      // Điều hướng đến ProductDetailPage khi nhấn vào Container
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: Container(
                
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 215, 169, 0),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 12,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                             width: MediaQuery.of(context).size.width,
                             height:MediaQuery.of(context).size.width/3,
                            child: product['hinh_anh'] != ""
                                ? Image(
                                    image: NetworkImage(
                                        '${AppConstants.BASE_URL}${product['hinh_anh']}'),
                                    fit: BoxFit.cover,
                                  )
                                : Text('No image available'),
                          ),
                          Text(
                            product['ten_san_pham'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Giá: ${product['gia']} VND'),
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
