import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/screen/chitietsanpham.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Screenn extends StatefulWidget {
  final List list; 
  const Screenn({super.key, required this.list});

  @override
  State<Screenn> createState() => _ScreennState();
}
class _ScreennState extends State<Screenn> {
  String selectedCategory = '0';
  List filteredList = [];
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchText = '';
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    filteredList = widget.list;
  }

  void filterProducts(String category) {
    setState(() {
      selectedCategory = category;
      if (category == '0') {
        filteredList = widget.list;
      } else {
        filteredList = widget.list.where((product) {
          return product['ma_loai'].toString() == category;
        }).toList();
      }
    });
  }

  void searchProducts(String query) {
    setState(() {
      _searchText = query;
      filteredList = widget.list.where((product) {
        return product['ten_san_pham']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

void _startListening() async {
  bool available = await _speech.initialize(
    onStatus: (status) => log('Status: $status'),
    onError: (error) => log('Error: $error'),
  );

  if (available) {
   
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
       title: Row(
            children: [
              Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: _isListening ? Colors.red : Colors.grey,
              ),
              const SizedBox(width: 10),
              const Text('Vui lòng nói...'),
            ],
          ),
          content: const Text(
              'Hãy nói từ khóa sản phẩm bạn muốn tìm kiếm vào mic.'),
        actions: [],
      ),
    );

    setState(() => _isListening = true);
    
    Future.delayed(const Duration(seconds: 3), () {
      if (Navigator.canPop(context)) {

        Navigator.of(context).pop();
        _stopListening(); 
      }
    });
    

    _speech.listen(
      onResult: (result) {
        setState(() {
          _searchText = result.recognizedWords;
          _textController.text = _searchText;
          searchProducts(_searchText);
          
        });
         
        if (result.recognizedWords.isNotEmpty) {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
             _stopListening(); 
          }
        }
      },
    );
  }
}

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0", "vi_VN");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController, 
                      onChanged: (value) => searchProducts(value),
                      decoration: const InputDecoration(
                        hintText: "Nhập tên sản phẩm...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    onPressed: _isListening ? _stopListening : _startListening,
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryButton('1', 'Pizza', FontAwesomeIcons.pizzaSlice),
                    _buildCategoryButton('2', 'Gà', FontAwesomeIcons.drumstickBite),
                    _buildCategoryButton('3', 'Mỳ', FontAwesomeIcons.bowlRice),
                    _buildCategoryButton('4', 'Thức uống', FontAwesomeIcons.glassMartini),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

                  if (product['loai_khuyen_mai'] == 'PHANTRAM' &&
                      product['gia_tri_khuyen_mai'] != null) {
                    double discount = double.tryParse(product['gia_tri_khuyen_mai']) ?? 0;
                    discountedPrice = originalPrice * (1 - discount / 100);
                    saleLabel = "${discount.toStringAsFixed(0)}% OFF";
                  } else if (product['loai_khuyen_mai'] == 'GIATRI' &&
                      product['gia_tri_khuyen_mai'] != null) {
                    double discountValue = double.tryParse(product['gia_tri_khuyen_mai']) ?? 0;
                    discountedPrice = originalPrice - discountValue;
                    saleLabel = discountValue > 0 ? "SALE SỐC" : "";
                  }

                  return GestureDetector(
                    onTap: () {
                      final updatedProduct =
                                Map<String, dynamic>.from(product);
                            updatedProduct['discountPercentage'] = discountedPrice;
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
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                         
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width / 2,
                            child: Image.network('${AppConstants.BASE_URL}${product['hinh_anh']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                       
                          if (saleLabel.isNotEmpty)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  saleLabel,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                
                          Positioned(
                            bottom: 10,
                            left: 8,
                            right: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['ten_san_pham'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${numberFormat.format(discountedPrice)} VND",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
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

  Widget _buildCategoryButton(String id, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton.icon(
        onPressed: () => filterProducts(id),
        icon: Icon(icon, color: selectedCategory == id ? Colors.orange : Colors.black),
        label: Text(
          title,
          style: TextStyle(color: selectedCategory == id ? Colors.white : Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedCategory == id ? Colors.orange : Colors.grey,
        ),
      ),
    );
  }
}

