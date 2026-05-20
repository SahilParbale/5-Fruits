import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../models/address_model.dart';
import '../providers/upi_provider.dart';
import '../models/upi_model.dart';
import '../providers/address_provider.dart';
import 'order_confirmation_map_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'COD'; // 'Pay App', 'UPI' or 'COD'
  int _selectedTip = 0;
  final TextEditingController _customTipController = TextEditingController();
  Address? _selectedAddress;
  String? _selectedPayApp;

  @override
  void initState() {
    super.initState();
    // Initialize with default address
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      setState(() {
        _selectedAddress = addressProvider.addresses.firstWhere((a) => a.isDefault, orElse: () => addressProvider.addresses.first);
      });
    });
  }

  @override
  void dispose() {
    _customTipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final taxes = 1.48;
    final totalAmount = cart.totalAmount + _selectedTip + taxes;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB), // Light greyish blue
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Checkout',
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildSectionTitle('Order Items'),
                  _buildOrderItemsList(cart),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Tip Delivery Partner'),
                  _buildTipSection(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Payment Method'),
                  _buildPaymentMethodSelector(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Delivery Address'),
                  _buildAddressCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Bill Details'),
                  _buildBillDetails(cart),
                   const SizedBox(height: 24),
                  _buildSafePaymentBanner(),
                ],
              ),
            ),
          ),
          _buildBottomBar(totalAmount),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1B1B1B),
        ),
      ),
    );
  }


  Widget _buildOrderItemsList(CartProvider cart) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items.values.toList()[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
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
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.image.startsWith('http')
                  ? Image.network(item.image, width: 64, height: 64, fit: BoxFit.cover)
                  : Image.asset(item.image, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(width:64, height:64, color: Colors.grey[200])),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.size, // Assuming size holds weight like '1 Kg'
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 4),
                    Container(
                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                       decoration: BoxDecoration(
                         color: const Color(0xFFF1F1F1),
                         borderRadius: BorderRadius.circular(8),
                       ),
                       child: Text(
                         'Qty: ${item.quantity}',
                         style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                       ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedPaymentMethod = 'Pay App');
                    _showPayAppSelectionSheet();
                  },
                  child: _buildPaymentOptionCard(
                    'Pay App',
                    'Quick payment',
                    Icons.account_balance_wallet, // Wallet icon
                    const Color(0xFF1B1B1B),
                    _selectedPaymentMethod == 'Pay App',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedPaymentMethod = 'UPI');
                    _showUPISelectionSheet();
                  },
                  child: _buildPaymentOptionCard(
                    'UPI',
                    'Pay via UPI',
                    Icons.credit_card,
                    const Color(0xFF1B1B1B),
                    _selectedPaymentMethod == 'UPI',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedPaymentMethod = 'COD'),
                  child: _buildPaymentOptionCard(
                    'COD',
                    'Cash Payment',
                    Icons.attach_money,
                    const Color(0xFF1B1B1B),
                    _selectedPaymentMethod == 'COD',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSelectedPaymentDetails(),
      ],
    );
  }

  Widget _buildPaymentOptionCard(String title, String subtitle, IconData icon, Color color, bool isSelected) {
    return Container(
      height: 110, // Slightly shorter to fit 3
      decoration: BoxDecoration(
        gradient: isSelected ? AppColors.premiumLinearGradient : null,
        color: isSelected ? null : Colors.white,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.2) : color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, 
              color: isSelected ? Colors.white : color,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isSelected ? Colors.white : AppColors.primaryText,
            ),
          ),
          if (isSelected) ...[
             const SizedBox(height: 4),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 const Icon(Icons.check, color: Colors.white, size: 12),
                 const SizedBox(width: 4),
                 Text(
                   'Selected',
                   style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontSize: 10),
                 ),
               ],
             )
          ] else ...[
             const SizedBox(height: 4),
             Text(
               subtitle,
               textAlign: TextAlign.center,
               style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText, fontSize: 10),
               maxLines: 1,
               overflow: TextOverflow.ellipsis,
             ),
          ]
        ],
      ),
    );
  }

  Widget _buildSelectedPaymentDetails() {
    // Mock Data based on selection
    String title = '';
    String subtitle = '';
    
    if (_selectedPaymentMethod == 'UPI') {
      if (_selectedPayApp == null) {
        return const SizedBox.shrink();
      }
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Icon(Icons.credit_card, color: Color(0xFF1B1B1B), size: 20),
             const SizedBox(width: 12),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     'UPI Payment',
                     style: AppTextStyles.bodyMedium.copyWith(
                       fontWeight: FontWeight.bold,
                       color: const Color(0xFF1B1B1B),
                     ),
                   ),
                   Text(
                     'Paying via $_selectedPayApp',
                     style: AppTextStyles.bodySmall.copyWith(
                       color: AppColors.secondaryText,
                     ),
                   ),
                 ],
               ),
             ),
          ],
        ),
      );
    } else if (_selectedPaymentMethod == 'Pay App') {
      return const SizedBox.shrink();
    } else if (_selectedPaymentMethod == 'COD') {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Icon(Icons.info_outline, color: Color(0xFF1B1B1B), size: 20),
             const SizedBox(width: 12),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     'Cash on Delivery',
                     style: AppTextStyles.bodyMedium.copyWith(
                       fontWeight: FontWeight.bold,
                       color: const Color(0xFF1B1B1B),
                     ),
                   ),
                   Text(
                     'Please keep exact change handy to help us serve you better',
                     style: AppTextStyles.bodySmall.copyWith(
                       color: AppColors.secondaryText,
                     ),
                   ),
                 ],
               ),
             ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }


  }

  Widget _buildTipSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: Color(0xFFE91E63), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support your delivery partner',
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '100% of your tip goes directly to them',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTipChip(0, 'None')),
              const SizedBox(width: 8),
              Expanded(child: _buildTipChip(10, '₹10')),
              const SizedBox(width: 8),
              Expanded(child: _buildTipChip(20, '₹20')),
               const SizedBox(width: 8),
              Expanded(child: _buildTipChip(30, '₹30')),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _customTipController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter custom tip amount',
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
             onChanged: (val) {
              if (val.isNotEmpty) {
                 setState(() => _selectedTip = int.tryParse(val) ?? 0);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTipChip(int amount, String label) {
    final isSelected = _selectedTip == amount && _customTipController.text.isEmpty;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTip = amount;
          _customTipController.clear();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.premiumLinearGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFEEEEEE),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.primaryText,
            ),
          ),
        ),
      ),
    );
  }

  void _showUPISelectionSheet() {
    final TextEditingController newUpiController = TextEditingController();
    bool isAdding = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Consumer<UPIProvider>(
              builder: (context, upiProvider, child) {
                final upis = List<UPIModel>.from(upiProvider.upis);
                // Sort: Default first
                upis.sort((a, b) => (b.isDefault ? 1 : 0) - (a.isDefault ? 1 : 0));

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isAdding ? 'Add New UPI ID' : 'Select UPI ID',
                              style: GoogleFonts.barlowCondensed(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1B1B1B),
                              ),
                            ),
                            if (!isAdding)
                              TextButton.icon(
                                onPressed: () => setModalState(() => isAdding = true),
                                icon: const Icon(Icons.add, size: 18, color: Color(0xFF1B1B1B)),
                                label: Text(
                                  'Add',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: const Color(0xFF1B1B1B),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  backgroundColor: const Color(0xFFF1F1F5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                              )
                            else
                              IconButton(
                                onPressed: () {
                                  newUpiController.clear();
                                  setModalState(() => isAdding = false);
                                },
                                icon: const Icon(Icons.close, color: Color(0xFF1B1B1B)),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isAdding)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6F8FB),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE1E1E5)),
                                ),
                                child: TextField(
                                  controller: newUpiController,
                                  autofocus: true,
                                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. janesmith@oksbi',
                                    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText.withOpacity(0.6)),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    prefixIcon: const Icon(Icons.alternate_email, color: Color(0xFF1B1B1B), size: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (newUpiController.text.trim().isNotEmpty) {
                                      final newUpi = UPIModel(
                                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                                        providerName: 'UPI',
                                        upiId: newUpiController.text.trim(),
                                        isDefault: upis.isEmpty,
                                      );
                                      upiProvider.addUPI(newUpi);
                                      newUpiController.clear();
                                      setModalState(() => isAdding = false);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.premiumLinearGradient,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: Text('Save UPI ID', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 260),
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                            itemCount: upis.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final upi = upis[index];
                              
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFE1E1E5),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1B1B1B).withOpacity(0.05),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.credit_card,
                                        color: Color(0xFF1B1B1B),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            upi.upiId,
                                            style: AppTextStyles.titleMedium.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            'Send payment request to ${upi.upiId}',
                                            style: AppTextStyles.bodySmall.copyWith(
                                              color: AppColors.secondaryText,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedPayApp = upi.upiId;
                                        });
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected Payment via ${upi.upiId}')));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1B1B1B),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        minimumSize: const Size(0, 32),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        elevation: 0,
                                      ),
                                      child: const Text('Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showPayAppSelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final List<Map<String, String>> payApps = [
          {'name': 'Google Pay', 'icon': 'google_pay'},
          {'name': 'PhonePe', 'icon': 'phonepe'},
          {'name': 'Paytm', 'icon': 'paytm'},
        ];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Payment App',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Color(0xFF1B1B1B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                itemCount: payApps.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final app = payApps[index];
                  
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE1E1E5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1B1B).withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Color(0xFF1B1B1B),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                app['name']!,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Pay via ${app['name'] == 'Google Pay' ? 'G-Pay' : app['name']}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.secondaryText,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedPayApp = app['name']!;
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Payment via ${app['name']}...')));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(60, 32),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: AppColors.premiumLinearGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Pay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddressSelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer<AddressProvider>(
          builder: (context, addressProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Address',
                        style: GoogleFonts.barlowCondensed(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B1B1B),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Color(0xFF1B1B1B)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    itemCount: addressProvider.addresses.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final address = addressProvider.addresses[index];
                      final isSelected = _selectedAddress?.id == address.id;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAddress = address;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF1B1B1B).withOpacity(0.02) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF1B1B1B) : const Color(0xFFE1E1E5),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1B1B1B).withOpacity(isSelected ? 1 : 0.05),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  address.icon,
                                  color: isSelected ? Colors.white : const Color(0xFF1B1B1B),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          address.label,
                                          style: AppTextStyles.titleMedium.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        if (address.isDefault) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1B1B1B).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'Default',
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: const Color(0xFF1B1B1B),
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      address.address,
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle, color: Color(0xFF1B1B1B), size: 24),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAddressCard() {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        // Fallback to default address if _selectedAddress is null
        final displayAddress = _selectedAddress ?? 
            addressProvider.addresses.firstWhere((a) => a.isDefault, orElse: () => addressProvider.addresses.first);
            
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showAddressSelectionSheet,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B1B1B).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(displayAddress.icon, color: const Color(0xFF1B1B1B)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(displayAddress.label, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                              if (displayAddress.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B1B1B),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('Default', style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontSize: 10)),
                                ),
                              ],
                            ],
                          ),
                          Text(displayAddress.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
                          Text(
                            displayAddress.address,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            displayAddress.phone,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.secondaryText),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBillDetails(CartProvider cart) {
    final subtotal = cart.totalAmount;
    final deliveryFee = 0.0; // Assuming free as per image
    final taxes = 1.48;
    // Note: In real app, calculate taxes properly
    final total = subtotal + _selectedTip + taxes;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
          _buildBillRow('Item Total', '₹${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildBillRow('Delivery Fee', 'FREE', isGreen: false),
          const SizedBox(height: 12),
          _buildBillRow('Taxes & Fees', '₹$taxes'),
           if (_selectedTip > 0) ...[
             const SizedBox(height: 12),
             _buildBillRow('Delivery Tip', '₹$_selectedTip'),
           ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'To Pay',
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${total.toStringAsFixed(2)}',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                   Text(
                    'Inclusive of all taxes',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildBillRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText)),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isGreen ? const Color(0xFF1B1B1B) : AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildSafePaymentBanner() {
    return Container(
       margin: const EdgeInsets.symmetric(horizontal: 16),
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(
         color: const Color(0xFFF1F1F5),
         borderRadius: BorderRadius.circular(12),
         border: Border.all(color: const Color(0xFFE1E1E5)),
       ),
       child: Row(
         children: [
           const Icon(Icons.verified_user_outlined, color: Color(0xFF1B1B1B)),
           const SizedBox(width: 12),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('Safe & Secure Payment', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                 Text(
                   'Your payment information is encrypted and secure', 
                   style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText, fontSize: 11),
                 ),
               ],
             ),
           ),
         ],
       ),
    );
  }

  Widget _buildBottomBar(double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Professional Delivery Info Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B1B).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_filled, size: 14, color: Color(0xFF1B1B1B)),
                    const SizedBox(width: 6),
                    Text(
                      'Arriving in 25 - 30 mins',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Amount', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText, fontSize: 11)),
                    Text(
                      '₹${total.toStringAsFixed(2)}',
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                     onTap: () {
                         // Extract cart inside callback context if needed or use the already built cart
                         final cartProvider = Provider.of<CartProvider>(context, listen: false);
                         // Push to new Order Confirmation Map Screen
                         Navigator.of(context).pushReplacement(
                           MaterialPageRoute(
                             builder: (context) => OrderConfirmationMapScreen(
                               totalAmount: total,
                               paymentMethod: _selectedPaymentMethod,
                               deliveryAddress: _selectedAddress,
                               itemCount: cartProvider.items.length,
                             ),
                           ),
                         );
                     },
                     child: Container(
                       height: 54,
                       decoration: BoxDecoration(
                         gradient: AppColors.premiumLinearGradient,
                         borderRadius: BorderRadius.circular(12),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(0.3),
                             blurRadius: 10,
                             offset: const Offset(0, 5),
                           ),
                         ],
                       ),
                       child: const Center(
                         child: Text(
                           'Place Order',
                           style: TextStyle(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                         ),
                       ),
                     ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'By placing order, you agree to our Terms & Conditions',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText, fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
