import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ItemsScreen extends StatefulWidget {
  final ValueNotifier<String> categoryNotifier;
  final VoidCallback onBack;
  final VoidCallback onNavigateToCart;

  const ItemsScreen({
    super.key,
    required this.categoryNotifier,
    required this.onBack,
    required this.onNavigateToCart,
  });

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> with AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  int _selectedIndex = 0;
  final List<GlobalKey> _tabKeys = [];

  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Citrus',
    'Seasonal',
    'Berries',
    'Stone',
    'Melons',
    'Pomes',
    'Combos',
    'Exotic',
    'Dry',
    'Tropical',
    'Organic',
    'Ready-to-eat',
  ];

  final List<Map<String, dynamic>> _fruitProducts = [
    {
      'name': 'Alphonso Mango',
      'category': 'Seasonal',
      'size': '1kg',
      'price': 350.00,
      'image': 'assets/images/alphonso_mango.png',
    },
    {
      'name': 'Sitaphal',
      'category': 'Seasonal',
      'size': '1kg',
      'price': 100.00,
      'image': 'assets/images/sitaphal.png',
      'isAvailable': false,
    },
    {
      'name': 'Jamun',
      'category': 'Seasonal',
      'size': '1kg',
      'price': 140.00,
      'image': 'assets/images/jamun.png',
    },
    {
      'name': 'Apple (Regular)',
      'category': 'Pomes',
      'size': '1kg',
      'price': 140.00,
      'image': 'assets/images/apple.jpg',
    },
    {
      'name': 'Washington Apple',
      'category': 'Pomes',
      'size': '1kg',
      'price': 220.00,
      'image': 'assets/images/apple.jpg',
    },
    {
      'name': 'Pear',
      'category': 'Pomes',
      'size': '1kg',
      'price': 160.00,
      'image': 'assets/images/pear.png',
    },
    {
      'name': 'Banana (Robusta)',
      'category': 'Tropical',
      'size': '1 Dozen',
      'price': 50.00,
      'image': 'assets/images/banana.png',
    },
    {
      'name': 'Red Banana',
      'category': 'Tropical',
      'size': '1 Dozen',
      'price': 80.00,
      'image': 'assets/images/banana.png',
    },
    {
      'name': 'Raw Banana',
      'category': 'Tropical',
      'size': '1kg',
      'price': 45.00,
      'image': 'assets/images/banana.png',
    },
    {
      'name': 'Premium Banana',
      'category': 'Tropical',
      'size': '1 Dozen',
      'price': 70.00,
      'image': 'assets/images/banana.png',
      'isAvailable': false,
    },
    {
      'name': 'Orange',
      'category': 'Citrus',
      'size': '1kg',
      'price': 80.00,
      'image': 'assets/images/orange.png',
    },
    {
      'name': 'Lemon',
      'category': 'Citrus',
      'size': '1kg',
      'price': 120.00,
      'image': 'assets/images/lemon.png',
    },
    {
      'name': 'Mosambi',
      'category': 'Citrus',
      'size': '1kg',
      'price': 90.00,
      'image': 'assets/images/mosambi.png',
    },
    {
      'name': 'Grapefruit',
      'category': 'Citrus',
      'size': '1kg',
      'price': 180.00,
      'image': 'assets/images/grapefruit.png',
    },
    {
      'name': 'Mandarin',
      'category': 'Citrus',
      'size': '1kg',
      'price': 100.00,
      'image': 'assets/images/mandarin.png',
    },
    {
      'name': 'Grapes',
      'category': 'Berries',
      'size': '1kg',
      'price': 5.99,
      'image': 'assets/images/grapes_purple.png',
      'isAvailable': false,
    },
    {
      'name': 'Mango (Regular)',
      'category': 'Tropical',
      'size': '1kg',
      'price': 120.00,
      'image': 'assets/images/mango.png',
    },
    {
      'name': 'Alphonso Mango',
      'category': 'Tropical',
      'size': '1kg',
      'price': 350.00,
      'image': 'assets/images/alphonso_mango.png',
    },
    {
      'name': 'Papaya',
      'category': 'Tropical',
      'size': '1kg',
      'price': 50.00,
      'image': 'assets/images/papaya.png',
    },
    {
      'name': 'Dragon Fruit',
      'category': 'Tropical',
      'size': '1 pc',
      'price': 120.00,
      'image': 'assets/images/dragon_fruit.jpg',
    },
    {
      'name': 'Passion Fruit',
      'category': 'Tropical',
      'size': '1kg',
      'price': 200.00,
      'image': 'assets/images/passion_fruit.jpg',
    },
    {
      'name': 'Pineapple',
      'category': 'Tropical',
      'size': '1 pc',
      'price': 60.00,
      'image': 'assets/images/pineapple.png',
    },
    {
      'name': 'Strawberry',
      'category': 'Berries',
      'size': '200g pack',
      'price': 90.00,
      'image': 'assets/images/strawberry.png',
    },
    {
      'name': 'Blueberry',
      'category': 'Berries',
      'size': '125g pack',
      'price': 180.00,
      'image': 'assets/images/blueberry.png',
    },
    {
      'name': 'Raspberry',
      'category': 'Berries',
      'size': '125g pack',
      'price': 220.00,
      'image': 'assets/images/raspberry.png',
    },
    {
      'name': 'Blackberry',
      'category': 'Berries',
      'size': '125g pack',
      'price': 240.00,
      'image': 'assets/images/blackberry.png',
    },
    {
      'name': 'Watermelon',
      'category': 'Melons',
      'size': '1kg',
      'price': 30.00,
      'image': 'assets/images/watermelon.jpg',
    },
    {
      'name': 'Muskmelon',
      'category': 'Melons',
      'size': '1kg',
      'price': 40.00,
      'image': 'assets/images/muskmelon.png',
      'isAvailable': false,
    },
    {
      'name': 'Cantaloupe',
      'category': 'Melons',
      'size': '1kg',
      'price': 45.00,
      'image': 'assets/images/cantaloupe.png',
    },
    {
      'name': 'Honeydew',
      'category': 'Melons',
      'size': '1kg',
      'price': 60.00,
      'image': 'assets/images/honeydew.png',
    },
    {
      'name': 'Kiwi',
      'category': 'Exotic',
      'size': '1 pc',
      'price': 35.00,
      'image': 'assets/images/kiwi.png',
    },
    {
      'name': 'Avocado',
      'category': 'Exotic',
      'size': '1 pc',
      'price': 180.00,
      'image': 'assets/images/avocado.jpg',
    },
    {
      'name': 'Dragon Fruit (Imported)',
      'category': 'Exotic',
      'size': '1 pc',
      'price': 150.00,
      'image': 'assets/images/dragon_fruit.jpg',
    },
    {
      'name': 'Imported Blueberry',
      'category': 'Exotic',
      'size': '125g pack',
      'price': 220.00,
      'image': 'assets/images/blueberry.png',
    },
    {
      'name': 'Thai Guava',
      'category': 'Exotic',
      'size': '1kg',
      'price': 120.00,
      'image': 'assets/images/thai_guava.png',
    },
    {
      'name': 'Kiwi',
      'category': 'Tropical',
      'size': '6 pcs',
      'price': 5.50,
      'image': 'assets/images/kiwi.png',
    },
    {
      'name': 'Peach',
      'category': 'Stone',
      'size': '1kg',
      'price': 180.00,
      'image': 'assets/images/peach.jpg',
    },
    {
      'name': 'Plum',
      'category': 'Stone',
      'size': '1kg',
      'price': 160.00,
      'image': 'assets/images/plum.jpg',
    },
    {
      'name': 'Cherry',
      'category': 'Stone',
      'size': '1kg',
      'price': 350.00,
      'image': 'assets/images/cherry.png',
    },
    {
      'name': 'Apricot',
      'category': 'Stone',
      'size': '1kg',
      'price': 220.00,
      'image': 'assets/images/apricot.png',
    },
    {
      'name': 'Lychee',
      'category': 'Stone',
      'size': '1kg',
      'price': 140.00,
      'image': 'assets/images/lychee.jpg',
    },
    {
      'name': 'Pomegranate',
      'category': 'Pomes',
      'size': '1kg',
      'price': 7.50,
      'image': 'assets/images/pomegranate.jpg',
    },
    {
      'name': 'Fresh Dates',
      'category': 'Dry',
      'size': '1kg',
      'price': 180.00,
      'image': 'assets/images/dates.jpg',
      'isAvailable': false,
    },
    {
      'name': 'Fresh Fig (Anjeer)',
      'category': 'Dry',
      'size': '1kg',
      'price': 280.00,
      'image': 'assets/images/anjeer.jpg',
    },
    {
      'name': 'Organic Apple',
      'category': 'Organic',
      'size': '1kg',
      'price': 200.00,
      'image': 'assets/images/organic_apple.png',
    },
    {
      'name': 'Organic Banana',
      'category': 'Organic',
      'size': '1 Dozen',
      'price': 70.00,
      'image': 'assets/images/organic_banana.png',
    },
    {
      'name': 'Organic Papaya',
      'category': 'Organic',
      'size': '1kg',
      'price': 80.00,
      'image': 'assets/images/organic_papaya.png',
    },
    {
      'name': 'Fruit Bowl',
      'category': 'Ready-to-eat',
      'size': '250g',
      'price': 99.00,
      'image': 'assets/images/fruit_bowls.png',
    },
    {
      'name': 'Mixed Fruit Pack',
      'category': 'Ready-to-eat',
      'size': '500g',
      'price': 180.00,
      'image': 'assets/images/mixed_fruit_pack.png',
    },
    {
      'name': 'Pomegranate Seeds Pack',
      'category': 'Ready-to-eat',
      'size': '250g',
      'price': 130.00,
      'image': 'assets/images/pomegranate_seeds_pack.png',
    },
    {
      'name': 'Family Fruit Pack',
      'category': 'Combos',
      'size': '5kg',
      'price': 25.00,
      'image': 'assets/images/family_fruit_pack.png',
    },
    {
      'name': 'Immunity Booster Pack',
      'category': 'Combos',
      'size': '2kg',
      'price': 15.00,
      'image': 'assets/images/immunity_booster_pack.png',
      'isAvailable': false,
    },
    {
      'name': 'Kids Fruit Pack',
      'category': 'Combos',
      'size': '1.5kg',
      'price': 10.00,
      'image': 'assets/images/kids_fruit_pack.png',
    },
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Initialize selected index based on the passed category
    final initialIndex = _categories.indexOf(widget.categoryNotifier.value);
    _selectedIndex = initialIndex != -1 ? initialIndex : 0; // Default to Citrus if not found

    // Listen to external category changes
    widget.categoryNotifier.addListener(_handleExternalCategoryChange);

    // Generate keys for each category
    for (var i = 0; i < _categories.length; i++) {
      _tabKeys.add(GlobalKey());
    }

    _pageController = PageController(initialPage: _selectedIndex);

    // Scroll to the selected tab after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedTab();
    });
  }

  @override
  void didUpdateWidget(covariant ItemsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryNotifier != widget.categoryNotifier) {
      oldWidget.categoryNotifier.removeListener(_handleExternalCategoryChange);
      widget.categoryNotifier.addListener(_handleExternalCategoryChange);
      _handleExternalCategoryChange();
    }
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
    widget.categoryNotifier.removeListener(_handleExternalCategoryChange);
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleExternalCategoryChange() {
    final newCategory = widget.categoryNotifier.value;
    final index = _categories.indexOf(newCategory);
    if (index != -1 && index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      _scrollToSelectedTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8), // Adjusted to 8 to visually match the 16 after tabs (8px header padding + 8 = 16)
            _buildCategoryTabs(),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  _scrollToSelectedTab();
                },
                children: _categories.map((cat) {
                  final filteredProducts = _fruitProducts.where((p) {
                    final matchesCategory = p['category'] == cat;
                    final matchesSearch = _searchQuery.isEmpty || 
                        p['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
                    return matchesCategory && matchesSearch;
                  }).toList();
                  return _buildProductsGridPage(filteredProducts);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_isSearching)
            Expanded(
              child: Container(
                height: 44,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.black, width: 1),
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSearching = false;
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      child: const Icon(Icons.arrow_back, color: AppColors.primaryText, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search items...',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
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
                        child: const Icon(Icons.close, color: AppColors.secondaryText, size: 18),
                      ),
                  ],
                ),
              ),
            )
          else ...[
            SizedBox(
              width: 80,
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.search, color: AppColors.primaryText, size: 20),
                  ),
                ),
              ),
            ),
            Text(
              'Items',
              style: AppTextStyles.titleLarge.copyWith(
                color: const Color(0xFF3B3B3B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          GestureDetector(
            onTap: widget.onNavigateToCart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: AppColors.premiumLinearGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                   BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '${cart.itemCount < 10 ? '0' : ''}${cart.itemCount}',
                          style: GoogleFonts.barlowCondensed(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            height: 1.0,
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
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _categories.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isSelected = index == _selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 32), // Add spacing between items
            child: GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                // setState handled by onPageChanged, but we can also trigger scroll immediately
                // However, onPageChanged will be called by animateToPage, so it's covered.
              },
              child: Text(
                title,
                key: _tabKeys[index],
                style: isSelected
                    ? GoogleFonts.barlowCondensed(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3B3B3B),
                        letterSpacing: 0,
                      )
                    : GoogleFonts.barlowCondensed(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inactiveTab.withOpacity(0.3),
                        letterSpacing: 0,
                      ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductsGridPage(List<Map<String, dynamic>> products) {
    return GridView.builder(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72, // Match Home Screen
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    bool isAvailable = product['isAvailable'] as bool? ?? true;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
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
                    child: Builder(
                      builder: (context) {
                        Widget imageWidget = (product['image'] as String).startsWith('http')
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
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: product['category'] == 'Combos' 
                                      ? const Color(0xFFFFFDE7) 
                                      : const Color(0xFFF5F5F5),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image_not_supported_outlined, 
                                            color: AppColors.inactiveTab.withOpacity(0.2), 
                                            size: 32),
                                          const SizedBox(height: 4),
                                          Text('Coming Soon', 
                                            style: GoogleFonts.dmSans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.inactiveTab.withOpacity(0.5))),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              
                        if (!isAvailable) {
                          imageWidget = Stack(
                            fit: StackFit.expand,
                            children: [
                              ColorFiltered(
                                colorFilter: const ColorFilter.matrix(<double>[
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0, 0, 0, 1, 0,
                                ]),
                                child: imageWidget,
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.4),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      'CURRENTLY\nUNAVAILABLE',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.barlowCondensed(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return imageWidget;
                      }
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
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                               BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          ),
                          child: Icon(
                            isAvg ? Icons.favorite : Icons.favorite_border,
                            color: isAvg ? const Color(0xFFFF7B6A) : const Color(0xFF979899),
                            size: 18,
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
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3B3B3B),
                        fontSize: 22,
                      ),
                    ),
                    if (isAvailable)
                      GestureDetector(
                        onTap: () {
                          Provider.of<CartProvider>(context, listen: false).addItem(
                            product['name'],
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
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      )
                    else
                      const SizedBox(width: 32, height: 32),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
