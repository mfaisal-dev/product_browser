import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

enum RelatedProductsStatus { initial, loading, success, error }

class RelatedProductsProvider extends ChangeNotifier {
  final ProductRepository repository;

  RelatedProductsProvider(this.repository);

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  RelatedProductsStatus _status = RelatedProductsStatus.initial;
  RelatedProductsStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _currentCategory;
  int _currentProductId = -1;

  Future<void> fetchRelatedProducts({
    required String category,
    required int currentProductId,
    int limit = 10,
  }) async {
    // Don't fetch if same category and already loaded
    if (_currentCategory == category && _products.isNotEmpty) {
      return;
    }

    _currentCategory = category;
    _currentProductId = currentProductId;
    _status = RelatedProductsStatus.loading;
    notifyListeners();

    try {
      final fetchedProducts = await repository.fetchProductsByCategory(
        category: category,
        limit: limit,
      );

      // Filter out the current product and limit to 6 items
      _products = fetchedProducts
          .where((product) => product.id != currentProductId)
          .take(6)
          .toList();

      _status = RelatedProductsStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _status = RelatedProductsStatus.error;
    }

    notifyListeners();
  }

  void clear() {
    _products = [];
    _currentCategory = null;
    _currentProductId = -1;
    _status = RelatedProductsStatus.initial;
    notifyListeners();
  }
}