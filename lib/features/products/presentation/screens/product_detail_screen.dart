import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../providers/related_products_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/product_info_header.dart';
import '../widgets/product_rating.dart';
import '../widgets/product_description.dart';
import '../widgets/product_thumbnail_strip.dart';
import '../widgets/product_action_buttons.dart';
import '../widgets/related_products.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: product.title,
      ),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider(
          create: (context) => RelatedProductsProvider(
            context.read<ProductRepository>(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Carousel
              ProductImageCarousel(
                product: product,
                height: size.height * 0.3,
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductInfoHeader(product: product),
                    const SizedBox(height: 16),
                    ProductRating(product: product),
                    const SizedBox(height: 16),
                    ProductDescription(description: product.description),
                    const SizedBox(height: 20),
                    if (product.images.length > 1) ...[
                      ProductThumbnailStrip(product: product),
                      const SizedBox(height: 20),
                    ],
                    ProductActionButtons(product: product),
                  ],
                ),
              ),

              // Related Products Section
              const SizedBox(height: 20),
              RelatedProducts(currentProduct: product),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}