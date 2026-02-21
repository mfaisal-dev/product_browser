import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product_model.dart';
import '../providers/related_products_provider.dart';
import 'related_product_card.dart';

class RelatedProducts extends StatelessWidget {
  final ProductModel currentProduct;

  const RelatedProducts({super.key, required this.currentProduct});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final relatedProvider = context.watch<RelatedProductsProvider>();

    // Trigger fetch if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RelatedProductsProvider>();
      if (provider.status == RelatedProductsStatus.initial) {
        provider.fetchRelatedProducts(
          category: currentProduct.category,
          currentProductId: currentProduct.id,
        );
      }
    });

    if (relatedProvider.status == RelatedProductsStatus.loading) {
      return _buildLoadingShimmer(theme);
    }

    if (relatedProvider.status == RelatedProductsStatus.error) {
      return _buildErrorState(theme);
    }

    if (relatedProvider.products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Related Products',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to category page if implemented
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('View all in ${currentProduct.category}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: relatedProvider.products.length,
            itemBuilder: (context, index) {
              final product = relatedProvider.products[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: RelatedProductCard(product: product),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Related Products',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: theme.hintColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: theme.hintColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Could not load related products',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}