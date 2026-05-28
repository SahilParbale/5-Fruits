import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/billing_models.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Payments', 'Refunds', 'Subscription', 'Wallet Credit', 'Wallet Debit'];

  final List<TransactionModel> _transactions = [
    TransactionModel(
      id: 'TXN-872391',
      date: DateTime.now().subtract(const Duration(days: 1)),
      amount: 450.00,
      type: TransactionType.payment,
      paymentMethod: 'UPI',
      status: TransactionStatus.success,
      description: 'Order #ORD-2024-1925',
    ),
    TransactionModel(
      id: 'TXN-872390',
      date: DateTime.now().subtract(const Duration(days: 2)),
      amount: 120.00,
      type: TransactionType.refund,
      paymentMethod: 'Wallet',
      status: TransactionStatus.success,
      description: 'Refund for #ORD-2024-1912',
    ),
    TransactionModel(
      id: 'TXN-872389',
      date: DateTime.now().subtract(const Duration(days: 5)),
      amount: 199.00,
      type: TransactionType.subscription,
      paymentMethod: 'Credit Card',
      status: TransactionStatus.success,
      description: 'Fruit Pass Gold (Monthly)',
    ),
    TransactionModel(
      id: 'TXN-872388',
      date: DateTime.now().subtract(const Duration(days: 6)),
      amount: 50.00,
      type: TransactionType.walletCredit,
      paymentMethod: 'Referral Bonus',
      status: TransactionStatus.success,
      description: 'Friend Referral',
    ),
    TransactionModel(
      id: 'TXN-872387',
      date: DateTime.now().subtract(const Duration(days: 7)),
      amount: 450.00,
      type: TransactionType.payment,
      paymentMethod: 'Failed',
      status: TransactionStatus.failed,
      description: 'Order #ORD-2024-1900',
    ),
  ];

  List<TransactionModel> get _filteredTransactions {
    if (_selectedFilter == 'All') return _transactions;
    return _transactions.where((t) {
      switch (_selectedFilter) {
        case 'Payments':
          return t.type == TransactionType.payment;
        case 'Refunds':
          return t.type == TransactionType.refund;
        case 'Subscription':
          return t.type == TransactionType.subscription;
        case 'Wallet Credit':
          return t.type == TransactionType.walletCredit;
        case 'Wallet Debit':
          return t.type == TransactionType.walletDebit;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Transaction History', style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _filteredTransactions.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      return _buildTransactionCard(_filteredTransactions[index], index + 1);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 52,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.premiumLinearGradient : null,
                color: isSelected ? null : AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? null : Border.all(color: AppColors.stroke),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.secondaryText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction, int serialNumber) {
    final isCredit = transaction.isCredit;
    final amountColor = isCredit
        ? const Color(0xFF2E7D32)
        : transaction.status == TransactionStatus.failed
            ? AppColors.secondaryText
            : const Color(0xFFC62828);
    final prefix = isCredit ? '+' : '-';

    return GestureDetector(
      onTap: () => _showTransactionDetails(context, transaction, serialNumber),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Serial Number Strip
            Container(
              width: 44,
              decoration: BoxDecoration(
                gradient: AppColors.premiumLinearGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDefaults.smoothRadius),
                  bottomLeft: Radius.circular(AppDefaults.smoothRadius),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  '$serialNumber',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _getTypeColor(transaction.type).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForType(transaction.type),
                        color: _getTypeColor(transaction.type),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Description & Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.description,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            transaction.id,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10,
                              color: AppColors.secondaryText,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded, size: 10, color: AppColors.secondaryText),
                              const SizedBox(width: 3),
                              Text(
                                DateFormat('dd MMM yyyy • hh:mm a').format(transaction.date),
                                style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Amount & Status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$prefix₹${transaction.amount.toStringAsFixed(2)}',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: transaction.status == TransactionStatus.failed
                                ? AppColors.secondaryText
                                : amountColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _buildStatusBadge(transaction.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.payment:
        return const Color(0xFF1565C0);
      case TransactionType.refund:
        return const Color(0xFF2E7D32);
      case TransactionType.subscription:
        return const Color(0xFF6A1B9A);
      case TransactionType.walletCredit:
        return const Color(0xFF00838F);
      case TransactionType.walletDebit:
        return const Color(0xFFE65100);
    }
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    Color color;
    String text;
    IconData icon;
    switch (status) {
      case TransactionStatus.success:
        color = const Color(0xFF2E7D32);
        text = 'Success';
        icon = Icons.check_circle_rounded;
        break;
      case TransactionStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        icon = Icons.schedule_rounded;
        break;
      case TransactionStatus.failed:
        color = Colors.red;
        text = 'Failed';
        icon = Icons.cancel_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 9, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(TransactionType type) {
    switch (type) {
      case TransactionType.payment:
        return Icons.shopping_bag_outlined;
      case TransactionType.refund:
        return Icons.restart_alt_rounded;
      case TransactionType.subscription:
        return Icons.card_membership_rounded;
      case TransactionType.walletCredit:
        return Icons.account_balance_wallet_outlined;
      case TransactionType.walletDebit:
        return Icons.account_balance_wallet_outlined;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.secondaryText.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different filter',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, TransactionModel transaction, int serialNumber) {
    final isCredit = transaction.isCredit;
    final statusColor = transaction.status == TransactionStatus.success
        ? const Color(0xFF2E7D32)
        : transaction.status == TransactionStatus.failed
            ? Colors.red
            : Colors.orange;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 24),
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      transaction.status == TransactionStatus.success
                          ? Icons.check_circle_rounded
                          : transaction.status == TransactionStatus.failed
                              ? Icons.cancel_rounded
                              : Icons.schedule_rounded,
                      color: statusColor,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${isCredit ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStatusBadge(transaction.status),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Details table
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  _buildDetailRow('Sr. No.', '#$serialNumber'),
                  _buildDetailRow('Payment To', 'Fruit App'),
                  _buildDetailRow('Description', transaction.description),
                  _buildDetailRow('Transaction ID', transaction.id),
                  _buildDetailRow('Date & Time', DateFormat('dd MMM yyyy • hh:mm a').format(transaction.date)),
                  _buildDetailRow('Payment Method', transaction.paymentMethod),
                  _buildDetailRow('Type', _typeLabel(transaction.type), isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.charcoal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(
                  'Close',
                  style: AppTextStyles.bodyLarge.copyWith(color: const Color(0xFFE65100), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _typeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.payment:
        return 'Payment';
      case TransactionType.refund:
        return 'Refund';
      case TransactionType.subscription:
        return 'Subscription';
      case TransactionType.walletCredit:
        return 'Wallet Credit';
      case TransactionType.walletDebit:
        return 'Wallet Debit';
    }
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText, fontSize: 12),
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
        if (!isLast)
          Divider(height: 1, color: AppColors.stroke, indent: 16, endIndent: 16),
      ],
    );
  }
}
