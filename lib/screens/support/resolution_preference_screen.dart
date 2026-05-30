import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/ticket_model.dart';
import '../order_history_screen.dart';
import 'review_ticket_screen.dart';

class ResolutionPreferenceScreen extends StatefulWidget {
  final OrderModel order;
  final Set<IssueType> selectedIssueTypes;
  final Map<String, int> selectedItems;
  final List<String> selectedReasons;
  final String description;

  const ResolutionPreferenceScreen({
    super.key,
    required this.order,
    required this.selectedIssueTypes,
    required this.selectedItems,
    required this.selectedReasons,
    required this.description,
  });

  @override
  State<ResolutionPreferenceScreen> createState() => _ResolutionPreferenceScreenState();
}

class _ResolutionPreferenceScreenState extends State<ResolutionPreferenceScreen> {
  ResolutionPreference? _selectedPreference;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Preferred Resolution',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'How would you like us to resolve this?',
              style: GoogleFonts.barlowCondensed(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            _buildPreferenceCard(
              ResolutionPreference.replacement,
              'Send Replacement',
              'We will ship the missing/damaged items again.',
              Icons.change_circle_outlined,
            ),
            const SizedBox(height: 12),
            _buildPreferenceCard(
              ResolutionPreference.refundToOriginal,
              'Refund to Original Source',
              'Amount will be credited to your bank account.',
              Icons.account_balance_outlined,
            ),
            const SizedBox(height: 12),
            _buildPreferenceCard(
              ResolutionPreference.storeCredit,
              'Refund to Wallet (Fastest)',
              'Instant credit to your Fruit App Wallet.',
              Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 12),
            _buildPreferenceCard(
              ResolutionPreference.callMe,
              'Call Me First',
              'Our support team will call you to discuss options.',
              Icons.phone_in_talk_outlined,
            ),
             const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _selectedPreference == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewTicketScreen(
                             order: widget.order,
                             selectedIssueTypes: widget.selectedIssueTypes,
                             selectedItems: widget.selectedItems,
                             selectedReasons: widget.selectedReasons,
                             description: widget.description,
                             resolutionPreference: _selectedPreference!,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                backgroundColor: Colors.transparent, // Transparent for gradient
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: _selectedPreference == null ? null : AppColors.premiumLinearGradient,
                   color: _selectedPreference == null ? Colors.grey[300] : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50),
                  alignment: Alignment.center,
                  child: Text(
                    'Review Complaint',
                    style: GoogleFonts.barlowCondensed(
                      color: const Color(0xFFE65100),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceCard(ResolutionPreference preference, String title, String subtitle, IconData icon) {
    final isSelected = _selectedPreference == preference;
    return GestureDetector(
      onTap: () => setState(() => _selectedPreference = preference),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C3E50).withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2C3E50) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Radio<ResolutionPreference>(
              value: preference,
              groupValue: _selectedPreference,
              onChanged: (val) => setState(() => _selectedPreference = val),
              activeColor: const Color(0xFF2C3E50),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF2C3E50) : AppColors.primaryText)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: isSelected ? const Color(0xFF2C3E50) : AppColors.secondaryText),
          ],
        ),
      ),
    );
  }
}
