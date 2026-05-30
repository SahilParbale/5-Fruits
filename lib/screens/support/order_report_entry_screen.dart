import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/ticket_model.dart';
import '../order_history_screen.dart'; // For OrderModel
import 'issue_details_screen.dart';

class OrderReportEntryScreen extends StatefulWidget {
  final OrderModel order;

  const OrderReportEntryScreen({super.key, required this.order});

  @override
  State<OrderReportEntryScreen> createState() => _OrderReportEntryScreenState();
}

class _OrderReportEntryScreenState extends State<OrderReportEntryScreen> {
  final Map<String, int> _selectedItems = {}; // Item ID -> Quantity
  final Set<IssueType> _selectedIssueTypes = {};

  // Issue Types Data
  final List<IssueTypeData> _issueTypes = [
     IssueTypeData(IssueType.missingItem, 'Missing Item', Icons.inventory_2_outlined, AppColors.primaryGreen),
      IssueTypeData(IssueType.wrongProduct, 'Wrong Product', Icons.error_outline, AppColors.primaryGreen),
      IssueTypeData(IssueType.damaged, 'Damaged / Rotten', Icons.broken_image_outlined, AppColors.primaryGreen),
      IssueTypeData(IssueType.quantityIssue, 'Quantity Issue', Icons.scale_outlined, AppColors.primaryGreen),
      IssueTypeData(IssueType.paymentIssue, 'Payment Issue', Icons.payment_outlined, AppColors.primaryGreen),
      IssueTypeData(IssueType.lateDelivery, 'Late Delivery', Icons.schedule_outlined, AppColors.primaryGreen),
      IssueTypeData(IssueType.other, 'Other Issue', Icons.help_outline, AppColors.primaryGreen),
  ];

  void _toggleItem(String itemId, int maxQuantity) {
    setState(() {
      if (_selectedItems.containsKey(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems[itemId] = 1; // Default to 1
      }
    });
  }

  void _updateQuantity(String itemId, int quantity, int maxQuantity) {
    setState(() {
      if (quantity > 0 && quantity <= maxQuantity) {
        _selectedItems[itemId] = quantity;
      }
    });
  }

  void _toggleIssueType(IssueType type) {
    setState(() {
      if (_selectedIssueTypes.contains(type)) {
        _selectedIssueTypes.remove(type);
      } else {
        _selectedIssueTypes.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Report an Issue',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('1. Select Affected Items'),
                  const SizedBox(height: 12),
                  ...widget.order.items.map((item) => _buildItemCard(item)),
                  const SizedBox(height: 32),
                  _buildSectionHeader('2. Select Issue Type'),
                  const SizedBox(height: 12),
                  _buildIssueGrid(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryText,
      ),
    );
  }

  Widget _buildItemCard(OrderItemModel item) {
    final isSelected = _selectedItems.containsKey(item.id);
    final selectedQty = _selectedItems[item.id] ?? 0;

    return GestureDetector(
      onTap: () => _toggleItem(item.id, item.quantity),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
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
            Checkbox(
              value: isSelected,
              onChanged: (_) => _toggleItem(item.id, item.quantity),
              activeColor: const Color(0xFF2C3E50), // Dark color
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(item.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  Text('${item.size} • ₹${item.price}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
                ],
              ),
            ),
            if (isSelected)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.secondaryText),
                    onPressed: () => _updateQuantity(item.id, selectedQty - 1, item.quantity),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('$selectedQty', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFF2C3E50)),
                    onPressed: () => _updateQuantity(item.id, selectedQty + 1, item.quantity),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5, // Make cards shorter/smaller
      ),
      itemCount: _issueTypes.length,
      itemBuilder: (context, index) {
        final issue = _issueTypes[index];
        final isSelected = _selectedIssueTypes.contains(issue.type);
        return GestureDetector(
          onTap: () => _toggleIssueType(issue.type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2C3E50).withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12), // Slightly smaller radius
              border: Border.all(
                color: isSelected ? const Color(0xFF2C3E50) : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40, // Smaller icon container
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumLinearGradient,
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: const Color(0xFF2C3E50), width: 2) : null,
                  ),
                  child: Icon(issue.icon, color: const Color(0xFFE65100), size: 20), // Smaller icon
                ),
                const SizedBox(height: 8),
                Text(
                  issue.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14, // Slightly smaller text
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? const Color(0xFF2C3E50) : AppColors.primaryText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isSelected) ...[
                   const SizedBox(height: 2),
                   const Icon(Icons.check_circle, size: 14, color: Color(0xFF2C3E50)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final bool canProceed = _selectedItems.isNotEmpty && _selectedIssueTypes.isNotEmpty;

    return Container(
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
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: canProceed ? AppColors.premiumLinearGradient : null,
            color: canProceed ? null : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton(
            onPressed: canProceed
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IssueDetailsScreen(
                          order: widget.order,
                          selectedIssueTypes: _selectedIssueTypes,
                          selectedItems: _selectedItems,
                        ),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Next: Provide Details',
              style: AppTextStyles.titleMedium.copyWith(
                color: const Color(0xFFE65100),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
