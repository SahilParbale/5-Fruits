import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/ticket_model.dart';
import '../order_history_screen.dart'; // For OrderModel
import 'issue_details_screen.dart';

class OrderIssueSelectionScreen extends StatelessWidget {
  final OrderModel order;
  final Map<String, int> selectedItems;

  const OrderIssueSelectionScreen({
    super.key,
    required this.order,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    final List<IssueTypeData> issueTypes = [
      IssueTypeData(IssueType.missingItem, 'Missing Item', Icons.inventory_2_outlined, Colors.orange),
      IssueTypeData(IssueType.wrongProduct, 'Wrong Product', Icons.error_outline, Colors.redAccent),
      IssueTypeData(IssueType.damaged, 'Damaged / Rotten', Icons.broken_image_outlined, Colors.brown),
      IssueTypeData(IssueType.quantityIssue, 'Quantity Issue', Icons.scale_outlined, Colors.blue),
      IssueTypeData(IssueType.paymentIssue, 'Payment Issue', Icons.payment_outlined, Colors.purple),
      IssueTypeData(IssueType.lateDelivery, 'Late Delivery', Icons.schedule_outlined, Colors.teal),
      IssueTypeData(IssueType.other, 'Other Issue', Icons.help_outline, Colors.grey),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
         title: Text('Select Issue Type', style: AppTextStyles.titleLarge),
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
            Text(
              'What went wrong with your order?',
              style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Please select the issue regarding Order ${order.id}',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: issueTypes.length,
              itemBuilder: (context, index) {
                return _buildIssueCard(context, issueTypes[index]);
              },
            ),
             const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueCard(BuildContext context, IssueTypeData issue) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IssueDetailsScreen(
              order: order,
              selectedIssueType: issue.type,
              selectedItems: selectedItems,
            ),
          ),
        );
      },
      child: Container(
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
          border: Border.all(color: Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: issue.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(issue.icon, color: issue.color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              issue.title,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
