import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/address_provider.dart';

class CategoriesScreen extends StatefulWidget {
  final Function(String) onCategorySelect;
  final VoidCallback onBack;
  final VoidCallback onNavigateToCart;

  const CategoriesScreen({
    super.key,
    required this.onCategorySelect,
    required this.onBack,
    required this.onNavigateToCart,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Colors extracted from the image for category backgrounds
    final List<Map<String, dynamic>> allCategories = [
      {'name': 'Citrus', 'image': 'assets/images/citrus.png', 'color': const Color(0xFFFFF4D1)},
      {'name': 'Seasonal', 'image': 'assets/images/seasonal.png', 'color': const Color(0xFFFFF8E1)},
      {'name': 'Berries', 'image': 'assets/images/berries.png', 'color': const Color(0xFFFCE4EC)},
      {'name': 'Stone', 'image': 'assets/images/stone.png', 'color': const Color(0xFFFFF3E0)},
      {'name': 'Melons', 'image': 'assets/images/melons.png', 'color': const Color(0xFFE8F5E9)},
      {'name': 'Pomes', 'image': 'assets/images/pomes.png', 'color': const Color(0xFFF3E5F5)},
      {'name': 'Combos', 'image': 'assets/images/combos.png', 'color': const Color(0xFFFFFDE7)},
      {'name': 'Exotic', 'image': 'assets/images/exotic.png', 'color': const Color(0xFFE0F2F1)},
      {'name': 'Dry', 'image': 'assets/images/dry_fruits.png', 'color': const Color(0xFFEFEBE9)},
      {'name': 'Tropical', 'image': 'assets/images/tropical.png', 'color': const Color(0xFFE1F5FE)},
      {'name': 'Organic', 'image': 'assets/images/organic.png', 'color': const Color(0xFFF1F8E9)},
      {'name': 'Ready-to-eat', 'image': 'assets/images/ready_to_eat.png', 'color': const Color(0xFFE3F2FD)},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
          // 1. Pinned Header (Address and Search)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverHeaderDelegate(
              minHeight: 70, // Exact replica of home screen
              maxHeight: 70,
              child: Container(
                color: AppColors.background,
                padding: const EdgeInsets.only(top: 12),
                child: _buildHeader(),
              ),
            ),
          ),
          
          // 2. Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
              child: Text(
                'Categories',
                style: AppTextStyles.titleLarge.copyWith(
                  color: const Color(0xFF3B3B3B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 3. Categories Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = allCategories[index];
                  return _buildCategoryCard(
                    category['name'] as String,
                    category['color'] as Color,
                    category['image'] as String,
                  );
                },
                childCount: allCategories.length,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(6), // Internal spacing like navbar
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30), // Rounded pill
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 18), // Left spacing for address
            Expanded(
              child: Consumer<AddressProvider>(
                builder: (context, addressProvider, child) {
                  final defaultAddress = addressProvider.addresses.firstWhere(
                    (addr) => addr.isDefault,
                    orElse: () => addressProvider.addresses.first,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        defaultAddress.address.split(',').take(2).join(', '),
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF3B3B3B), // Match plus button color
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        defaultAddress.label,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: widget.onNavigateToCart,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppColors.premiumLinearGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 22, color: Colors.white),
                    const SizedBox(width: 8),
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 2), // Slight optical adjustment
                          child: Text(
                            '${cart.itemCount < 10 ? '0' : ''}${cart.itemCount}',
                            style: GoogleFonts.barlowCondensed(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              height: 1.0, // Tighten line height to remove extra padding
                            ),
                          ),
                        );
                      },
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

  Widget _buildCategoryCard(String name, Color bgColor, String imagePath) {
    return GestureDetector(
      onTap: () => widget.onCategorySelect(name),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              // Top part (Image)
              Expanded(
                flex: 7, // 70% height
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Bottom part (Name)
              Expanded(
                flex: 3, // 30% height
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      name,
                      style: GoogleFonts.dmSans(
                        color: const Color(0xFF3B3B3B),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
