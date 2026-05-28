import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/billing_models.dart';
import 'package:intl/intl.dart';
import 'refund_detail_screen.dart';

class RefundCenterScreen extends StatelessWidget {
  const RefundCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<RefundModel> refunds = [
      RefundModel(
        id: 'REF-2024-001',
        orderId: '#ORD-2024-1912',
        amount: 120.00,
        status: RefundStatus.completed,
        dateInitiated: DateTime.now().subtract(const Duration(days: 2)),
        originalPaymentMethod: 'UPI',
        refundMode: 'Wallet',
        timeline: [
          RefundTimelineItem(title: 'Refund Initiated', description: 'Request received', date: DateTime.now().subtract(const Duration(days: 2)), isCompleted: true),
          RefundTimelineItem(title: 'Approved', description: 'Refund approved by system', date: DateTime.now().subtract(const Duration(days: 2, hours: 2)), isCompleted: true),
          RefundTimelineItem(title: 'Credited', description: 'Amount credited to wallet', date: DateTime.now().subtract(const Duration(days: 2, hours: 1)), isCompleted: true),
        ],
      ),
      RefundModel(
        id: 'REF-2024-002',
        orderId: '#ORD-2024-1925',
        amount: 85.00,
        status: RefundStatus.processing,
        dateInitiated: DateTime.now().subtract(const Duration(hours: 5)),
        expectedCreditDate: DateTime.now().add(const Duration(days: 2)),
        originalPaymentMethod: 'Credit Card',
        refundMode: 'Original Payment Method',
        timeline: [
          RefundTimelineItem(title: 'Refund Initiated', description: 'Request received', date: DateTime.now().subtract(const Duration(hours: 5)), isCompleted: true),
          RefundTimelineItem(title: 'Processing', description: 'Refund is being processed by bank', date: DateTime.now(), isCompleted: true),
          RefundTimelineItem(title: 'Credited', description: 'Expected by Feb 21', date: DateTime.now().add(const Duration(days: 2)), isCompleted: false),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Refund Center', style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCard(refunds),
            const SizedBox(height: 24),
            Text('Recent Refunds', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...refunds.map((refund) => _buildRefundCard(context, refund)),
            const SizedBox(height: 24),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF2C3E50).withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextButton.icon(
                  onPressed: () {
                     // Navigate to help or ticket creation
                  },
                  icon: const Icon(Icons.help_outline, color: Color(0xFF2C3E50)),
                  label: Text('Having trouble? Raise a Ticket', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF2C3E50), fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(List<RefundModel> refunds) {
    final totalRefunds = refunds.fold(0.0, (sum, item) => sum + item.amount);
    final pendingCount = refunds.where((r) => r.status != RefundStatus.completed).length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.premiumLinearGradient, // Premium Gradient
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Refunds', style: AppTextStyles.bodySmall.copyWith(color: Colors.black87)),
                  const SizedBox(height: 8),
                  Text('₹${totalRefunds.toStringAsFixed(2)}', style: AppTextStyles.headlineLarge.copyWith(color: const Color(0xFFE65100))),
                  Text('This Month', style: AppTextStyles.bodySmall.copyWith(color: Colors.black87)),
                ],
              ),
               Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.restart_alt_rounded, color: const Color(0xFFE65100), size: 32),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('$pendingCount', 'Pending', Colors.orangeAccent),
              Container(width: 1, height: 40, color: Colors.white24), // Separator
              _buildStatItem('24h', 'Avg. Time', Colors.lightBlueAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTextStyles.titleLarge.copyWith(color: color)),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: Colors.black87)),
      ],
    );
  }

  Widget _buildRefundCard(BuildContext context, RefundModel refund) {
    Color statusColor;
    String statusText;
    switch (refund.status) {
      case RefundStatus.initiated:
        statusColor = Colors.blue;
        statusText = 'Initiated';
        break;
      case RefundStatus.processing:
        statusColor = Colors.orange;
        statusText = 'Processing';
        break;
      case RefundStatus.completed:
        statusColor = AppColors.primaryGreen;
        statusText = 'Completed';
        break;
    }

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RefundDetailScreen(refund: refund))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          children: [
            Row(
              children: [
                 // Gradient Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: AppColors.premiumLinearGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.restart_alt_rounded,
                    color: const Color(0xFFE65100),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(refund.orderId, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(DateFormat('MMM dd, yyyy').format(refund.dateInitiated), style: AppTextStyles.bodySmall), // Standardized date format
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: AppTextStyles.bodySmall.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.stroke), // Use theme stroke color
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Refund Amount', style: AppTextStyles.bodySmall),
                Text('₹${refund.amount.toStringAsFixed(2)}', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            if (refund.expectedCreditDate != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Expected Credit', style: AppTextStyles.bodySmall),
                  Text(DateFormat('MMM dd, yyyy').format(refund.expectedCreditDate!), style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
