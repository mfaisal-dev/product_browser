import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

enum ProductStatus { initial, loading, success, error }

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;

  ProductProvider(this.repository);

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  ProductStatus _status = ProductStatus.initial;
  ProductStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _errorType; // To track error type for better handling
  String? get errorType => _errorType;

  bool _isFetchingMore = false;
  bool get isFetchingMore => _isFetchingMore;

  final int _limit = 10;
  int _skip = 0;
  bool _hasMore = true;
  String _searchQuery = "";

  bool get isSearching => _searchQuery.isNotEmpty;
  String get searchQuery => _searchQuery;

  // User-friendly error messages map
  String _getUserFriendlyMessage(String error) {
    print('Error type received: $error'); // For debugging

    switch (error) {
      case 'network_unavailable':
        return 'No internet connection. Please check your network and try again.';
      case 'timeout':
        return 'Connection timeout. The server is taking too long to respond.';
      case 'forbidden':
        return 'Access denied. Please check your permissions.';
      case 'not_found':
        return 'Service temporarily unavailable. Please try again later.';
      case 'server_error':
        return 'Server error. Our team has been notified.';
      case 'http_error':
        return 'Unable to connect to the server. Please try again.';
      case 'unknown_error':
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (_isFetchingMore) return;

    if (isRefresh) {
      _skip = 0;
      _hasMore = true;
      _products = [];
      _status = ProductStatus.loading;
      _errorMessage = null;
      _errorType = null;
      notifyListeners();
    }

    if (!_hasMore) return;

    try {
      _isFetchingMore = _skip > 0;
      notifyListeners();

      final newProducts = await repository.fetchProducts(
        limit: _limit,
        skip: _skip,
        query: _searchQuery,
      );

      if (newProducts.length < _limit) {
        _hasMore = false;
      }

      if (isSearching) {
        final existingIds = _products.map((p) => p.id).toSet();
        final uniqueNewProducts = newProducts
            .where((p) => !existingIds.contains(p.id))
            .toList();

        _products.addAll(uniqueNewProducts);
      } else {
        _products.addAll(newProducts);
      }

      _skip += _limit;
      _status = ProductStatus.success;
    } catch (e) {
      print('Caught error in provider: $e'); // For debugging
      _errorType = e.toString(); // Store the raw error type
      _errorMessage = _getUserFriendlyMessage(e.toString());
      _status = ProductStatus.error;
    }

    _isFetchingMore = false;
    notifyListeners();
  }

  void search(String query) {
    final trimmedQuery = query.trim();

    if (_searchQuery != trimmedQuery) {
      _searchQuery = trimmedQuery;
      fetchProducts(isRefresh: true);
    }
  }

  Future<void> refresh() async {
    await fetchProducts(isRefresh: true);
  }

  void clearSearch() {
    if (_searchQuery.isNotEmpty) {
      _searchQuery = "";
      fetchProducts(isRefresh: true);
    }
  }
}