import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'order_history_screen.dart';
import 'upi_payment_screen.dart';
import 'my_addresses_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'favorites_screen.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/address_provider.dart';
import 'help_support_screen.dart';
import 'dart:math' as math;
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const ProfileScreen({super.key, this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildProfileCard(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildAccountSection(context),
                    const SizedBox(height: 120), // Space for bottom nav
                  ],
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Profile',
            style: AppTextStyles.headlineLarge.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
            ),
          ),
          // Notification bubble with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                ),
                child: const Icon(Icons.notifications_outlined, color: AppColors.primaryText, size: 24),
              ),
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF57C00), // Orange badge
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: AppColors.premiumLinearGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD54F).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background leaf patterns
            Positioned(
              left: -20,
              top: -20,
              child: Transform.rotate(
                angle: -math.pi / 4,
                child: Icon(Icons.eco, size: 100, color: Colors.white.withOpacity(0.2)),
              ),
            ),
            Positioned(
              right: -30,
              bottom: -10,
              child: Transform.rotate(
                angle: math.pi / 6,
                child: Icon(Icons.eco, size: 120, color: const Color(0xFFFFB300).withOpacity(0.15)),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile info with Image
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=200&auto=format&fit=crop'), // Fruit bowl
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ORGANIC BOUTIQUE',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFD84315),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD54F),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.workspace_premium, color: Color(0xFFD84315), size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        'GOLD MEMBER',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF1B1B1B),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sahil Sharma',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF0D1C2E),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Member ID: #OB-2026-9875',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF0D1C2E).withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white70, size: 28),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Stats Section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF7).withOpacity(0.9), // Light cream
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWalletStat(Icons.shopping_bag_outlined, '4', 'Total Orders'),
                        Container(width: 1, height: 40, color: const Color(0xFFFFD54F)),
                        _buildWalletStat(Icons.account_balance_wallet_outlined, '₹70', 'Cashback Spent'),
                        Container(width: 1, height: 40, color: const Color(0xFFFFD54F)),
                        _buildWalletStat(Icons.card_giftcard, '340', 'Reward Points'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFFFE082),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFD84315), size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD84315),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFD84315),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Dashboard',
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<AddressProvider>(
            builder: (context, addressProvider, child) {
              final defaultAddress = addressProvider.addresses.firstWhere(
                (addr) => addr.isDefault,
                orElse: () => addressProvider.addresses.first,
              );
              return _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Saved Addresses',
                subtitle: defaultAddress.address.split(',').take(2).join(', '),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyAddressesScreen()),
                  );
                },
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'UPI & Payments',
            subtitle: 'Manage saved UPI accounts',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UPIPaymentScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            subtitle: 'Track or reorder past items',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
              );
            },
          ),
          Consumer<FavoritesProvider>(
            builder: (context, favorites, child) {
              final count = favorites.items.length;
              return _buildMenuItem(
                icon: Icons.favorite_border,
                title: 'Boutique Wishlist',
                subtitle: '$count ${count == 1 ? 'item' : 'items'} saved',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                  );
                },
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.notifications_none_outlined,
            title: 'Subscription & Notifications',
            subtitle: 'Manage alerts and offers',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'App Settings',
            subtitle: 'System, language, and security',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Concierge Help & Support',
            subtitle: '24/7 Premium customer chat',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.logout_rounded,
            title: 'Log Out',
            subtitle: 'Sign out of your account',
            onTap: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Logged out successfully',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: const Color(0xFF1B1B1B),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        debugPrint('Tapped menu item: $title');
        if (onTap != null) onTap!();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD54F).withOpacity(0.1), // Soft gold shadow
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3E0), // Pale orange background
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFE65100), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                      fontSize: 15,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFE65100), size: 22),
          ],
        ),
      ),
    );
  }
}
