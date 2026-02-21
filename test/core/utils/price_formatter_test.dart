import 'package:flutter_test/flutter_test.dart';
import 'package:product_browser/core/utils/price_formatter.dart';

void main() {
  group('PriceFormatter', () {
    test('should format integer to 2 decimal places', () {
      // Arrange
      int price = 9;

      // Act
      String result = price.toPrice();

      // Assert
      expect(result, '\$9.00');
    });

    test('should format double to 2 decimal places', () {
      // Arrange
      double price = 12.5;

      // Act
      String result = price.toPrice();

      // Assert
      expect(result, '\$12.50');
    });

    test('should format zero correctly', () {
      // Arrange
      int price = 0;

      // Act
      String result = price.toPrice();

      // Assert
      expect(result, '\$0.00');
    });

    test('should round to 2 decimal places', () {
      // Arrange
      double price = 19.999;

      // Act
      String result = price.toPrice();

      // Assert
      expect(result, '\$20.00');
    });
  });
}