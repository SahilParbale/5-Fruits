import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_new_card_screen.dart';
import 'upi_payment_screen.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../models/card_model.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<CardProvider>(
        builder: (context, provider, child) {
          final cards = provider.cards;
          final defaultCard = cards.firstWhere((c) => c.isDefault, orElse: () => cards.isNotEmpty ? cards.first : cards[0]); // Fallback if no default (shouldn't happen with our logic)
          // Actually, let's find the true default or the first one.
          final trueDefault = cards.any((c) => c.isDefault) ? cards.firstWhere((c) => c.isDefault) : null;
          final otherCards = cards.where((c) => !c.isDefault).toList();

          return Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (trueDefault != null) ...[
                            _buildSection(
                              title: 'Default Method',
                              children: [
                                _buildCreditCard(trueDefault),
                                const SizedBox(height: 16),
                                _buildCardActions(context, trueDefault, provider),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                          if (otherCards.isNotEmpty) ...[
                            _buildSection(
                              title: 'Saved Cards',
                              children: otherCards.expand((card) => [
                                _buildCreditCard(card),
                                const SizedBox(height: 16),
                                _buildCardActions(context, card, provider),
                                if (card != otherCards.last) const SizedBox(height: 24),
                              ]).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                          _buildSection(
                            title: 'Other Payment Methods',
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const UPIPaymentScreen()),
                                  );
                                },
                                child: _buildPaymentOption(
                                  icon: Icons.account_balance_wallet_outlined,
                                  title: 'UPI (Google Pay, PhonePe)',
                                  subtitle: 'Pay using any UPI app',
                                  iconColor: const Color(0xFF00BFA5), // Teal
                                  iconBgColor: const Color(0xFFE0F2F1), // Light Teal
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          _buildSecurePaymentInfo(),
                          const SizedBox(height: 100),
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
                child: _buildAddNewButton(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 80),
          Text(
            'Payment Methods',
            style: GoogleFonts.barlowCondensed(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(width: 80),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 12),
          child: Text(
            title,
            style: GoogleFonts.barlowCondensed(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildCreditCard(PaymentCard card) {
    Gradient gradient;
    switch (card.type.toLowerCase()) {
      case 'visa':
        gradient = const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF1E88E5)], // Deep Blue
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'mastercard':
        gradient = const LinearGradient(
          colors: [Color(0xFFEF6C00), Color(0xFFFFA726)], // Vibrant Orange
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'amex':
        gradient = const LinearGradient(
          colors: [Color(0xFF7B1FA2), Color(0xFFAB47BC)], // Deep Purple
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      default:
        gradient = const LinearGradient(
          colors: [Color(0xFF23AA49), Color(0xFF1B5E20)], // Deep Green
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.type.toUpperCase(),
                style: AppTextStyles.titleLarge.copyWith(
                  color: const Color(0xFFE65100),
                  letterSpacing: 1.2,
                ),
              ),
              if (card.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check, color: const Color(0xFFE65100), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Default',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFFE65100),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            card.number,
            style: AppTextStyles.headlineMedium.copyWith(
              color: const Color(0xFFE65100),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.holder,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: const Color(0xFFE65100),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${card.expiryMonth}/${card.expiryYear}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: const Color(0xFFE65100),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardActions(BuildContext context, PaymentCard card, CardProvider provider) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewCardScreen(card: card),
                ),
              );
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryText),
                  const SizedBox(width: 8),
                  Text(
                    'Edit',
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!card.isDefault) ...[
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => provider.setDefault(card.id),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Set Default',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            provider.deleteCard(card.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${card.type} card deleted'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () => provider.addCard(card),
                ),
              ),
            );
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete_outline, color: Color(0xFFFF7B6A)),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBgColor,
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
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: AppColors.secondaryText),
      ],
    );
  }

  Widget _buildAddNewButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNewCardScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        height: 72,
        decoration: BoxDecoration(
          gradient: AppColors.premiumLinearGradient,
          borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
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
                  'Add New Card',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: const Color(0xFFE65100),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Add a payment method',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurePaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5FE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFB3E5FC),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_outlined, color: Color(0xFF039BE5), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Payment',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your payment information is encrypted and stored securely. We never share your card details.',
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
