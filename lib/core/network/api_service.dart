import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'https://dummyjson.com';

  Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');

      // Add timeout to prevent infinite waiting
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw HttpException('HTTP ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('No internet connection');
    } on TimeoutException {
      throw TimeoutException('Connection timeout');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }
}

// Add these custom exceptions at the top of the file or in a separate file
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
}