import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewProvider with ChangeNotifier {
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get reviews => _reviews;
  bool get isLoading => _isLoading;

  Future<void> fetchReviews(int productId) async {
    if (_isLoading) {
      print('Already fetching reviews, skipping...');
      return;
    }

    _isLoading = true;
    print('Fetching reviews...');
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://192.168.149.84:3004/products/$productId/reviews'),
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response data: $data');
        _reviews = List<Map<String, dynamic>>.from(data['data']);
      } else {
        _reviews = [];
        print('Failed to load reviews: ${response.statusCode}');
      }
    } catch (error) {
      _reviews = [];
      print('Error occurred: $error');
    }

    _isLoading = false;
    print('Fetching completed');
    notifyListeners();
  }
}
