import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'dart:async';

import '../widgets/search_app_bar.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<ProductProvider>();

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        provider.status == ProductStatus.success &&
        !provider.isFetchingMore) {
      provider.fetchProducts();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<ProductProvider>().search(value);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ProductProvider>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SearchAppBar(
        title: "Product Browser",
        searchController: _searchController,
        onSearchChanged: _onSearchChanged,
        isSearching: provider.isSearching, // Still pass this if needed for any future functionality
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search products by title...",
                hintStyle: TextStyle(
                  color: theme.hintColor.withOpacity(0.7),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: provider.isSearching
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: _clearSearch,
                )
                    : null,
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Search Result Count
          if (provider.isSearching && provider.products.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.05),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                  ),
                ),
              ),
              child: Text(
                'Found ${provider.products.length} ${provider.products.length == 1 ? 'product' : 'products'} for "${provider.searchQuery}"',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: theme.primaryColor,
                ),
              ),
            ),

          // Main Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: provider.refresh,
              color: theme.primaryColor,
              backgroundColor: theme.cardColor,
              child: Builder(
                builder: (_) {
                  // Loading State
                  if (provider.status == ProductStatus.loading &&
                      provider.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading products...',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // Error State
                  if (provider.status == ProductStatus.error) {
                    final isNetworkError = provider.errorType?.contains('network') ?? false;
                    final isTimeoutError = provider.errorType?.contains('timeout') ?? false;

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Different icons for different error types
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isNetworkError
                                    ? Colors.orange.withOpacity(0.1)
                                    : isTimeoutError
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isNetworkError
                                    ? Icons.wifi_off
                                    : isTimeoutError
                                    ? Icons.timer_off
                                    : Icons.error_outline,
                                size: 48,
                                color: isNetworkError
                                    ? Colors.orange
                                    : isTimeoutError
                                    ? Colors.blue
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              isNetworkError
                                  ? 'No Internet Connection'
                                  : isTimeoutError
                                  ? 'Connection Timeout'
                                  : 'Oops! Something went wrong',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              provider.errorMessage ?? "Error loading products",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),

                            // Helpful tips based on error type
                            if (isNetworkError) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.hintColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: const [
                                    Row(
                                      children: [
                                        Icon(Icons.wifi, size: 16),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Check if Wi-Fi or mobile data is turned on',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.signal_cellular_alt, size: 16),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Ensure you have an active internet connection',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.airplanemode_inactive, size: 16),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Try turning Airplane mode on/off',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ] else if (isTimeoutError) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.hintColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'The server is taking too long to respond. This might be due to a slow connection or server issues.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Retry button
                            ElevatedButton.icon(
                              onPressed: provider.refresh,
                              icon: const Icon(Icons.refresh),
                              label: const Text("Try Again"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Empty State
                  if (provider.products.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: theme.hintColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                provider.isSearching
                                    ? Icons.search_off
                                    : Icons.inbox,
                                size: 64,
                                color: theme.hintColor,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              provider.isSearching
                                  ? "No results found"
                                  : "No products available",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              provider.isSearching
                                  ? "We couldn't find any products matching '${provider.searchQuery}'"
                                  : "There are no products to display at the moment",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                            if (provider.isSearching) ...[
                              const SizedBox(height: 24),
                              OutlinedButton.icon(
                                onPressed: _clearSearch,
                                icon: const Icon(Icons.clear),
                                label: const Text('Clear search'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: theme.primaryColor,
                                  side: BorderSide(color: theme.primaryColor),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  // Products List
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.products.length +
                        (provider.isFetchingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= provider.products.length) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Loading more...',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final product = provider.products[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProductCard(product: product),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}