import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/address_provider.dart';
import '../data/fruit_data.dart';
import '../widgets/address_bottom_sheet.dart';

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
  int _selectedIndex = 1; // Default to Popular as shown in image
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // 1. Address Section (Pinned now)
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverHeaderDelegate(
                minHeight: 70, // Height of Address Bar + padding
                maxHeight: 70,
                child: Container(
                  color: AppColors.background,
                  padding: const EdgeInsets.only(top: 12), // Add top padding here instead of Column
                  child: _buildAddressSection(),
                ),
              ),
            ),
            
            // 2. Search Bar (Pinned)
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverHeaderDelegate(
                minHeight: 70, // Height of search bar + padding
                maxHeight: 70,
                child: Container(
                  color: AppColors.background, // Opaque background to hide scrolling content
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: _buildSearchBar(),
                ),
              ),
            ),

            // 3. Categories (Scrolls away)
            if (_searchQuery.isEmpty)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildCategoriesSection(context),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

            // 4. Product Tabs (Pinned)
            if (_searchQuery.isEmpty)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverHeaderDelegate(
                  minHeight: 60, 
                  maxHeight: 60,
                  child: Container(
                    color: AppColors.background,
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
                _buildProductGridPage(_flashSaleProducts),
                _buildProductGridPage(_popularProducts),
                _buildProductGridPage(_newArrivalProducts),
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
                  return GestureDetector(
                    onTap: () => _showAddressBottomSheet(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                defaultAddress.address.split(',').take(2).join(', '),
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontSize: 16,
                                  color: const Color(0xFF3B3B3B),
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF3B3B3B)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          defaultAddress.label,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
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

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search for fruits...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  child: const Icon(Icons.close, color: AppColors.secondaryText, size: 26),
                )
              : const Icon(Icons.search, color: AppColors.secondaryText, size: 26),
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
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

    // Calculate item sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 12.0; // Reduced from 24.0 to align with Header and maximize size
    final gap = 12.0;
    final totalGap = gap * (categories.length - 1);
    final availableWidth = screenWidth - (horizontalPadding * 2) - totalGap;
    final itemSize = availableWidth / categories.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories', 
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: 18,
                  color: const Color(0xFF3B3B3B),
                ),
              ),
              GestureDetector(
                onTap: widget.onNavigateToCategories,
                child: Text(
                  'View All',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondaryText, // Changed from primaryGreen to match Search placeholder
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories.map((cat) {
              return GestureDetector(
                onTap: () => widget.onCategorySelect(cat['name']),
                child: SizedBox(
                  width: itemSize,
                // Height includes the main square part + potentially a bit more if we want
                // strictly square visual for the 'card' or the whole column.
                // The user asked for "square and bigger". 
                // Let's make the *combined* card square-ish.
                // The previous implementation had two separate containers.
                // To make it look like one unified card, we should wrap in one container?
                // But the previous design had specific rounded corners for top/bottom.
                // Let's keep the split but size them to total a square.
                child: Container(
                  height: itemSize, // Enforce square total height
                  decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(16),
                     boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                  ),
                  child: Column(
                    children: [
                      // Top part (Emoji/Color)
                      Expanded(
                        flex: 7, // 70% height
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cat['color'] as Color,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              cat['image'] as String,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
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
                              bottomLeft: Radius.circular(16), // Match main radius
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              cat['name'] as String,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                color: const Color(0xFF3B3B3B),
                                fontWeight: FontWeight.w600,
                                fontSize: itemSize * 0.16, // Scale text slightly
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            }).toList(),
          ),
        ],
      ),
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
    // Special handling for "Flash Sale" to mimic bold grey vs bold black? 
    // Image shows "Popular" is black bold, others are grey bold. 
    // Text size seems large for headers.
    
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Text(
        title,
        key: _tabKeys[index],
        style: isSelected
            ? GoogleFonts.barlowCondensed(
                fontSize: 32,
                fontWeight: FontWeight.w700, // Bold
                color: const Color(0xFF3B3B3B), // Dark grey from plus icon
                letterSpacing: 0,
              )
            : GoogleFonts.barlowCondensed(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.inactiveTab.withOpacity(0.3), // Faint grey for inactive
                letterSpacing: 0,
            ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        // No explicit shadow in flat design, or very subtle. Image shows very subtle border/shadow or just white card on grey bg
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDefaults.smoothRadius),
                    topRight: Radius.circular(AppDefaults.smoothRadius),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: (product['image'] as String).startsWith('http')
                        ? Image.network(
                            product['image'] as String,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            product['image'] as String,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<FavoritesProvider>(
                    builder: (context, favorites, child) {
                      final isAvg = favorites.isFavorite(product['name']);
                      return GestureDetector(
                        onTap: () {
                          favorites.toggleFavorite(product);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                               BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ]
                          ),
                          child: Icon(
                            isAvg ? Icons.favorite : Icons.favorite_border,
                            color: isAvg ? const Color(0xFFFF7B6A) : const Color(0xFF979899),
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: const Color(0xFF3B3B3B),
                    fontWeight: FontWeight.w700, // Added bold
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product['size'] as String,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${(product['price'] as num).toStringAsFixed(2)}',
                      style: GoogleFonts.barlowCondensed(
                        fontWeight: FontWeight.w700, // Bold like '02'
                        color: const Color(0xFF3B3B3B),
                        fontSize: 22, // Increased from 18 to 24 for better visibility
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<CartProvider>(context, listen: false).addItem(
                          product['name'], // Using name as ID for now since we don't have unique IDs
                          product['name'],
                          (product['price'] as num).toDouble(),
                          product['image'],
                          product['size'],
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added ${product['name']} to cart',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color(0xFF1B1B1B),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          gradient: AppColors.premiumLinearGradient,
                          shape: BoxShape.circle, // Circular shape
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final filteredProducts = FruitData.allFruits.where((p) {
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
              'No fruits found for "$_searchQuery"',
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
      height: 120, // Approximate
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24, top: 0), // Removed top margin to decrease space
      width: double.infinity,
       // Placeholder for the bottom banner shown in image
       child: ListView(
         scrollDirection: Axis.horizontal,
         children: [
           Container(
             width: 250,
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(color: const Color(0xFF2E4035), borderRadius: BorderRadius.circular(16)),
             child: const Text('MEAL PLAN\nWITH GROCERY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
           ),
           const SizedBox(width: 16),
            Container(
             width: 250,
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(color: const Color(0xFF8B4C70), borderRadius: BorderRadius.circular(16)),
             child: const Text('MAKING THE\nMOST OF YOUR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
