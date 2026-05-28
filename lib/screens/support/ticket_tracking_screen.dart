import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TicketTrackingScreen extends StatelessWidget {
  final String ticketId;

  const TicketTrackingScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Track Ticket', style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                children: [
                  Text(ticketId, style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Under Review', style: AppTextStyles.bodySmall.copyWith(color: Colors.orange, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineItem('Ticket Raised', 'We received your complaint.', '10:30 AM', true, true),
                  _buildTimelineItem('Under Review', 'Support team is analyzing details.', '10:35 AM', true, false),
                  _buildTimelineItem('Approved / Rejected', 'Wait for decision.', '', false, false),
                  _buildTimelineItem('Resolution', 'Refund/Replacement initiated.', '', false, false),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard('Refund Estimate', '₹120.00', Icons.account_balance_wallet_outlined),
            const SizedBox(height: 16),
            _buildInfoCard('Replacement ETA', 'Tomorrow, 10 AM', Icons.local_shipping_outlined),
             const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.premiumLinearGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to Chat
                },
                 icon: const Icon(Icons.chat_bubble_outline, color: const Color(0xFFE65100)),
                label: const Text('Chat with Support', style: TextStyle(color: const Color(0xFFE65100), fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, String time, bool isActive, bool isCompleted) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                 color: isCompleted || isActive ? const Color(0xFF2C3E50) : Colors.grey[300],
                 shape: BoxShape.circle,
                 border: isActive && !isCompleted ? Border.all(color: const Color(0xFF2C3E50), width: 4) : null,
              ),
            ),
            if (title != 'Resolution')
              Container(
                width: 2,
                height: 50,
                color: isCompleted ? const Color(0xFF2C3E50) : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: isActive || isCompleted ? AppColors.primaryText : Colors.grey)),
              Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
            ],
          ),
        ),
        if (time.isNotEmpty)
          Text(time, style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
      ],
    );
  }

   Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF2C3E50).withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF2C3E50)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
              Text(value, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
   }
}
