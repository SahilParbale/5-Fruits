import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/billing_models.dart';
import 'package:intl/intl.dart';

class RefundDetailScreen extends StatelessWidget {
  final RefundModel refund;
  const RefundDetailScreen({super.key, required this.refund});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Refund Details', style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(),
            const SizedBox(height: 20),
            _buildDetailsCard(),
            const SizedBox(height: 20),
            Text(
              'Refund Timeline',
              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTimeline(),
            const SizedBox(height: 24),
            _buildContactButton(),
          ],
        ),
      ),
    );
  }

  // ─── Premium gradient hero card ────────────────────────────────────────────
  Widget _buildHeroCard() {
    final statusColor = refund.status == RefundStatus.completed
        ? const Color(0xFF4CAF50)
        : refund.status == RefundStatus.processing
            ? Colors.orange
            : Colors.red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        gradient: AppColors.premiumLinearGradient,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: statusColor.withOpacity(0.4), width: 1.5),
            ),
            child: Icon(
              refund.status == RefundStatus.completed
                  ? Icons.check_circle_rounded
                  : refund.status == RefundStatus.processing
                      ? Icons.schedule_rounded
                      : Icons.cancel_rounded,
              color: statusColor,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '₹${refund.amount.toStringAsFixed(2)}',
            style: GoogleFonts.barlowCondensed(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Refund Amount',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  refund.status == RefundStatus.completed
                      ? Icons.check_circle_rounded
                      : refund.status == RefundStatus.processing
                          ? Icons.schedule_rounded
                          : Icons.cancel_rounded,
                  color: statusColor,
                  size: 12,
                ),
                const SizedBox(width: 6),
                Text(
                  refund.status == RefundStatus.completed
                      ? 'Completed'
                      : refund.status == RefundStatus.processing
                          ? 'Processing'
                          : 'Initiated',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Details card (dark themed table) ──────────────────────────────────────
  Widget _buildDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card header banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: AppColors.premiumLinearGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDefaults.smoothRadius),
                topRight: Radius.circular(AppDefaults.smoothRadius),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Text(
                  'Refund Information',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Details table
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                _buildDetailRow('Order ID', refund.orderId),
                _buildDetailRow('Refund ID', refund.id),
                _buildDetailRow('Original Payment', refund.originalPaymentMethod),
                _buildDetailRow('Refund To', refund.refundMode, isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 24),
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: AppColors.stroke, indent: 20, endIndent: 20),
      ],
    );
  }

  // ─── Timeline ───────────────────────────────────────────────────────────────
  Widget _buildTimeline() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Timeline header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: AppColors.premiumLinearGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDefaults.smoothRadius),
                topRight: Radius.circular(AppDefaults.smoothRadius),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.timeline_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Text(
                  'Refund Timeline',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Column(
              children: List.generate(refund.timeline.length, (index) {
                final item = refund.timeline[index];
                final isLast = index == refund.timeline.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              gradient: item.isCompleted
                                  ? AppColors.premiumLinearGradient
                                  : null,
                              color: item.isCompleted ? null : Colors.grey[200],
                              shape: BoxShape.circle,
                              boxShadow: item.isCompleted
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              item.isCompleted ? Icons.check : Icons.circle,
                              color: item.isCompleted ? Colors.white : Colors.grey[400],
                              size: item.isCompleted ? 12 : 8,
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: item.isCompleted
                                      ? const LinearGradient(
                                          colors: [Color(0xFF2D2D2D), Color(0xFF555555)],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )
                                      : null,
                                  color: item.isCompleted ? null : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: item.isCompleted
                                      ? AppColors.primaryText
                                      : AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.description,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: item.isCompleted
                                      ? AppColors.secondaryText
                                      : AppColors.secondaryText.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 10,
                                    color: item.isCompleted
                                        ? AppColors.secondaryText
                                        : AppColors.secondaryText.withOpacity(0.4),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    DateFormat('dd MMM • hh:mm a').format(item.date),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: item.isCompleted
                                          ? AppColors.secondaryText
                                          : AppColors.secondaryText.withOpacity(0.4),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Contact support button ─────────────────────────────────────────────────
  Widget _buildContactButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.premiumLinearGradient,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                'Contact Support',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
