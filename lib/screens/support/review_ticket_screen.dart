import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/ticket_model.dart';
import '../order_history_screen.dart';
import 'ticket_success_screen.dart';

class ReviewTicketScreen extends StatelessWidget {
  final OrderModel order;
  final Set<IssueType> selectedIssueTypes;
  final Map<String, int> selectedItems;
  final List<String> selectedReasons;
  final String description;
  final ResolutionPreference resolutionPreference;

  const ReviewTicketScreen({
    super.key,
    required this.order,
    required this.selectedIssueTypes,
    required this.selectedItems,
    required this.selectedReasons,
    required this.description,
    required this.resolutionPreference,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Review & Submit', style: AppTextStyles.titleLarge),
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
             _buildSectionHeader('Affected Items'),
             ...selectedItems.entries.map((entry) {
               final item = order.items.firstWhere((i) => i.id == entry.key);
               return Container(
                 margin: const EdgeInsets.only(bottom: 8),
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                 child: Row(
                   children: [
                     Image.asset(item.image, width: 40, height: 40, fit: BoxFit.cover),
                     const SizedBox(width: 12),
                     Expanded(child: Text('${item.name} x${entry.value}', style: AppTextStyles.bodyMedium)),
                     Text('₹${(item.price * entry.value).toStringAsFixed(2)}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                   ],
                 ),
               );
             }).toList(),
             const SizedBox(height: 24),
             _buildSectionHeader('Issue Details'),
             Container(
               width: double.infinity,
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   _buildDetailRow('Issue Type', selectedIssueTypes.map((t) => _getIssueTypeString(t)).join(', ')),
                   const Divider(height: 24),
                   _buildDetailRow('Reasons', selectedReasons.join(', ')),
                   if (description.isNotEmpty) ...[
                     const Divider(height: 24),
                     _buildDetailRow('Note', description),
                   ],
                 ],
               ),
             ),
             const SizedBox(height: 24),
             _buildSectionHeader('Resolution'),
             Container(
               width: double.infinity,
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
               child: _buildDetailRow('Preference', _getResolutionString(resolutionPreference)),
             ),
             const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.premiumLinearGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Simulate network delay
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context); // Close loader
                      
                      final newTicketId = '#FRU${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
                      
                      // Construct description with multiple issues if needed
                      String finalDescription = description;
                      if (selectedIssueTypes.length > 1) {
                         final issuesStr = selectedIssueTypes.map((t) => _getIssueTypeString(t)).join(', ');
                         finalDescription = 'Issues: $issuesStr\n\n$description';
                      }
                  
                      // Add to mock list for demo
                      TicketModel.sampleTickets.insert(0, TicketModel(
                        id: newTicketId,
                        orderId: order.id,
                        dateCreated: DateTime.now(),
                        status: TicketStatus.raised,
                        issueType: selectedIssueTypes.first, // Use primary issue type
                        affectedItemIds: selectedItems.keys.toList(),
                        description: finalDescription,
                        resolutionPreference: resolutionPreference,
                        estimatedResolutionTime: DateTime.now().add(const Duration(hours: 48)),
                      ));
                  
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketSuccessScreen(ticketId: newTicketId),
                        ),
                        (route) => route.isFirst,
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Submit Complaint', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyMedium),
      ],
    );
  }

  String _getIssueTypeString(IssueType type) {
    switch(type) {
      case IssueType.missingItem: return 'Missing Item';
      case IssueType.wrongProduct: return 'Wrong Product';
      case IssueType.damaged: return 'Damaged / Rotten';
      case IssueType.quantityIssue: return 'Quantity Issue';
      case IssueType.paymentIssue: return 'Payment Issue';
      case IssueType.lateDelivery: return 'Late Delivery';
      case IssueType.other: return 'Other';
    }
  }

  String _getResolutionString(ResolutionPreference pref) {
    switch(pref) {
      case ResolutionPreference.replacement: return 'Replacement';
      case ResolutionPreference.refundToOriginal: return 'Refund to Original Source';
      case ResolutionPreference.storeCredit: return 'Store Credit';
      case ResolutionPreference.callMe: return 'Call Me First';
    }
  }
}
