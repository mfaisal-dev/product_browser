import 'package:flutter/material.dart';
import 'package:product_browser/features/products/presentation/providers/related_products_provider.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/products/presentation/providers/product_provider.dart';
import 'features/products/data/repositories/product_repository.dart';
import 'core/network/api_service.dart';
import 'features/products/presentation/providers/theme_provider.dart';
import 'features/products/presentation/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Provide ProductRepository globally
        Provider(
          create: (_) => ProductRepository(ApiService()),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(
            context.read<ProductRepository>(),
          ),
        ),
        ChangeNotifierProvider(create: (_)=> RelatedProductsProvider(context.read<ProductRepository>()))
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Product Browser',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}