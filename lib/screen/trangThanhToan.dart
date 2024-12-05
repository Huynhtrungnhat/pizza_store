import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/sanphamcart.dart';
import 'package:pizza_store/screen/trangTTThanhCong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

class MobilePaymentScreen extends StatefulWidget {
  final double amount;
  final int makh;
  final String pttt;
  final Function() onPaymentSuccess;
  final Function() onPaymentFailure;
  final Function() saveData;

  const MobilePaymentScreen({
    Key? key,
    required this.amount,
    required this.makh,
    required this.pttt,
    required this.onPaymentSuccess,
    required this.onPaymentFailure,
    required this.saveData,
  }) : super(key: key);

  @override
  _MobilePaymentScreenState createState() => _MobilePaymentScreenState();
}

class _MobilePaymentScreenState extends State<MobilePaymentScreen> {
  bool isLoading = true;
  bool isPaymentComplete = false;
  String currentUrl = '';
  late final WebViewController _controller;
  Map<String, dynamic>? userData;
  String? errorMessage;
 // bool isLoading = true;
  String? userId;

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    if (userId != null) {
      final response =
          await http.get(Uri.parse('${AppConstants.khachhang}/$userId'));

      if (response.statusCode == 201) {
        setState(() {
          userData = json.decode(response.body)['khachhang'];
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage =
              'Không thể tải thông tin người dùng. Mã trạng thái: ${response.statusCode}';
        });
      }
    } else {
      setState(() {
        errorMessage = 'ID người dùng không tìm thấy!';
      });
    }

    setState(() {
      isLoading = false;
    });
  }
  Future<void> addHoaDon(String tong_tien, int ma_khach_hang,String today,int manv,String phuongthuctt) async {
    final url = Uri.parse('${AppConstants.hoadon}');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tong_tien': tong_tien, 
        'ma_khach_hang': ma_khach_hang,
        "ngay_lap_hd":tong_tien,
        'ma_nhan_vien': manv,
        'pttt':phuongthuctt,
        'trang_Thai':"Chờ xác nhận",
        'san_pham': cart.items
        }),
    );
  }

  double discount = 0.0;

  double getTotalAfterDiscount() {
    double totalPrice = cart.getTotalPrice();
    double discountAmount = totalPrice * (discount / 100);
    return totalPrice - discountAmount;
  }

  @override
  void initState() {
    super.initState();
    _initializePayment();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              currentUrl = url;
            });
            if (!isPaymentComplete && url.contains('vnpay_return')) {
              _checkPaymentStatus(url);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('tel:') ||
                request.url.startsWith('mailto:') ||
                request.url.startsWith('sms:')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  Future<void> _initializePayment() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}/vnpay_payment'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': widget.amount,
          'bank_code': 'VNBANK',
          'language': 'vn',
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['code'] == '00') {
          String paymentUrl = responseData['data'];
          if (paymentUrl.isNotEmpty) {
            _controller.loadRequest(Uri.parse(paymentUrl));
          } else {
            _showError('Received an empty payment URL.');
          }
        } else {
          _showError('Payment initialization failed: ${responseData['message']}');
        }
      } else {
        _showError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Network error: Unable to initialize payment. $e');
    }
  }

  void _checkPaymentStatus(String url) {
    try {
      final uri = Uri.parse(url);
      final responseCode = uri.queryParameters['vnp_ResponseCode'];
      final transactionStatus = uri.queryParameters['vnp_TransactionStatus'];

      if ((responseCode == '00' || transactionStatus == '00') && !isPaymentComplete) {
        setState(() => isPaymentComplete = true);
        _handlePaymentSuccess();
      } else if (responseCode != null || transactionStatus != null) {
        _handlePaymentFailure(responseCode ?? transactionStatus ?? 'unknown');
      }
    } catch (e) {
      _showError('Error parsing payment response: $e');
    }
  }

  void _handlePaymentSuccess() {
    widget.saveData();
    if (mounted) {
      widget.onPaymentSuccess();
      _showSuccessDialog();
    }
  }

  void _handlePaymentFailure(String errorCode) {
    if (mounted) {
      widget.onPaymentFailure();
      _showFailureDialog(errorCode);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Thành Công'),
            ],
          ),
          content: Text('Bạn đã thanh toán thành công'),
          actions: [
            TextButton(
              child: Text('đóng'),
              onPressed: () {
                 final tongTien =widget.amount.toString();
                   final maKh = widget.makh;
                   final pttt=widget.pttt;
                   String today = '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}';
                addHoaDon(tongTien , maKh,today, 10, pttt);
                  cart.clear();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThanhToanThanhCong(),
                    ),
                  );
                // Navigator.of(context).pop(); // Close dialog
                // Navigator.of(context).pop(); // Return to previous screen
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFailureDialog(String errorCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Payment Failed'),
          ],
        ),
        content: Text(_getErrorMessage(errorCode)),
        actions: [
          TextButton(
            child: Text('Try Again'),
            onPressed: () {
              Navigator.of(context).pop(); 
              _initializePayment(); 
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); 
            },
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _initializePayment,
        ),
      ),
    );
  }


  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case '24':
        return 'Payment was cancelled.';
      default:
        return 'Payment process could not be completed (Error: $errorCode). Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        leading: IconButton(
          icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
          onPressed: () {
            if (!isPaymentComplete) {
              widget.onPaymentFailure();
            }
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
