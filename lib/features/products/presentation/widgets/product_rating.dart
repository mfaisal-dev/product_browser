import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class ProductRating extends StatelessWidget {
  final ProductModel product;

  const ProductRating({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    if (product.rating == null) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.star,
            color: Colors.amber,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          product.rating!.toStringAsFixed(1),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '/ 5',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
          ),
        ),
      ],
    );
  }
}