import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/address_provider.dart';
import '../data/fruit_data.dart';
import '../widgets/address_bottom_sheet.dart';
import 'product_detail_screen.dart';
import '../providers/catalog_provider.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToCategories;
  final VoidCallback onNavigateToCart;
  final Function(String) onCategorySelect;

  const HomeScreen({
    super.key,
    required this.onNavigateToCategories,
    required this.onNavigateToCart,
    required this.onCategorySelect,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 1; // Default to Popular
  final List<GlobalKey> _tabKeys = [];

  final List<String> _tabs = ['Flash Sale', 'Popular', 'New Arrival'];
  late PageController _pageController;

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _flashSaleProducts = [
    {
      'name': 'Strawberry',
      'size': '200g pack',
      'price': 90.00,
      'image': 'assets/images/strawberry.png',
    },
    {
      'name': 'Mango (Regular)',
      'size': '1kg',
      'price': 120.00,
      'image': 'assets/images/mango.png',
    },
  ];

  final List<Map<String, dynamic>> _popularProducts = [
    {
      'name': 'Apple (Regular)',
      'size': '1kg',
      'price': 140.00,
      'image': 'assets/images/apple.jpg', 
    },
    {
      'name': 'Banana (Robusta)',
      'size': '1 Dozen',
      'price': 50.00,
      'image': 'assets/images/banana.png', 
    },
    {
      'name': 'Orange',
      'size': '1kg',
      'price': 80.00,
      'image': 'assets/images/orange.png', 
    },
    {
      'name': 'Grapes',
      'size': '1kg',
      'price': 5.99,
      'image': 'assets/images/grapes_purple.png', 
    },
  ];

  final List<Map<String, dynamic>> _newArrivalProducts = [
    {
      'name': 'Kiwi',
      'size': '1 pc',
      'price': 35.00,
      'image': 'assets/images/kiwi.png',
    },
    {
      'name': 'Peach',
      'size': '1kg',
      'price': 180.00,
      'image': 'assets/images/peach.jpg',
    },
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Generate keys for each tab
    for (var i = 0; i < _tabs.length; i++) {
      _tabKeys.add(GlobalKey());
    }

    _pageController = PageController(initialPage: _selectedIndex);

    // Scroll to the selected tab after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedTab();
    });
  }

  void _scrollToSelectedTab() {
    if (_selectedIndex >= 0 && _selectedIndex < _tabKeys.length) {
      final context = _tabKeys[_selectedIndex].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          alignment: 0.5, // Center the item
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final catalogProvider = Provider.of<CatalogProvider>(context);
    final allProducts = catalogProvider.products.isNotEmpty ? catalogProvider.products : FruitData.allFruits;

    final flashSale = allProducts.where((p) => p['category'] == 'Exotic' || p['category'] == 'Combos').toList();
    final popular = allProducts.where((p) => p['category'] == 'Citrus' || p['category'] == 'Pomes' || p['category'] == 'Ready-to-eat').toList();
    final newArrival = allProducts.where((p) => p['category'] == 'Seasonal' || p['category'] == 'Melons' || p['category'] == 'Dry').toList();

    // Fallbacks if any list is empty, so the UI is never blank:
    final displayFlashSale = flashSale.isNotEmpty ? flashSale : allProducts.take((allProducts.length / 3).round()).toList();
    final displayPopular = popular.isNotEmpty ? popular : allProducts.skip((allProducts.length / 3).round()).take((allProducts.length / 3).round()).toList();
    final displayNewArrival = newArrival.isNotEmpty ? newArrival : allProducts.skip(2 * (allProducts.length / 3).round()).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // 1. Address Section (Pinned)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverHeaderDelegate(
                  minHeight: 80, 
                  maxHeight: 80,
                  child: Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildAddressSection(),
                  ),
                ),
              ),
              
              // 2. Search Bar (Pinned)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverHeaderDelegate(
                  minHeight: 74, 
                  maxHeight: 74,
                  child: Container(
                    color: AppColors.background, // Opaque background
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: _buildSearchBar(),
                  ),
                ),
              ),

              // 3. Hero Banner & Categories (Scrolls away)
              if (_searchQuery.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        _buildHeroBanner(),
                        const SizedBox(height: 20),
                        _buildCategoriesSection(context),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

              // 4. Product Tabs (Pinned)
              if (_searchQuery.isEmpty)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverHeaderDelegate(
                    minHeight: 52, 
                    maxHeight: 52,
                    child: Container(
                      color: AppColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _buildProductListHeader(context),
                    ),
                  ),
                ),
            ];
          },
          body: _searchQuery.isNotEmpty
              ? _buildSearchResults()
              : PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                    _scrollToSelectedTab();
                  },
                  children: [
                    _buildProductGridPage(displayFlashSale),
                    _buildProductGridPage(displayPopular),
                    _buildProductGridPage(displayNewArrival),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // User Avatar (Gold-foiled luxury monogram badge)
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                gradient: AppColors.premiumLinearGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ]
              ),
              child: Center(
                child: Text(
                  'SS',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFE65100), // Gold
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Consumer<AddressProvider>(
                builder: (context, addressProvider, child) {
                  final defaultAddress = addressProvider.addresses.firstWhere(
                    (addr) => addr.isDefault,
                    orElse: () => addressProvider.addresses.first,
                  );
                  return GestureDetector(
                    onTap: () => _showAddressBottomSheet(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppColors.primaryGreen),
                            const SizedBox(width: 4),
                            Text(
                              'Deliver to',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.secondaryText,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                defaultAddress.address.split(',').take(2).join(', '),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.primaryText),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Cart Button
            GestureDetector(
              onTap: widget.onNavigateToCart,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppColors.premiumLinearGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 18, color: Color(0xFFE65100)),
                    const SizedBox(width: 6),
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return Text(
                          '${cart.itemCount < 10 ? '0' : ''}${cart.itemCount}',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFE65100),
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
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

  Widget _buildSearchBar() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),
          const Icon(Icons.search, color: Color(0xFFE65100), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search organic fruits...',
                border: InputBorder.none,
                isDense: true,
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondaryText,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Icon(Icons.close, color: AppColors.secondaryText, size: 20),
            )
          else
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Listening for voice search...', style: GoogleFonts.poppins()),
                    backgroundColor: const Color(0xFFE65100),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Icon(Icons.mic, color: AppColors.secondaryText, size: 22),
            ),
          const SizedBox(width: 18),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.premiumLinearGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background subtle circles
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '30 MIN EXPRESS DELIVERY',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFE65100),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Fresh Fruits Delivered\nWithin 30 Minutes',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFE65100),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    widget.onCategorySelect('Organic');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Shop Fresh',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFE65100),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Floating Fruits Image
          Positioned(
            right: 12,
            bottom: 12,
            top: 12,
            child: Transform.rotate(
              angle: 0.05,
              child: SizedBox(
                width: 140,
                child: Image.asset(
                  'assets/images/fruits.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Citrus', 'image': 'assets/images/citrus.png', 'color': const Color(0xFFFFF4D1)},
      {'name': 'Exotic', 'image': 'assets/images/exotic.png', 'color': const Color(0xFFE0F2F1)},
      {'name': 'Berries', 'image': 'assets/images/berries.png', 'color': const Color(0xFFFCE4EC)},
      {'name': 'Stone', 'image': 'assets/images/stone.png', 'color': const Color(0xFFFFF3E0)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Curated Categories', 
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            GestureDetector(
              onTap: widget.onNavigateToCategories,
              child: Text(
                'View All',
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFFE65100),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 138,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return GestureDetector(
                onTap: () => widget.onCategorySelect(cat['name']),
                child: Container(
                  width: 110,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: cat['color'] as Color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              cat['image'] as String,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: Text(
                            cat['name'] as String,
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductListHeader(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 32),
            child: _buildTabItem(title, index),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            key: _tabKeys[index],
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primaryText : AppColors.secondaryText.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 3,
            width: isSelected ? 24 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFFE65100),
              borderRadius: BorderRadius.circular(2),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductGridPage(List<Map<String, dynamic>> products) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildProductCard(products[index]);
          },
        ),
        _buildBottomBanner(),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final price = (product['price'] as num).toDouble();
    final name = product['name'] as String;
    final size = product['size'] as String;
    final image = product['image'] as String;

    return GestureDetector(
      onTap: () {
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
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              blurRadius: 12,
              spreadRadius: 1,
              offset: Offset(0, 6),
              color: Colors.black12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section (Image and Glassmorphic Favorite)
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF), // Pastel warm background for fruit pop
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Hero(
                        tag: 'product_image_$name',
                        child: image.startsWith('http')
                            ? Image.network(image, fit: BoxFit.cover)
                            : Image.asset(image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.image_not_supported_outlined, color: AppColors.mutedText));
                              }),
                      ),
                    ),
                  ),
                  // Glassmorphic Favorite Button
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Consumer<FavoritesProvider>(
                      builder: (context, favorites, child) {
                        final isFav = favorites.isFavorite(name);
                        return GestureDetector(
                          onTap: () {
                            favorites.toggleFavorite(product);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.55),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                                ),
                                child: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? const Color(0xFFFF7B6A) : const Color(0xFF1B1B1B),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Section (Metadata and CTA)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    size,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${price.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryText,
                          fontSize: 18,
                        ),
                      ),
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
                                style: GoogleFonts.poppins(color: const Color(0xFFE65100), fontWeight: FontWeight.bold),
                              ),
                              duration: const Duration(seconds: 2),
                              backgroundColor: const Color(0xFFE65100),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: AppColors.premiumLinearGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: const Icon(Icons.add, color: const Color(0xFFE65100), size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final catalogProvider = Provider.of<CatalogProvider>(context, listen: false);
    final allProducts = catalogProvider.products.isNotEmpty ? catalogProvider.products : FruitData.allFruits;
    final filteredProducts = allProducts.where((p) {
      return p['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: AppColors.secondaryText),
            const SizedBox(height: 16),
            Text(
              'No organic fruits found for "$_searchQuery"',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.secondaryText),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return _buildProductCard(filteredProducts[index]);
      },
    );
  }
  
  Widget _buildBottomBanner() {
    return Container(
      height: 120, 
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 120, top: 24),
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE65100), Color(0xFFE65100)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ORGANIC LIFE',
                  style: GoogleFonts.poppins(color: const Color(0xFFE65100), fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Meal prep with fresh organic greens',
                  style: GoogleFonts.poppins(color: const Color(0xFFE65100), fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B4C70), Color(0xFFB57C9C)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B4C70).withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'HEALTH DIET',
                  style: GoogleFonts.poppins(color: const Color(0xFFF8D7DA), fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Making the most of seasonal fruits',
                  style: GoogleFonts.poppins(color: const Color(0xFFE65100), fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const FractionallySizedBox(
            heightFactor: 0.85,
            child: AddressBottomSheet(),
          ),
        );
      },
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
