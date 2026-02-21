import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class ProductActionButtons extends StatelessWidget {
  final ProductModel product;

  const ProductActionButtons({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        // Wishlist Button (Outlined) - Fixed for dark mode
        Expanded(
          child: OutlinedButton(
            onPressed: () => _addToWishlist(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.white : theme.primaryColor,
              side: BorderSide(
                color: isDark ? Colors.white70 : theme.primaryColor,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: isDark ? Colors.transparent : null,
            ),
            child: Text(
              'Wishlist',
              style: TextStyle(
                color: isDark ? Colors.white : theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Add to Cart Button (Elevated) - Fixed for dark mode
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () => _addToCart(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.blue.shade300 : theme.primaryColor,
              foregroundColor: isDark ? Colors.black : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: isDark ? 2 : 0,
            ),
            child: Text(
              'Add to Cart',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _addToWishlist(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use a color that's visible in both modes
    final snackBarColor = isDark ? Colors.green.shade700 : Colors.green;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.favorite,
              size: 18,
              color: isDark ? Colors.white : Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${product.title} added to wishlist',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: snackBarColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use a color that's visible in both modes
    final snackBarColor = isDark ? Colors.green.shade700 : Colors.green;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.shopping_cart,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${product.title} added to cart',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: snackBarColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}