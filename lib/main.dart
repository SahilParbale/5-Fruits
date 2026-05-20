import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/home_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/items_screen.dart';

import 'screens/profile_screen.dart';

import 'screens/cart_screen.dart';

import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/address_provider.dart';
import 'providers/card_provider.dart';
import 'providers/upi_provider.dart';
import 'providers/settings_provider.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => CardProvider()),
        ChangeNotifierProvider(create: (_) => UPIProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: TextTheme(
            headlineLarge: AppTextStyles.headlineLarge,
            headlineMedium: AppTextStyles.headlineMedium,
            titleLarge: AppTextStyles.titleLarge,
            titleMedium: AppTextStyles.titleMedium,
            bodyLarge: AppTextStyles.bodyLarge,
            bodyMedium: AppTextStyles.bodyMedium,
            bodySmall: AppTextStyles.bodySmall,
          ),
        ),
        home: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  late final ValueNotifier<String> _selectedCategory;
  late PageController _pageController;
  
  // Navigator keys for each tab
  final Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
  };

  // Observers to track depth
  late final Map<int, TabNavigatorObserver> _navigatorObservers;
  bool _hideNavBar = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _selectedCategory = ValueNotifier<String>('Citrus');
    
    _navigatorObservers = {
      0: TabNavigatorObserver(onDepthChanged: _updateNavBarVisibility),
      1: TabNavigatorObserver(onDepthChanged: _updateNavBarVisibility),
      2: TabNavigatorObserver(onDepthChanged: _updateNavBarVisibility),
      3: TabNavigatorObserver(onDepthChanged: _updateNavBarVisibility),
    };
  }

  void _updateNavBarVisibility() {
    final bool shouldHide = (_navigatorObservers[_currentIndex]?.stackDepth ?? 1) > 1;
    if (shouldHide != _hideNavBar) {
      setState(() {
        _hideNavBar = shouldHide;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _selectedCategory.dispose();
    super.dispose();
  }

  void _handleBottomNavTap(int index) {
    if (index == _currentIndex) {
      // If tapping the currently active tab, pop it to its root
      _navigatorKeys[index]?.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
      _pageController.jumpToPage(index);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Immediately check depth of the new tab
    _updateNavBarVisibility();
  }

  void _navigateToCategories() {
    _handleBottomNavTap(1);
  }

  void _handleCategorySelect(String category) {
    _selectedCategory.value = category;
    
    // Ensure the Items navigator is at its root when a category is selected
    _navigatorKeys[2]?.currentState?.popUntil((route) => route.isFirst);
    
    _handleBottomNavTap(2);
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          onBack: () => Navigator.pop(context),
          onStartShopping: () {
            Navigator.pop(context);
            _handleBottomNavTap(2); 
          },
        ),
      ),
    );
  }

  Widget _buildNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      observers: [_navigatorObservers[index]!],
      onGenerateRoute: (RouteSettings settings) {
        Widget page;
        switch (index) {
          case 0:
            page = HomeScreen(
              onNavigateToCategories: _navigateToCategories,
              onNavigateToCart: _navigateToCart,
              onCategorySelect: _handleCategorySelect,
            );
            break;
          case 1:
            page = CategoriesScreen(
              onCategorySelect: _handleCategorySelect,
              onBack: () => _handleBottomNavTap(0),
              onNavigateToCart: _navigateToCart,
            );
            break;
          case 2:
            page = ItemsScreen(
              categoryNotifier: _selectedCategory,
              onBack: () => _handleBottomNavTap(0),
              onNavigateToCart: _navigateToCart,
            );
            break;
          case 3:
            page = ProfileScreen(
              onBack: () => _handleBottomNavTap(0),
            );
            break;
          default:
            page = Container();
        }
        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        // Try to pop the current tab's navigator first
        final NavigatorState? currentNavigator = _navigatorKeys[_currentIndex]?.currentState;
        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
        } else {
          // If we are already at the root of a tab that isn't Home, go back to Home
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
          } else {
            // If we're at the root of Home tab, let the system handle exit or whatever is set
            // In a typical app, this might show an exit dialog or just close.
            // For now, we allow the app to be backgrounded/closed by not blocking if we're at home root.
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: _hideNavBar ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
              children: [
                _buildNavigator(0),
                _buildNavigator(1),
                _buildNavigator(2),
                _buildNavigator(3),
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: _hideNavBar ? -100 : 24,
              left: 24,
              right: 24,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _hideNavBar ? 0 : 1,
                child: CustomBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: _handleBottomNavTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabNavigatorObserver extends NavigatorObserver {
  final VoidCallback onDepthChanged;
  int stackDepth = 0;

  TabNavigatorObserver({required this.onDepthChanged});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    stackDepth++;
    onDepthChanged();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    stackDepth--;
    onDepthChanged();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    stackDepth--;
    onDepthChanged();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    onDepthChanged();
  }
}
