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
                    const SizedBox(height: 100), // Space for bottom nav
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 80),
          Text(
            'Profile',
            style: AppTextStyles.titleLarge.copyWith(
              color: const Color(0xFF3B3B3B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 80), // Space where cart icon would be
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        border: Border.all(color: Colors.black, width: 1), // Black border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Stronger shadow for depth
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.black, // Professional black background
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sahil Sharma',
                      style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryText),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'sahil.sharma@email.com',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                    ),
                    Text(
                      '+91 98765 43210',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 1,
            color: Colors.black.withOpacity(0.1), // Subtle divider
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('4', 'Orders'),
              _buildVerticalDivider(),
              _buildStatItem('₹70', 'Spent'),
              _buildVerticalDivider(),
              _buildStatItem('Gold', 'Status', isGold: true), // Gold status
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.black.withOpacity(0.1),
    );
  }

  Widget _buildStatItem(String value, String label, {bool isGold = false}) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.barlowCondensed(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isGold ? const Color(0xFFD4AF37) : AppColors.primaryText, // Gold or Black
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<AddressProvider>(
            builder: (context, addressProvider, child) {
              final defaultAddress = addressProvider.addresses.firstWhere(
                (addr) => addr.isDefault,
                orElse: () => addressProvider.addresses.first,
              );
              return _buildMenuItem(
                icon: Icons.location_on_outlined,
                iconColor: Colors.white,
                title: 'Address',
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
            iconColor: Colors.white,
            title: 'UPI Payment',
            subtitle: 'UPI & Wallets',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UPIPaymentScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.shopping_bag_outlined,
            iconColor: Colors.white,
            title: 'Order History',
            subtitle: '4 Orders',
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
                iconColor: Colors.white,
                title: 'Favorites',
                subtitle: '$count ${count == 1 ? 'Item' : 'Items'}',
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
            iconColor: Colors.white,
            title: 'Notifications',
            subtitle: 'On',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            iconColor: Colors.white,
            title: 'Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            iconColor: Colors.white,
            title: 'Help & Support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
          boxShadow: AppDefaults.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.premiumLinearGradient, // Reverted to use theme gradient
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }

}
