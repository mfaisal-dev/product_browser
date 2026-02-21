import 'dart:io';
import '../../../../core/network/api_service.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiService apiService;

  ProductRepository(this.apiService);

  Future<List<ProductModel>> fetchProducts({
    required int limit,
    required int skip,
    String? query,
  }) async {
    try {
      if (query != null && query.isNotEmpty) {
        final data = await apiService.get("/products/search?q=$query");
        final List productsJson = data['products'] ?? [];

        final allResults = productsJson
            .map((json) => ProductModel.fromJson(json))
            .toList();

        final filteredResults = allResults
            .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return filteredResults
            .skip(skip)
            .take(limit)
            .toList();
      } else {
        final data = await apiService.get("/products?limit=$limit&skip=$skip");
        final List productsJson = data['products'] ?? [];

        return productsJson
            .map((json) => ProductModel.fromJson(json))
            .toList();
      }
    } on SocketException {
      throw 'network_unavailable';
    } on TimeoutException {
      throw 'timeout';
    } on HttpException catch (e) {
      if (e.message.contains('403')) throw 'forbidden';
      if (e.message.contains('404')) throw 'not_found';
      if (e.message.contains('500')) throw 'server_error';
      throw 'http_error';
    } catch (e) {
      throw 'unknown_error';
    }
  }

  // New method to fetch products by category
  Future<List<ProductModel>> fetchProductsByCategory({
    required String category,
    required int limit,
    int skip = 0,
  }) async {
    try {
      final endpoint = "/products/category/$category?limit=$limit&skip=$skip";
      final data = await apiService.get(endpoint);
      final List productsJson = data['products'] ?? [];

      return productsJson
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on SocketException {
      throw 'network_unavailable';
    } on TimeoutException {
      throw 'timeout';
    } catch (e) {
      throw 'unknown_error';
    }
  }
}

// Add these custom exceptions if not already defined
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
}