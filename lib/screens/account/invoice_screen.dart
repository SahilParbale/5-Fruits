import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/billing_models.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<InvoiceModel> invoices = [
      InvoiceModel(
        id: 'INV-2024-001',
        orderId: '#ORD-2024-1925',
        date: DateTime.now().subtract(const Duration(days: 1)),
        totalAmount: 450.00,
        gstAmount: 22.50,
        deliveryCharge: 0,
        discount: 0,
        items: [
           InvoiceItem(name: 'Apple', quantity: 2, price: 200, total: 400),
           InvoiceItem(name: 'Banana', quantity: 1, price: 50, total: 50),
        ],
      ),
      InvoiceModel(
        id: 'INV-2024-002',
        orderId: '#ORD-2024-1912',
        date: DateTime.now().subtract(const Duration(days: 5)),
        totalAmount: 120.00,
        gstAmount: 6.00,
        deliveryCharge: 20,
        discount: 20, // Discount coupon
        items: [
           InvoiceItem(name: 'Orange', quantity: 1, price: 100, total: 100),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Invoices & GST', style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
             _buildGSTDetailsCard(),
             const SizedBox(height: 24),
             ...invoices.map((invoice) => _buildInvoiceCard(context, invoice)),
          ],
        ),
      ),
    );
  }

  Widget _buildGSTDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business, color: AppColors.primaryText),
              const SizedBox(width: 12),
              Text('Billing Details', style: AppTextStyles.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          const TextField(
             decoration: InputDecoration(
               labelText: 'GST Number (Optional)',
               border: OutlineInputBorder(),
               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
             ),
          ),
          const SizedBox(height: 12),
           const TextField(
             decoration: InputDecoration(
               labelText: 'Billing Address',
               border: OutlineInputBorder(),
               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
             ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Update Details', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(BuildContext context, InvoiceModel invoice) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invoice #${invoice.id.split('-').last}', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                  Text(DateFormat('MMM dd, yyyy').format(invoice.date), style: AppTextStyles.bodySmall),
                ],
              ),
              Text('₹${invoice.totalAmount.toStringAsFixed(2)}', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
           _buildRow('Order ID', invoice.orderId),
           _buildRow('GST (5%)', '₹${invoice.gstAmount.toStringAsFixed(2)}'),
           if (invoice.deliveryCharge > 0) _buildRow('Delivery', '₹${invoice.deliveryCharge.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading Invoice...')));
            },
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Download PDF'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              side: const BorderSide(color: AppColors.primaryGreen),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
          Text(value, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryText)),
        ],
      ),
    );
  }
}
