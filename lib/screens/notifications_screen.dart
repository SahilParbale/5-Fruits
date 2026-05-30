import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.barlowCondensed(
            color: AppColors.primaryText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Mark all\nread',
                textAlign: TextAlign.right,
                style: GoogleFonts.barlowCondensed(
                  color: const Color(0xFF1B1B1B),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                children: [
                  _buildSectionTitle('Recent Notifications'),
                  _buildNotificationCard(
                    icon: Icons.shopping_bag_outlined,
                    iconColor: Colors.white,
                    title: 'Order Confirmed',
                    description: 'Your order #2847 has been confirmed and is being prepared.',
                    time: '2 min ago',
                    isUnread: true,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.local_shipping_outlined,
                    iconColor: Colors.white,
                    title: 'Out for Delivery',
                    description: 'Your order #2845 is out for delivery. Expected arrival: 30 mins',
                    time: '15 min ago',
                    isUnread: true,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.card_giftcard_outlined,
                    iconColor: Colors.white,
                    title: 'Special Offer',
                    description: '20% off on all dairy products this weekend! Use code DAIRY20',
                    time: '1 hour ago',
                    isUnread: true,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.white,
                    title: 'Order Delivered',
                    description: 'Your order #2843 has been successfully delivered. Enjoy your items!',
                    time: '3 hours ago',
                    isUnread: false,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.notifications_active_outlined,
                    iconColor: Colors.white,
                    title: 'Flash Sale Alert',
                    description: 'Flash sale on fresh fruits starts in 1 hour. Don\'t miss out!',
                    time: '5 hours ago',
                    isUnread: false,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.error_outline,
                    iconColor: Colors.white,
                    title: 'Payment Method Updated',
                    description: 'Your payment method ending in 4532 has been successfully updated.',
                    time: '1 day ago',
                    isUnread: false,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.calendar_today_outlined,
                    iconColor: Colors.white,
                    title: 'Delivery Scheduled',
                    description: 'Your order #2840 is scheduled for delivery tomorrow between 9-11 AM',
                    time: '2 days ago',
                    isUnread: false,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.card_giftcard_outlined,
                    iconColor: Colors.white,
                    title: 'Loyalty Reward',
                    description: 'Congratulations! You\'ve earned 50 reward points. Redeem now!',
                    time: '3 days ago',
                    isUnread: false,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.barlowCondensed(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              gradient: AppColors.premiumLinearGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
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
                      title,
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
