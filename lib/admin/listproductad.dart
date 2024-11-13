import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_store/admin/editsapham.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/screen/chitietsanpham.dart';
 // Import trang EditProductPage

class ListAd extends StatefulWidget {
  final List list;
  const ListAd({super.key, required this.list});

  @override
  State<ListAd> createState() => _ListAdState();
}

class _ListAdState extends State<ListAd> {
  TextEditingController searchController = TextEditingController();
  List filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = widget.list; 
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredList = widget.list;
      });
      return;
    }

    setState(() {
      filteredList = widget.list
          .where((product) => product['ten_san_pham']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0", "vi_VN");
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Tìm kiếm sản phẩm...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: filterSearchResults,
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final product = filteredList[index];

                  double originalPrice = (product['gia'] is String)
    ? double.tryParse(product['gia']) ?? 0
    : product['gia'] ?? 0;

                  double discountedPrice = originalPrice;
                  String saleLabel = "";
                  double discountPercentage = 0;

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
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: isOutOfStock
                          ? Colors.grey.withOpacity(0.5)
                          : Color.fromARGB(255, 215, 169, 0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        leading: Image.network(
                          '${AppConstants.BASE_URL}${product['hinh_anh']}',
                          fit: BoxFit.cover,
                          width: 50,
                        ),
                        title: Text(
                          product['ten_san_pham'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
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
                            if (discountedPrice != originalPrice)
                              Text(
                                '${numberFormat.format(originalPrice.toInt())} VND',
                                style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (saleLabel.isNotEmpty)
                              Container(
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
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: isOutOfStock
                                  ? null
                                  : () {
                                      // Chuyển sang trang EditProductPage
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProductPage(product: product),
                                        ),
                                      ).then((updatedProduct) {
                             
                                        if (updatedProduct != null) {
                                          setState(() {
                                            filteredList[index] = updatedProduct;
                                          });
                                        }
                                      });
                                    },
                            ),
                          ],
                        ),
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
