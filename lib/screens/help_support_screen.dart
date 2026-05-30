import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'live_chat_screen.dart';
import 'faq_screen.dart';
import 'account/account_billing_screen.dart';
import 'support/my_tickets_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: _buildSearchBar(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(height: 8),
                   _buildSectionHeader('Contact Us'),
                   _buildLiveChatCard(context),
                   const SizedBox(height: 16),
                   _buildContactOption(
                     icon: Icons.phone_in_talk_outlined,
                     iconColor: Colors.white,
                     title: 'Call Support',
                     subtitle: 'Available 24/7 • +1 (800) 555-0123',
                     showArrow: false,
                   ),
                   const SizedBox(height: 16),
                   _buildContactOption(
                     icon: Icons.email_outlined,
                     iconColor: Colors.white,
                     title: 'Email Support',
                     subtitle: 'Response within 24 hours',
                     showArrow: false,
                   ),
                   const SizedBox(height: 32),
                   _buildSectionHeader('Quick Help'),
                   _buildQuickHelpList(),
                   const SizedBox(height: 32),
                   _buildFAQSection(context),
                   const SizedBox(height: 32),
                   const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.secondaryText.withOpacity(0.5)),
          const SizedBox(width: 12),
          Text(
            'Search for help...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
      ),
    );
  }

  Widget _buildLiveChatCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LiveChatScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.premiumLinearGradient, // Standard Charcoal Gradient
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chat_bubble_outline, color: const Color(0xFFE65100), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Live Chat',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: const Color(0xFFE65100),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Average response time: 2 mins',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.black.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Start',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF1B1B1B),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildContactOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                gradient: AppColors.premiumLinearGradient,
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
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              const Icon(Icons.chevron_right, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHelpList() {
    return Builder(
      builder: (context) {
        return Column(
          children: [

            _buildContactOption(
              icon: Icons.confirmation_number_outlined,
              iconColor: Colors.white,
              title: 'Support Tickets',
              subtitle: 'Track status & raise new tickets',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              icon: Icons.person_outline,
              iconColor: Colors.white,
              title: 'Account & Billing',
              subtitle: 'Payments, refunds & subscriptions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountBillingScreen()),
                );
              },
            ),
          ],
        );
      }
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    return Column(
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(
               'Frequently Asked',
               style: GoogleFonts.barlowCondensed(
                 fontSize: 20,
                 fontWeight: FontWeight.bold,
                 color: AppColors.primaryText,
               ),
             ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQScreen()),
                  );
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.barlowCondensed(
                    color: const Color(0xFF1B1B1B),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
           ],
        ),
        const SizedBox(height: 16),
        _buildFAQCard('How do I track my order?', 'Go to Order History in your profile, select your order, and tap \'Track Order\' to see real-time delivery updates.'),
        const SizedBox(height: 16),
        _buildFAQCard('What is your refund policy?', 'We offer full refunds within 24 hours of delivery for damaged or incorrect items. Contact support to initiate a refund.'),
        const SizedBox(height: 16),
        _buildFAQCard('How can I change my delivery address?', 'Navigate to Profile > Address and update your delivery address. Changes apply to future orders only.'),
        const SizedBox(height: 16),
        _buildFAQCard('Do you offer same-day delivery?', 'Yes! Orders placed before 12 PM qualify for same-day delivery. Check availability at checkout.'),
      ],
    );
  }

  Widget _buildFAQCard(String question, String answer) {
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
            child: const Icon(Icons.help_outline, color: const Color(0xFFE65100), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  answer,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                    height: 1.5,
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
