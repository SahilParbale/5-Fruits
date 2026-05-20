import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../models/card_model.dart';

class AddNewCardScreen extends StatefulWidget {
  final PaymentCard? card;
  const AddNewCardScreen({super.key, this.card});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  late String _cardType;
  late TextEditingController _cardNumberController;
  late TextEditingController _cardHolderController;
  late TextEditingController _monthController;
  late TextEditingController _yearController;
  late TextEditingController _cvvController;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    _cardType = widget.card?.type ?? 'Visa';
    _cardNumberController = TextEditingController(text: widget.card?.number ?? '');
    _cardHolderController = TextEditingController(text: widget.card?.holder ?? '');
    _monthController = TextEditingController(text: widget.card?.expiryMonth ?? '');
    _yearController = TextEditingController(text: widget.card?.expiryYear ?? '');
    _cvvController = TextEditingController(text: widget.card?.cvv ?? '');
    _isDefault = widget.card?.isDefault ?? false;
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Color _getCardColor() {
    switch (_cardType) {
      case 'Visa':
        return const Color(0xFF42A5F5); // Light Blue
      case 'Mastercard':
        return const Color(0xFFFF8A65); // Orange
      case 'Amex':
        return const Color(0xFF7986CB); // Purple-ish
      default:
        return AppColors.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120), // For sticky button
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCardPreview(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Card Type'),
                      const SizedBox(height: 12),
                      _buildCardTypeSelector(),
                      const SizedBox(height: 24),
                      
                      _buildInputField(
                        'Card Number', 
                        '1234 5678 9012 3456', 
                        _cardNumberController, 
                        keyboardType: TextInputType.number,
                        icon: Icons.credit_card_rounded,
                        iconColor: const Color(0xFF1565C0), // Blue
                      ),
                      
                      _buildInputField(
                        'Card Holder Name', 
                        'ENTER CARDHOLDER NAME', 
                        _cardHolderController,
                        icon: Icons.person_rounded,
                        iconColor: const Color(0xFF43A047), // Green
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildInputField(
                                'Month', 
                                'MM', 
                                _monthController, 
                                horizontalPadding: 0, 
                                keyboardType: TextInputType.number,
                                icon: Icons.calendar_month_rounded,
                                iconColor: const Color(0xFFEF6C00), // Orange
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInputField(
                                'Year', 
                                'YY', 
                                _yearController, 
                                horizontalPadding: 0, 
                                keyboardType: TextInputType.number,
                                icon: Icons.calendar_today_rounded,
                                iconColor: const Color(0xFFEF6C00), // Orange
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInputField(
                                'CVV', 
                                '123', 
                                _cvvController, 
                                horizontalPadding: 0, 
                                keyboardType: TextInputType.number,
                                icon: Icons.lock_rounded,
                                iconColor: const Color(0xFFC62828), // Red
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDefaultToggle(),
                      const SizedBox(height: 24),
                      _buildSecurityInfo(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: _buildSaveButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 80),
          Text(
            widget.card == null ? 'Add New Card' : 'Edit Card',
            style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 80),
        ],
      ),
    );
  }

  Widget _buildCardPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getCardColor().withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _cardType.toUpperCase(),
            style: AppTextStyles.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          ValueListenableBuilder(
            valueListenable: _cardNumberController,
            builder: (context, value, child) {
              String text = value.text;
              if (text.isEmpty) text = '•••• •••• •••• ••••';
              return Text(
                text,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ValueListenableBuilder(
                    valueListenable: _cardHolderController,
                    builder: (context, value, child) {
                      String text = value.text.isEmpty ? 'Your Name' : value.text;
                      return Text(
                        text,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _monthController,
                        builder: (context, value, child) {
                          return Text(
                            value.text.isEmpty ? 'MM' : value.text,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      Text(
                        '/',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _yearController,
                        builder: (context, value, child) {
                          return Text(
                            value.text.isEmpty ? 'YY' : value.text,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF3B3B3B),
        ),
      ),
    );
  }

  Widget _buildCardTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildTypeOption('Visa', Icons.credit_card, const Color(0xFF1976D2))),
          const SizedBox(width: 12),
          Expanded(child: _buildTypeOption('Mastercard', Icons.credit_card, const Color(0xFFFF8F00))),
          const SizedBox(width: 12),
          Expanded(child: _buildTypeOption('Amex', Icons.credit_card, const Color(0xFF7B1FA2))),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String label, IconData icon, Color activeColor) {
    final isSelected = _cardType == label;
    return GestureDetector(
      onTap: () => setState(() => _cardType = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected)
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.secondaryText,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? activeColor : AppColors.secondaryText,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller, {
    double horizontalPadding = 16,
    TextInputType? keyboardType,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3B3B3B),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mutedText.withOpacity(0.7)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
              ),
            ),
          ),
          if (horizontalPadding > 0) const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDefaultToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBDEFB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.credit_card_outlined, color: Color(0xFF2196F3), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set as Default',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1565C0),
                  ),
                ),
                Text(
                  'Use as my default payment method',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF1E88E5).withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isDefault,
            onChanged: (value) => setState(() => _isDefault = value),
            activeColor: const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.security, color: AppColors.primaryGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your card is secure',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'We use industry-standard encryption to protect your card information',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryGreen.withOpacity(0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        final provider = Provider.of<CardProvider>(context, listen: false);
        final card = PaymentCard(
          id: widget.card?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          type: _cardType,
          number: _cardNumberController.text,
          holder: _cardHolderController.text,
          expiryMonth: _monthController.text,
          expiryYear: _yearController.text,
          cvv: _cvvController.text,
          isDefault: _isDefault,
        );

        if (widget.card == null) {
          provider.addCard(card);
        } else {
          provider.updateCard(card);
        }
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppColors.premiumLinearGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.card == null ? 'Save Card' : 'Update Card',
            style: GoogleFonts.barlowCondensed(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
