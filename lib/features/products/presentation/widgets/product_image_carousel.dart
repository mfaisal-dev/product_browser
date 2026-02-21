import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import 'fullscreen_image_gallery.dart';

class ProductImageCarousel extends StatelessWidget {
  final ProductModel product;
  final double height;

  const ProductImageCarousel({
    super.key,
    required this.product,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: height,
      color: theme.cardColor,
      child: Stack(
        children: [
          // Swipeable PageView
          PageView.builder(
            itemCount: product.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showFullscreenGallery(context, index),
                child: Center(
                  child: Image.network(
                    product.images[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildImageLoader(theme);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImageError(theme);
                    },
                  ),
                ),
              );
            },
          ),

          // Image counter
          Positioned(
            top: 16,
            right: 16,
            child: _buildImageCounter(),
          ),

          // Navigation hints for multiple images
          if (product.images.length > 1) ...[
            _buildLeftNavigationHint(),
            _buildRightNavigationHint(),
          ],
        ],
      ),
    );
  }

  Widget _buildImageLoader(ThemeData theme) {
    return Center(
      child: CircularProgressIndicator(
        color: theme.primaryColor,
      ),
    );
  }

  Widget _buildImageError(ThemeData theme) {
    return Container(
      color: theme.hintColor.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image,
              size: 48,
              color: theme.hintColor,
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.photo_library,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${product.images.length}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftNavigationHint() {
    return Positioned(
      left: 8,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildRightNavigationHint() {
    return Positioned(
      right: 8,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _showFullscreenGallery(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => FullscreenImageGallery(
        product: product,
        initialIndex: initialIndex,
      ),
    );
  }
}