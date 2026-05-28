import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/ticket_model.dart';
import '../order_history_screen.dart'; // For OrderModel and OrderItemModel
import 'issue_details_screen.dart';
import 'order_issue_selection_screen.dart';

class OrderItemSelectionScreen extends StatefulWidget {
  final OrderModel order;

  const OrderItemSelectionScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderItemSelectionScreen> createState() => _OrderItemSelectionScreenState();
}

class _OrderItemSelectionScreenState extends State<OrderItemSelectionScreen> {
  final Map<String, int> _selectedItems = {}; // Item ID -> Quantity

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Select Items', style: AppTextStyles.titleLarge),
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
              itemCount: widget.order.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = widget.order.items[index];
                final isSelected = _selectedItems.containsKey(item.id);
                final selectedQty = _selectedItems[item.id] ?? 0;

                return GestureDetector(
                  onTap: () => _toggleItem(item.id, item.quantity),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryGreen : Colors.transparent,
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
                          activeColor: AppColors.primaryGreen,
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
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
                              ),
                              Text('$selectedQty', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryGreen),
                                onPressed: () => _updateQuantity(item.id, selectedQty + 1, item.quantity),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _selectedItems.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderIssueSelectionScreen(
                            order: widget.order,
                            selectedItems: _selectedItems,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Next: Select Issue', style: TextStyle(color: const Color(0xFFE65100), fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
