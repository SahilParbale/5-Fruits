import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFAQCategory(
              context: context,
              title: 'Orders & Payments',
              questions: [
                FAQItem(
                    question: 'How do I track my order?',
                    answer:
                        'Go to Order History in your profile, select your order, and tap \'Track Order\' to see real-time delivery updates.'),
                FAQItem(
                    question: 'Can I change my order after placing it?',
                    answer:
                        'You can modify your order within 10 minutes of placing it. After that, please contact support for assistance.'),
                FAQItem(
                    question: 'What payment methods do you accept?',
                    answer:
                        'We accept all major credit/debit cards, UPI, and net banking. Cash on Delivery is available in select areas.'),
              ],
            ),
            const SizedBox(height: 24),
            _buildFAQCategory(
              context: context,
              title: 'Delivery',
              questions: [
                FAQItem(
                    question: 'Do you offer same-day delivery?',
                    answer:
                        'Yes! Orders placed before 12 PM qualify for same-day delivery. Check availability at checkout based on your location.'),
                FAQItem(
                    question: 'What if I am not home during delivery?',
                    answer:
                        'Our delivery partner will try to contact you. You can also leave delivery instructions to leave the package at your doorstep or with a neighbor.'),
                FAQItem(
                    question: 'How can I change my delivery address?',
                    answer:
                        'Navigate to Profile > Address and update your delivery address. Changes apply to future orders only. For active orders, contact support immediately.'),
              ],
            ),
            const SizedBox(height: 24),
            _buildFAQCategory(
              context: context,
              title: 'Returns & Refunds',
              questions: [
                FAQItem(
                    question: 'What is your refund policy?',
                    answer:
                        'We offer full refunds within 24 hours of delivery for damaged or incorrect items. Contact support with a photo of the item to initiate a refund.'),
                FAQItem(
                    question: 'How long does a refund take?',
                    answer:
                        'Refunds are processed within 24-48 hours. It may take 3-5 business days for the amount to reflect in your bank account.'),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.premiumLinearGradient,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: const Color(0xFFE65100)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Frequently Asked Questions',
        style: AppTextStyles.titleMedium.copyWith(
          color: const Color(0xFFE65100),
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildFAQCategory({
    required BuildContext context,
    required String title,
    required List<FAQItem> questions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: const Color(0xFF2C3E50),
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...questions.map((q) => _buildExpansionTile(context, q)),
      ],
    );
  }

  Widget _buildExpansionTile(BuildContext context, FAQItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            item.question,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.answer,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
