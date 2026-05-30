import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Your Favorites', 
          style: GoogleFonts.barlowCondensed(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
                final favorites = favoritesProvider.items;
                
                if (favorites.isEmpty) {
                  return _buildEmptyState(context);
                }

                return GridView.builder(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 120),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.86,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(context, favorites[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final price = (product['price'] as num).toDouble();
    // Mock original price to calculate discount like Blinkit
    final originalPrice = price * 1.15; 
    final discountPercent = ((originalPrice - price) / originalPrice * 100).toInt();
    
    final name = product['name'] as String;
    final size = product['size'] as String;
    final image = product['image'] as String;
    final isAvailable = product['isAvailable'] as bool? ?? true;

    return GestureDetector(
      onTap: () {
        if (!isAvailable) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section (Image and Badges)
            SizedBox(
              height: 120,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 110,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(11),
                        topRight: Radius.circular(11),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(11),
                        topRight: Radius.circular(11),
                      ),
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix(
                            isAvailable
                                ? <double>[
                                    1, 0, 0, 0, 0,
                                    0, 1, 0, 0, 0,
                                    0, 0, 1, 0, 0,
                                    0, 0, 0, 1, 0,
                                  ]
                                : <double>[
                                    0.2126, 0.7152, 0.0722, 0, 0,
                                    0.2126, 0.7152, 0.0722, 0, 0,
                                    0.2126, 0.7152, 0.0722, 0, 0,
                                    0, 0, 0, 1, 0,
                                  ],
                          ),
                          child: Hero(
                            tag: 'product_image_$name',
                            child: image.startsWith('http')
                                ? Image.network(image, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                                : Image.asset(image, fit: BoxFit.cover, width: double.infinity, height: double.infinity, errorBuilder: (context, error, stackTrace) {
                                    return const Center(child: Icon(Icons.image_not_supported_outlined, color: AppColors.mutedText));
                                  }),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Discount Badge
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(11),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        '$discountPercent%\nOFF',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                  // 8 MINS Badge
                  Positioned(
                    bottom: 0,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1F5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 10, color: Colors.green),
                          const SizedBox(width: 2),
                          Text(
                            '8 MINS',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Favorite Heart
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<FavoritesProvider>(context, listen: false).toggleFavorite(product);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFFFF7B6A),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom Section (Metadata and CTA)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF3B3B3B),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      size,
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${price.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF3B3B3B),
                                fontSize: 16,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              '₹${originalPrice.toInt()}',
                              style: AppTextStyles.bodySmall.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[500],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        if (isAvailable)
                          GestureDetector(
                            onTap: () {
                              Provider.of<CartProvider>(context, listen: false).addItem(
                                name,
                                name,
                                price,
                                image,
                                size,
                              );
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added $name to cart',
                                    style: GoogleFonts.barlowCondensed(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: AppColors.primaryGreen,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.inputBackground,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.primaryGreen, width: 1),
                              ),
                              child: const Text(
                                'ADD',
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        else
                          const Padding(
                             padding: EdgeInsets.symmetric(vertical: 6),
                             child: Text('Out of Stock', style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_outline, color: Color(0xFFE65100), size: 64),
          ),
          const SizedBox(height: 24),
          Text(
            'Your boutique wishlist is empty',
            style: GoogleFonts.barlowCondensed(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Explore our collections and save your favorite organic\nproduce to view them here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
