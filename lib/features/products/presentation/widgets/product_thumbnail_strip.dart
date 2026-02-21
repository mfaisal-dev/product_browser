import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import 'fullscreen_image_gallery.dart';

class ProductThumbnailStrip extends StatelessWidget {
  final ProductModel product;

  const ProductThumbnailStrip({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    if (product.images.length <= 1) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Images',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: product.images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return _buildThumbnailItem(context, theme, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailItem(BuildContext context, ThemeData theme, int index) {
    return GestureDetector(
      onTap: () => _showFullscreenGallery(context, index),
      child: Container(
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: index == 0
                ? theme.primaryColor
                : theme.dividerColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            product.images[index],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: theme.hintColor.withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: theme.hintColor.withOpacity(0.1),
                child: Icon(
                  Icons.broken_image,
                  size: 30,
                  color: theme.hintColor,
                ),
              );
            },
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