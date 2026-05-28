import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/ticket_model.dart';
import 'ticket_tracking_screen.dart';
import '../order_history_screen.dart'; // To raise new ticket

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Support Tickets', style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: TicketModel.sampleTickets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final ticket = TicketModel.sampleTickets[index];
                return _buildTicketCard(context, ticket);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                 BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.premiumLinearGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                   // Navigate to Order History to select an order
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                  );
                },
                icon: const Icon(Icons.add, color: const Color(0xFFE65100)),
                label: const Text('Raise New Ticket', style: TextStyle(color: const Color(0xFFE65100), fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, TicketModel ticket) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TicketTrackingScreen(ticketId: ticket.id)),
        );
      },
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ticket.id, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                _buildStatusBadge(ticket.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Order: ${ticket.orderId}',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(_getIssueIcon(ticket.issueType), size: 16, color: const Color(0xFF2C3E50)),
                const SizedBox(width: 8),
                Text(
                  _getIssueTitle(ticket.issueType),
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created: ${_formatDate(ticket.dateCreated)}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText, fontSize: 11),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF2C3E50), size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TicketStatus status) {
    Color color;
    String text;

    switch (status) {
      case TicketStatus.raised:
        color = Colors.blue;
        text = 'Raised';
        break;
      case TicketStatus.underReview:
        color = Colors.orange;
        text = 'Under Review';
        break;
      case TicketStatus.approved:
        color = AppColors.primaryGreen;
        text = 'Approved';
        break;
      case TicketStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        break;
      case TicketStatus.refundInitiated:
        color = Colors.purple;
        text = 'Refund Initiated';
        break;
      case TicketStatus.resolved:
        color = Colors.teal;
        text = 'Resolved';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  IconData _getIssueIcon(IssueType type) {
    switch (type) {
      case IssueType.missingItem: return Icons.inventory_2_outlined;
      case IssueType.wrongProduct: return Icons.error_outline;
      case IssueType.damaged: return Icons.broken_image_outlined;
      case IssueType.quantityIssue: return Icons.scale_outlined;
      case IssueType.paymentIssue: return Icons.payment_outlined;
      case IssueType.lateDelivery: return Icons.schedule_outlined;
      case IssueType.other: return Icons.help_outline;
    }
  }

  String _getIssueTitle(IssueType type) {
    switch (type) {
       case IssueType.missingItem: return 'Missing Item';
      case IssueType.wrongProduct: return 'Wrong Product';
      case IssueType.damaged: return 'Damaged / Rotten';
      case IssueType.quantityIssue: return 'Quantity Issue';
      case IssueType.paymentIssue: return 'Payment Issue';
      case IssueType.lateDelivery: return 'Late Delivery';
      case IssueType.other: return 'Other Issue';
    }
  }

  String _formatDate(DateTime date) {
    // Simple formatter, in real app use intl
    return '${date.day}/${date.month}/${date.year}';
  }
}
