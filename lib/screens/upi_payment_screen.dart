import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/upi_provider.dart';
import '../models/upi_model.dart';
import 'add_new_upi_screen.dart';

class UPIPaymentScreen extends StatelessWidget {
  const UPIPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'UPI Payment',
          style: AppTextStyles.titleMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<UPIProvider>(
        builder: (context, provider, child) {
          final upis = provider.upis;
          final trueDefault = upis.any((u) => u.isDefault) ? upis.firstWhere((u) => u.isDefault) : null;
          final otherUpis = upis.where((u) => !u.isDefault).toList();

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (trueDefault != null) ...[
                            _buildSectionTitle('Default UPI'),
                            const SizedBox(height: 12),
                            _buildUPICard(context, trueDefault, provider),
                            const SizedBox(height: 24),
                          ],
                          if (otherUpis.isNotEmpty) ...[
                            _buildSectionTitle('Saved UPI IDs'),
                            const SizedBox(height: 12),
                            Column(
                              children: otherUpis.map((upi) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildUPICard(context, upi, provider),
                              )).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          _buildSecureInfo(),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24,
                left: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddNewUPIScreen()),
                    );
                  },
                  child: _buildAddNewButton(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }



  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF3B3B3B),
      ),
    );
  }

  Widget _buildUPICard(BuildContext context, UPIModel upi, UPIProvider provider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white, // Header to White
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.inputBackground, // Light grey for icon bg
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primaryText, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PROVIDER',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.secondaryText,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              upi.providerName,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (upi.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check, color: AppColors.primaryText, size: 10),
                            const SizedBox(width: 4),
                            Text(
                              'Default',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'UPI ID',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        upi.upiId,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (upi.isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9), // Light green for verified
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 10),
                            const SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: const Color(0xFF4CAF50),
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewUPIScreen(upiToEdit: upi),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE), // Gray background
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit_outlined, size: 16, color: AppColors.primaryText),
                          const SizedBox(width: 4),
                          Text(
                            'Edit',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!upi.isDefault) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => provider.setDefault(upi.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B1B1B).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Set Default',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF1B1B1B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    provider.deleteUPI(upi.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('UPI ID deleted'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () => provider.addUPI(upi),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline, color: Color(0xFFFF7B6A), size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecureInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E1E5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_outlined, color: Color(0xFF1B1B1B), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UPI Payments are Secure',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF1B1B1B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'All UPI transactions are encrypted and processed through secure payment gateways',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF1B1B1B).withOpacity(0.8),
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

  Widget _buildAddNewButton() {
    return Container(
      width: double.infinity,
      height: 72,
      decoration: BoxDecoration(
          gradient: AppColors.premiumLinearGradient, // Charcoal Gradient
          borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B1B1B).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: const Color(0xFFE65100)),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New UPI ID',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFFE65100),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                'Link your UPI account',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
