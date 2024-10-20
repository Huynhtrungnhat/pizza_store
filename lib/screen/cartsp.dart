import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';

import '../models/sanphamcart.dart';
import '../models/sanphammodel.dart';
import '../home/sanpham.dart';

class ItemList extends StatelessWidget {
  final List list;
  final Cart cart;

  ItemList({super.key, required this.list, required this.cart});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8.0,
                ),
                
                const SizedBox(
                  height: 16.0,
                ),
                CarouselSlider(
                  items: list.map((product) {
                    return Image(image: NetworkImage("${AppConstants.PRODUCT_IMG}${product['hinh_anh']}"), fit: BoxFit.cover);
                  }).toList(),
                  options: CarouselOptions(
                    height: 100.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                )
              ]
            ),
          ),
        ]
    );
    
  }
}
