import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'transaction_history_screen.dart';
import 'refund_center_screen.dart';
import 'subscription_screen.dart';


class AccountBillingScreen extends StatelessWidget {
  const AccountBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Building AccountBillingScreen');
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Account & Billing',
          style: AppTextStyles.titleLarge,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMenuCard(
              context,
              title: 'Transaction History',
              subtitle: 'View payments, refunds, and wallet activity',
              icon: Icons.receipt_long_rounded,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionHistoryScreen())),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              title: 'Refund Center',
              subtitle: 'Track refunds and manage requests',
              icon: Icons.restart_alt_rounded,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RefundCenterScreen())),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              title: 'Fruit Pass Subscription',
              subtitle: 'Manage premium membership and benefits',
              icon: Icons.card_membership_rounded,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen())),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    // Color param is no longer needed for the icon background as we use the theme gradient
    // keeping it for potential text grouping or just ignoring it to match theme strictly
    Color? color, 
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
          child: Padding(
            padding: const EdgeInsets.all(16), // Match ProfileScreen padding
            child: Row(
              children: [
                Container(
                  width: 48, // Match ProfileScreen size
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: AppColors.premiumLinearGradient, // Use theme gradient
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 24), // White icon
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
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.secondaryText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
