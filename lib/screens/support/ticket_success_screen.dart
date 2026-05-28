import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'ticket_tracking_screen.dart';

class TicketSuccessScreen extends StatelessWidget {
  final String ticketId;

  const TicketSuccessScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3E50).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Color(0xFF2C3E50), size: 64),
              ),
              const SizedBox(height: 24),
              Text('Complaint Submitted!', style: AppTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('We have received your request and will resolve it shortly.', textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText)),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Ticket ID', ticketId, isBold: true),
                    const Divider(height: 24),
                    _buildInfoRow('Expected Resolution', '2-6 Hours'),
                    const Divider(height: 24),
                    _buildInfoRow('Status', 'Under Review', color: Colors.orange),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.premiumLinearGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TicketTrackingScreen(ticketId: ticketId)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Track Status', style: TextStyle(color: const Color(0xFFE65100), fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                   Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Back to Home', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF2C3E50), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText)),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: color ?? AppColors.primaryText,
        )),
      ],
    );
  }
}
