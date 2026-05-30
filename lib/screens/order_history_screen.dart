import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'support/order_report_entry_screen.dart';
import 'help_support_screen.dart';
import '../providers/address_provider.dart';

// Model classes for internal use in this screen
class OrderModel {
  final String id;
  final String date;
  final String status;
  final Color statusColor;
  final List<OrderItemModel> items;
  final double total;
  final bool showReorder;

  OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.items,
    required this.total,
    required this.showReorder,
  });
}

class OrderItemModel {
  final String id;
  final String name;
  final String image; // Asset path or URL
  final double price;
  final String size;
  final int quantity;

  OrderItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.size,
    this.quantity = 1,
  });
}

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  // Mock Data
  static final List<OrderModel> _orders = [
    OrderModel(
      id: '#ORD-2024-1925',
      date: 'Feb 18, 2024',
      status: 'Delivered',
      statusColor: const Color(0xFF43A047),
      total: 20.00,
      showReorder: true,
      items: [
        OrderItemModel(
          id: 'Pomegranate',
          name: 'Pomegranate',
          image: 'assets/images/pomegranate.jpg',
          price: 7.50,
          size: '1kg',
          quantity: 1,
        ),
        OrderItemModel(
          id: 'Dragon Fruit',
          name: 'Dragon Fruit',
          image: 'assets/images/dragon_fruit.jpg',
          price: 8.00,
          size: '1 pc',
          quantity: 1,
        ),
        OrderItemModel(
          id: 'Thai Guava',
          name: 'Thai Guava',
          image: 'assets/images/thai_guava.png',
          price: 4.50,
          size: '1kg',
          quantity: 1,
        ),
      ],
    ),
    OrderModel(
      id: '#ORD-2024-1912',
      date: 'Feb 15, 2024',
      status: 'Delivered',
      statusColor: const Color(0xFF43A047),
      total: 15.50,
      showReorder: true,
      items: [
        OrderItemModel(
          id: 'Dates',
          name: 'Dates',
          image: 'assets/images/dates.jpg',
          price: 8.50,
          size: '500g',
          quantity: 1,
        ),
        OrderItemModel(
          id: 'Anjeer',
          name: 'Anjeer',
          image: 'assets/images/anjeer.jpg',
          price: 7.00,
          size: '250g',
          quantity: 1,
        ),
      ],
    ),
    OrderModel(
      id: '#ORD-2024-1898',
      date: 'Feb 10, 2024',
      status: 'Processing',
      statusColor: const Color(0xFFEF6C00),
      total: 20.42,
      showReorder: false,
      items: [
        OrderItemModel(
          id: 'Passion Fruit',
          name: 'Passion Fruit',
          image: 'assets/images/passion_fruit.jpg',
          price: 6.00,
          size: '500g',
          quantity: 1,
        ),
        OrderItemModel(
          id: 'Avocado',
          name: 'Avocado',
          image: 'assets/images/avocado.jpg',
          price: 7.50,
          size: '500g',
          quantity: 1,
        ),
        OrderItemModel(
          id: '6 Pieces Eggs',
          name: '6 Pieces Eggs',
          image: 'assets/images/egg.png',
          price: 6.92,
          size: '6 Pieces',
          quantity: 1,
        ),
      ],
    ),
    OrderModel(
      id: '#ORD-2024-1847',
      date: 'Jan 25, 2024',
      status: 'Cancelled',
      statusColor: const Color(0xFFE53935),
      total: 13.99,
      showReorder: false,
      items: [
        OrderItemModel(
          id: 'Apple',
          name: 'Apple',
          image: 'assets/images/apple.jpg',
          price: 3.99,
          size: '1kg',
          quantity: 1,
        ),
        OrderItemModel(
          id: 'Alphonso Mango',
          name: 'Alphonso Mango',
          image: 'assets/images/alphonso_mango.png',
          price: 10.00,
          size: '1 Dozen',
          quantity: 1,
        ),
      ],
    ),
  ];

  double get _totalSpent => _orders.fold(0, (sum, order) => sum + order.total);
  double get _avgOrder => _orders.isEmpty ? 0 : _totalSpent / _orders.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Order History',
          style: AppTextStyles.titleMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: _buildSummaryCard(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildSectionTitle('Recent Orders'),
                  ..._orders.map((order) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildOrderCard(context, order),
                  )),
                  _buildNeedHelpSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleReorder(BuildContext context, OrderModel order) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    // Add all items from the order to the cart
    for (var item in order.items) {
      for (int i = 0; i < item.quantity; i++) {
        cartProvider.addItem(
          item.id,
          item.name,
          item.price,
          item.image,
          item.size,
        );
      }
    }

    // Navigate to Cart Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(onBack: () => Navigator.pop(context)),
      ),
    );
  }



  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: AppColors.premiumLinearGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_orders.length} Orders',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  Text(
                    'Total purchases',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(height: 1, color: Colors.black.withOpacity(0.1)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Total Spent', '₹${_totalSpent.toStringAsFixed(2)}'),
              _buildSummaryItem('Avg. Order', '₹${_avgOrder.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryText, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumLinearGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.id, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    Text(order.date, style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: order.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                order.status,
                style: AppTextStyles.bodySmall.copyWith(
                  color: order.statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...order.items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.fiber_manual_record, size: 6, color: AppColors.secondaryText),
                    const SizedBox(width: 8),
                    Text('${item.name} x${item.quantity}', style: AppTextStyles.bodySmall),
                  ],
                ),
                Text('₹${item.price.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${order.items.length} Items', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
            Row(
              children: [
                Text('Total', style: AppTextStyles.bodySmall),
                const SizedBox(width: 8),
                Text('₹${order.total.toStringAsFixed(2)}', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showOrderDetails(context, order),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[100]!), // Subtle red border
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Get Help', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.red[700])), // Red text
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 16, color: Colors.red[700]),
                    ],
                  ),
                ),
              ),
            ),
            if (order.showReorder) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 4,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumLinearGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => _handleReorder(context, order),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          'Reorder',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xFFE65100),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        ],
      ),
    );
  }

  Widget _buildNeedHelpSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E1E5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.help_outline, color: Color(0xFF1B1B1B), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need Help?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B1B1B),
                  ),
                ),
                Text(
                  'Contact support for any questions about your orders or returns.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF1B1B1B).withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'Order Details',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order ID', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
                            Text(order.id, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: order.statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order.status,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: order.statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Items List
                    Text(
                      'Items',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(item.image, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                Text('Qty: ${item.quantity}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
                              ],
                            ),
                          ),
                          Text('₹${item.price.toStringAsFixed(2)}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                    const Divider(height: 32),
                    // Bill Details
                    Text(
                      'Payment Details',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBillRow('Item Total', '₹${order.total.toStringAsFixed(2)}'),
                    _buildBillRow('Delivery Fee', '₹2.00'), // Mocked
                    _buildBillRow('Tax (5%)', '₹${(order.total * 0.05).toStringAsFixed(2)}'),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
                    _buildBillRow('Grand Total', '₹${(order.total + 2 + order.total * 0.05).toStringAsFixed(2)}', isBold: true),
                    const SizedBox(height: 24),
                    // Address & Payment (Mocked for professional look)
                    Text(
                      'Delivery Address',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppColors.secondaryText, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Consumer<AddressProvider>(
                            builder: (context, addressProvider, child) {
                              final defaultAddress = addressProvider.addresses.firstWhere(
                                (addr) => addr.isDefault,
                                orElse: () => addressProvider.addresses.first,
                              );
                              return Text(defaultAddress.address, style: AppTextStyles.bodyMedium);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Payment Method',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.credit_card, color: AppColors.secondaryText, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Visa **** 4567', style: AppTextStyles.bodyMedium)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Buttons
             Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.primaryText),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Download Invoice', style: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (order.status == 'Delivered') {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => OrderReportEntryScreen(order: order),
                            ),
                          );
                        } else {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumLinearGradient, // Keep premium gradient
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            order.status == 'Delivered' ? 'Report an Issue' : 'Need Help?',
                            style: const TextStyle(color: const Color(0xFFE65100), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold) : AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText)),
          Text(value, style: isBold ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold) : AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
