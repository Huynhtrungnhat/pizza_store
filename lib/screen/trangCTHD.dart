import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/khuyenmaimodel.dart';

Future<List<KhuyenMai>> fetchKhuyenMai() async {
  final response = await http.get(Uri.parse('${AppConstants.khuyenmai}'));

  if (response.statusCode == 201) {
    final List<dynamic> data = jsonDecode(response.body)['khuyen_mai'];
    return data.map((item) => KhuyenMai.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<KhuyenMai>> xoakhuyenmai() async {
  final response = await http.delete(Uri.parse('${AppConstants.khuyenmai}'));

  if (response.statusCode == 20) {
    final List<dynamic> data = jsonDecode(response.body)['khuyen_mai'];
    return data.map((item) => KhuyenMai.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}