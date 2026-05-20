import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Privacy Policy',
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. Introduction',
              'Welcome to our Privacy Policy. Your privacy is critically important to us. This policy explains how we collect, use, and protect your personal information when you use our application.',
            ),
            _buildSection(
              '2. Information We Collect',
              'We may collect the following types of information:\n\n'
              '• Personal Information: Name, email address, phone number, and delivery address.\n'
              '• Payment Information: Credit card details and billing information (processed securely by third-party providers).\n'
              '• Usage Data: Information about how you use the app, including interactions and preferences.',
            ),
            _buildSection(
              '3. How We Use Your Information',
              'We use your information to:\n\n'
              '• Process and deliver your orders.\n'
              '• Communicate with you regarding updates, offers, and support.\n'
              '• Improve our app functionality and user experience.\n'
              '• Ensure the security of your account and transactions.',
            ),
            _buildSection(
              '4. Data Security',
              'We implement industry-standard security measures to protect your data. However, no method of transmission over the internet or electronic storage is 100% secure.',
            ),
            _buildSection(
              '5. Sharing Your Information',
              'We do not sell your personal data. We may share information with trusted third-party service providers (e.g., payment processors, delivery partners) strictly for operational purposes.',
            ),
            _buildSection(
              '6. Your Rights',
              'You have the right to access, update, or delete your personal information. You can manage your account settings within the app or contact support for assistance.',
            ),
            _buildSection(
              '7. Changes to This Policy',
              'We may update this Privacy Policy from time to time. We will notify you of any significant changes through the app or via email.',
            ),
            _buildSection(
              '8. Contact Us',
              'If you have any questions about this Privacy Policy, please contact our support team.',
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Last Updated: October 2023',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF555555), // Slightly softer black for reading
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
