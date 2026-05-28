import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/billing_models.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // Mock Data
  bool _isSubscribed = false; // Toggle to view active state
  String _selectedPeriod = 'Monthly'; // Monthly, Quarterly, Yearly

  final List<SubscriptionPlan> _plans = [
    SubscriptionPlan(
      id: 'silver',
      name: 'Silver',
      price: 99,
      period: 'month',
      benefits: ['Free delivery above ₹199', '5% Extra Discount'],
      color: Colors.grey,
    ),
    SubscriptionPlan(
      id: 'gold',
      name: 'Gold',
      price: 199,
      period: 'month',
      benefits: ['Unlimited free delivery', '10% Extra Discount', 'Priority Support'],
      isRecommended: true,
      color: const Color(0xFFE65100),
    ),
    SubscriptionPlan(
      id: 'platinum',
      name: 'Platinum',
      price: 299,
      period: 'month',
      benefits: ['Unlimited free delivery', 'Priority slot booking', '15% Extra Discount', 'Exclusive Seasonal Offers'],
      color: const Color(0xFFE5E4E2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Fruit Pass', style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Switch(
            value: _isSubscribed,
            onChanged: (val) => setState(() => _isSubscribed = val),
            activeColor: AppColors.primaryGreen,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _isSubscribed ? _buildActiveSubscriptionView() : _buildPlanSelectionView(),
      ),
    );
  }

  Widget _buildActiveSubscriptionView() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppColors.premiumLinearGradient, // Premium Gradient
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
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
                  Text('GOLD MEMBER', style: AppTextStyles.titleMedium.copyWith(color: const Color(0xFFE65100), letterSpacing: 1.5)),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star, color: Color(0xFFE65100), size: 24), // Gold Icon
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Valid until', style: AppTextStyles.bodySmall.copyWith(color: Colors.black.withOpacity(0.8))),
              Text('Feb 28, 2026', style: AppTextStyles.headlineMedium.copyWith(color: const Color(0xFFE65100))),
              const SizedBox(height: 24),
               Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 20),
                  const SizedBox(width: 8),
                  Text('Auto-renewal active', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFFE65100))),
                  const Spacer(),
                  Switch(
                    value: true,
                    onChanged: (val) {},
                    activeColor: Colors.white,
                    activeTrackColor: Colors.white.withOpacity(0.4),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text('Your Benefits', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildBenefitItem('Unlimited Free Delivery', Icons.local_shipping_outlined),
        _buildBenefitItem('10% Extra Discount', Icons.percent),
        _buildBenefitItem('Priority Support', Icons.support_agent),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Cancel Subscription', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              gradient: AppColors.premiumLinearGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFE65100), size: 20),
          ),
          const SizedBox(width: 16),
          Text(text, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPlanSelectionView() {
    return Column(
      children: [
        _buildPeriodToggle(),
        const SizedBox(height: 24),
        ..._plans.map((plan) => _buildPlanCard(plan)),
      ],
    );
  }

  Widget _buildPeriodToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          _buildToggleOption('Monthly', _selectedPeriod == 'Monthly'),
          _buildToggleOption('Quarterly', _selectedPeriod == 'Quarterly'),
          _buildToggleOption('Yearly', _selectedPeriod == 'Yearly'),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedPeriod = text);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.premiumLinearGradient : null,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? Colors.white : AppColors.secondaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 24, top: 12),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: plan.isRecommended ? Border.all(color: plan.color, width: 2) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(plan.name, style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold)),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '₹${_getDiscountedPrice(plan.price).toInt()}',
                          style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '/${_getPeriodText()}',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...plan.benefits.map((benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: plan.color, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(benefit, style: AppTextStyles.bodyMedium)),
                  ],
                ),
              )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan.isRecommended ? AppColors.primaryText : Colors.white,
                    side: plan.isRecommended ? null : BorderSide(color: AppColors.primaryText),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Choose ${plan.name}',
                    style: TextStyle(
                      color: plan.isRecommended ? Colors.white : AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (plan.isRecommended)
          Positioned(
            top: 0,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: plan.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'RECOMMENDED',
                style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFFE65100), fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }

  double _getDiscountedPrice(double basePrice) {
    if (_selectedPeriod == 'Quarterly') {
      return basePrice * 3 * 0.9; // 10% discount
    } else if (_selectedPeriod == 'Yearly') {
      return basePrice * 12 * 0.8; // 20% discount
    }
    return basePrice;
  }

  String _getPeriodText() {
    if (_selectedPeriod == 'Quarterly') return 'quarter';
    if (_selectedPeriod == 'Yearly') return 'year';
    return 'month';
  }
}
