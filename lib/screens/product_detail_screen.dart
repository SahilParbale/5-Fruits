import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  // Custom premium organic descriptions for each fruit
  String _getDescription(String name) {
    final descriptions = {
      'Strawberry': 'Naturally sweet, sun-ripened organic strawberries sourced directly from sustainable berry farms in Mahabaleshwar. Perfect for desserts or fresh snacking.',
      'Mango (Regular)': 'Juicy and fragrant premium quality mangoes. Sourced from native orchards and handpicked at absolute peak ripeness for high-grade flavor.',
      'Alphonso Mango': 'The undisputed king of fruits. Exceptionally rich, sweet, and creamy organic Alphonso mangoes, directly imported from premium Devgad orchards.',
      'Apple (Regular)': 'Crisp, juicy, and naturally sweet apples. Cultivated organically in the high-altitude hills of Himachal Pradesh under strict organic guidelines.',
      'Washington Apple': 'Ultra-premium crisp imported Washington apples. Known for their deep red color, firm crunch, and beautifully balanced sweet-tart profile.',
      'Banana (Robusta)': 'Naturally sweet and highly nutritious organic Robusta bananas. Sourced from local biodiverse farms and ripened naturally without chemical accelerators.',
      'Orange': 'Bursting with zesty, refreshingly sweet juice. High-vitamin organic oranges handpicked from sunny citrus groves of Nagpur.',
      'Grapes': 'Sweet, seedless organic grapes with a beautiful taut snap. Grown in organic vineyards in Nashik and carefully chilled to lock in peak freshness.',
      'Kiwi': 'Zesty and exotic kiwis with a vibrant emerald flesh. Sourced from pristine orchards and packed with antioxidants and clean organic goodness.',
      'Peach': 'Velvety-soft, exceptionally fragrant premium stone peaches. Grown sustainably in organic orchards for a melt-in-your-mouth flavor.',
      'Sitaphal': 'Rich, custard-like organic Sitaphal (Sugar Apple) handpicked from sustainable local trees. Features a sweet, creamy pulp.',
      'Jamun': 'Pesticide-free wild organic Jamun berries. Sourced sustainably from local forest groves, celebrated for their unique tart sweetness and wellness benefits.',
      'Pear': 'Subtly sweet and exceptionally juicy organic pears. Soft, aromatic flesh sourced directly from the fruit growers of Kashmir.',
      'Dragon Fruit': 'A visually stunning exotic organic dragon fruit. Features a mildly sweet, refreshing taste and delicate crunch from sustainable tropical farms.',
      'Avocado': 'Rich, buttery, and exceptionally smooth organic Haas avocados. Perfectly creamy and packed with healthy monounsaturated fats.',
      'Blueberry': 'Plump, antioxidant-rich organic blueberries. Grown in highly scrutinized conditions to deliver a deep, sweet, and nutritious burst.',
    };

    return descriptions[name] ?? 'Naturally grown, hand-selected organic ${name.toLowerCase()} sourced directly from certified sustainable organic farms. Carefully washed, packed, and delivered fresh to preserve vitamins and pure taste.';
  }

  @override
  Widget build(BuildContext context) {
    final price = (widget.product['price'] as num).toDouble();
    final image = widget.product['image'] as String;
    final name = widget.product['name'] as String;
    final size = widget.product['size'] as String;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Image Header
                Stack(
                  children: [
                    Container(
                      height: 380,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 4),
                          )
                        ]
                      ),
                      child: Hero(
                        tag: 'product_image_$name',
                        child: Padding(
                          padding: const EdgeInsets.only(top: 80, bottom: 40, left: 40, right: 40),
                          child: image.startsWith('http')
                              ? Image.network(image, fit: BoxFit.contain)
                              : Image.asset(image, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) {
                                  return const Center(child: Icon(Icons.image_not_supported, size: 64, color: AppColors.mutedText));
                                }),
                        ),
                      ),
                    ),
                    // Navigation top bar
                    Positioned(
                      top: 50,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Custom back button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black.withOpacity(0.05)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  )
                                ],
                              ),
                              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.primaryText),
                            ),
                          ),
                          // Custom favorite button
                          Consumer<FavoritesProvider>(
                            builder: (context, favorites, child) {
                              final isFav = favorites.isFavorite(name);
                              return GestureDetector(
                                onTap: () => favorites.toggleFavorite(widget.product),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    size: 22,
                                    color: isFav ? const Color(0xFFFF7B6A) : AppColors.primaryText,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // 2. Product Details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black.withOpacity(0.15)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.workspace_premium, size: 14, color: Color(0xFFE65100)),
                                const SizedBox(width: 4),
                                Text(
                                  'ORGANIC BOUTIQUE',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFE65100),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.amber.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  '4.9 (124 Ratings)',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF8B6B00),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Name & Size
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: AppTextStyles.headlineMedium.copyWith(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Net Volume: $size',
                                  style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          // Price
                          Text(
                            '₹${price.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryText,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Delivery promise banner
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.stroke),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flash_on, color: Color(0xFFE65100), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Guaranteed fresh delivery within 30 Minutes',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: const Color(0xFFE65100),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Description header
                      Text(
                        'Product Profile',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Description Text
                      Text(
                        _getDescription(name),
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 14,
                          height: 1.6,
                          color: const Color(0xFF5A5A5A),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Quantity Selector Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity Selection',
                            style: AppTextStyles.titleMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // Pill-shaped Quantity selector
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: AppColors.stroke),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                )
                              ]
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_quantity > 1) {
                                      setState(() {
                                        _quantity--;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFADE8F4),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.remove, size: 16, color: AppColors.primaryGreen),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '$_quantity',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _quantity++;
                                    });
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add, size: 16, color: const Color(0xFFE65100)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 140), // Spacing for sticky bottom button
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Sticky Bottom CTA Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32, top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final cart = Provider.of<CartProvider>(context, listen: false);
                        for (int i = 0; i < _quantity; i++) {
                          cart.addItem(
                            name,
                            name,
                            price,
                            image,
                            size,
                          );
                        }
                        
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: const Color(0xFFE65100), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Added $_quantity $name to cart!',
                                  style: GoogleFonts.poppins(color: const Color(0xFFE65100), fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color(0xFFE65100),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        );
                        
                        Navigator.pop(context); // Go back after adding to cart
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumLinearGradient,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Add To Cart  •  ₹${(price * _quantity).toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFE65100),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
