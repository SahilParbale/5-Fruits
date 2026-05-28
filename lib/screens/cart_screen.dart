import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/address_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback? onStartShopping;

  const CartScreen({
    super.key,
    required this.onBack,
    this.onStartShopping,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background, // F6F7F9
      body: SafeArea(
        child: Column(
          children: [

            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (cart.items.isEmpty)
                      _buildEmptyCartView(context)
                    else
                      ...cart.items.values.map((item) => Column(
                        children: [
                          _buildCartItem(
                            context,
                            id: item.id,
                            name: item.name,
                            weight: item.size,
                            price: item.price,
                            quantity: item.quantity,
                            image: item.image,
                            isUrl: item.image.startsWith('http'),
                          ),
                          const SizedBox(height: 16),
                        ],
                      )).toList(),

                    if (cart.items.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildFreeDeliveryProgress(cart.totalAmount),
                      const SizedBox(height: 32),
                      // Removed Delivery Time, Address, Instructions, Tip, Payment sections as per request
                      _buildPromoCodeSection(),
                      const SizedBox(height: 24),
                      _buildOrderSummarySection(cart.totalAmount),
                      const SizedBox(height: 24),
                    ]
                  ],
                ),
              ),
            ),
            if (cart.items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: _buildCheckoutButton(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 80),
          Text(
            'My Cart',
            style: AppTextStyles.titleLarge.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3B3B3B),
            ),
          ),
          const SizedBox(width: 80),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context, {
    required String id,
    required String name,
    required String weight,
    required double price,
    required int quantity,
    required String image,
    bool isUrl = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius),
        // Soft shadow as per design
        boxShadow: [
           BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isUrl 
              ? Image.network(image, width: 80, height: 80, fit: BoxFit.cover)
              : Image.asset(image, width: 80, height: 80, fit: BoxFit.cover, 
                  errorBuilder: (c,e,s) => Container(width:80, height:80, color: Colors.grey[200])),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Delete Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name, 
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold, // Bold Title
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                         Provider.of<CartProvider>(context, listen: false).removeItem(id);
                      },
                      child: const Icon(Icons.delete_outline, color: Color(0xFFFF7B6A), size: 22),
                    ), // Red trash icon
                  ],
                ),
                Text(
                  weight, 
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                  )
                ),
                const SizedBox(height: 12),
                // Price and Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${price.toStringAsFixed(2)}',
                      style: GoogleFonts.barlowCondensed(
                         fontSize: 22,
                         fontWeight: FontWeight.bold,
                         color: AppColors.primaryText,
                      ),
                    ),
                    Row(
                      children: [
                        _buildQuantityButton(context, Icons.remove, id, isAdd: false),
                        const SizedBox(width: 14),
                        Text(
                          '$quantity', 
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 14),
                        _buildQuantityButton(context, Icons.add, id, isAdd: true),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(BuildContext context, IconData icon, String id, {bool isAdd = false}) {
    return GestureDetector(
      onTap: () {
        if (isAdd) {
           final item = Provider.of<CartProvider>(context, listen: false).items[id];
           if (item != null) {
             Provider.of<CartProvider>(context, listen: false).addItem(item.id, item.name, item.price, item.image, item.size);
           }
        } else {
           Provider.of<CartProvider>(context, listen: false).removeSingleItem(id);
        }
      },
      child: Container(
        width: 30, // Slightly smaller/compact
        height: 30,
        decoration: BoxDecoration(
          gradient: isAdd ? AppColors.premiumLinearGradient : null,
          color: isAdd ? null : Colors.white,
          shape: BoxShape.circle,
          // Border for minus button
          border: isAdd ? null : Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: isAdd 
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
            : [], // No shadow for minus, or very subtle
        ),
        child: Center(
          child: Icon(
            icon,
            size: 18,
            color: isAdd ? Colors.white : const Color(0xFF979899), // White for add, Grey for remove
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCodeInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer_outlined, color: AppColors.secondaryText, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            gradient: AppColors.premiumLinearGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B1B1B).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Apply',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFFE65100),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCodeSection() {
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
          Text(
            'Promo Code', 
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 18, 
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 12),
          _buildPromoCodeInput(),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection(double subtotal) {
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
          Text(
            'Order Summary', 
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 16),
          _buildOrderSummaryContent(subtotal),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryContent(double subtotal) {
    final deliveryFee = 2.50;
    final platformFee = 0.99;
    final handlingCharge = 0.50;
    final total = subtotal + deliveryFee + platformFee + handlingCharge;

    return Column(
      children: [
        _buildSummaryRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
        const SizedBox(height: 12),
        _buildSummaryRow('Delivery Fee', '₹${deliveryFee.toStringAsFixed(2)}'),
        const SizedBox(height: 12),
        _buildSummaryRow('Platform Fee', '₹${platformFee.toStringAsFixed(2)}'),
        const SizedBox(height: 12),
        _buildSummaryRow('Handling Charge', '₹${handlingCharge.toStringAsFixed(2)}'),
        const SizedBox(height: 16),
        Divider(color: Colors.black.withOpacity(0.05), thickness: 1),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '₹${total.toStringAsFixed(2)}',
              style: GoogleFonts.barlowCondensed(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B1B1B), 
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF979899), // Secondary text color
            fontSize: 16,
          )
        ),
        Text(
          value, 
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primaryText
          )
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CheckoutScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppColors.premiumLinearGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Proceed to Checkout',
            style: AppTextStyles.titleMedium.copyWith(
              color: const Color(0xFFE65100),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  // --- New Feature Widgets ---

  Widget _buildFreeDeliveryProgress(double subtotal) {
    final freeDeliveryThreshold = 20.00; // Example
    final remaining = freeDeliveryThreshold - subtotal;
    final progress = subtotal / freeDeliveryThreshold;

    if (remaining <= 0) {
      return Container(
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
           color: const Color(0xFF1B1B1B).withOpacity(0.08), // Light charcoal bg
           borderRadius: BorderRadius.circular(16),
         ),
         child: Row(
           children: [
             const Icon(Icons.check_circle, color: Color(0xFF1B1B1B), size: 20),
             const SizedBox(width: 8),
             Text(
               'You have qualified for FREE delivery!',
               style: AppTextStyles.bodyMedium.copyWith(
                 fontWeight: FontWeight.bold,
                 color: const Color(0xFF1B1B1B),
               ),
             ),
           ],
         ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0), // Light orange bg
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.5), style: BorderStyle.none), // Optional border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars_rounded, color: Color(0xFFFF9800), size: 20),
              const SizedBox(width: 8),
              Text(
                'Add ₹${remaining.toStringAsFixed(2)} more for FREE delivery!',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE65100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress > 1 ? 1 : progress,
              backgroundColor: const Color(0xFFFFE0B2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your order is ₹${remaining.toStringAsFixed(2)} away from free delivery',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(Icons.access_time, 'Delivery Time'),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSelectionChip('30-40 min', isSelected: true),
              const SizedBox(width: 12),
              _buildSelectionChip('1-2 hours', isSelected: false),
              const SizedBox(width: 12),
              _buildSelectionChip('Schedule', isSelected: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         _buildSectionTitle(Icons.location_on_outlined, 'Deliver to'),
         const SizedBox(height: 12),
         Container(
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
           child: Row(
             children: [
               Container(
                 padding: const EdgeInsets.all(10),
                 decoration: const BoxDecoration(
                   color: Color(0xFFE1F5FE),
                   shape: BoxShape.circle,
                 ),
                 child: const Icon(Icons.location_on_outlined, color: Color(0xFF29B6F6)),
               ),
               const SizedBox(width: 16),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('Home', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                     const SizedBox(height: 4),
                     Consumer<AddressProvider>(
                       builder: (context, addressProvider, child) {
                         final defaultAddress = addressProvider.addresses.firstWhere(
                           (addr) => addr.isDefault,
                           orElse: () => addressProvider.addresses.first,
                         );
                         return Text(
                           defaultAddress.address.split(',').take(2).join(', '),
                           style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                         );
                       },
                     ),
                   ],
                 ),
               ),
               const Icon(Icons.chevron_right, color: AppColors.secondaryText),
             ],
           ),
         ),
      ],
    );
  }

  Widget _buildDeliveryInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(null, 'Delivery Instructions'), // Title only
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSelectionChip('Leave at door', isSelected: false, isSmall: true),
              const SizedBox(width: 12),
              _buildSelectionChip('Ring bell', isSelected: true, isSmall: true), // Example selection
              const SizedBox(width: 12),
              _buildSelectionChip('Avoid calling', isSelected: false, isSmall: true),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Add other instructions...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText),
              border: InputBorder.none,
            ),
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildTipSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
             const Icon(Icons.attach_money, color: Color(0xFFFFB300), size: 20),
             const SizedBox(width: 8),
             Text(
               'Tip Your Delivery Partner',
               style: AppTextStyles.titleMedium.copyWith(
                 fontWeight: FontWeight.bold,
                 fontSize: 16,
               ),
             ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
           padding: const EdgeInsets.all(16),
           decoration: BoxDecoration(
             color: const Color(0xFFFFF8E1), // Light yellow/gold
             borderRadius: BorderRadius.circular(16),
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 '100% of your tip goes to the delivery partner',
                 style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
               ),
               const SizedBox(height: 16),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   _buildTipButton('₹1', false),
                   _buildTipButton('₹2', false),
                   _buildTipButton('₹3', false),
                   _buildTipButton('Other', true),
                 ],
               ),
             ],
           ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(Icons.payment, 'Payment Method'),
        const SizedBox(height: 12),
        Container(
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFEDE7F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.credit_card, color: Color(0xFF673AB7)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Visa •••• 4532', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      'Default payment method',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.secondaryText),
            ],
          ),
        ),
      ],
    );
  }



  // --- Helpers ---

  Widget _buildSectionTitle(IconData? icon, String title) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColors.primaryText, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionChip(String label, {required bool isSelected, bool isSmall = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: isSmall ? 8 : 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryGreen : Colors.white, // Green if selected, white if not
        borderRadius: BorderRadius.circular(30),
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? Colors.white : AppColors.primaryText,
          fontWeight: FontWeight.bold,
          fontSize: isSmall ? 13 : 14,
        ),
      ),
    );
  }

  Widget _buildTipButton(String label, bool isSelected) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFD54F) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isSelected)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
      ),
    );
  }
  Widget _buildEmptyCartView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE082).withOpacity(0.5), // Pale Gold
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: Color(0xFFE65100), // Deep Orange
                ),
                 Positioned(
                  right: 32,
                  bottom: 32,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      shape: BoxShape.circle,
                      boxShadow: [
                         BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Orange shadow
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    ),
                     child: const Icon(
                      Icons.inventory_2_outlined, // Box icon
                      size: 20,
                      color: Color(0xFFE65100),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Title
            Text(
              'Your cart is empty',
              style: AppTextStyles.headlineMedium.copyWith(
                fontSize: 24,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Subtitle
            Text(
              'Looks like you haven\'t added anything to\nyour cart yet',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Button
            Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.premiumLinearGradient, // Charcoal Gradient
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B1B1B).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onStartShopping ?? onBack,
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Start Shopping',
                          style: GoogleFonts.barlowCondensed(
                            color: const Color(0xFFE65100),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: const Color(0xFFE65100),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
