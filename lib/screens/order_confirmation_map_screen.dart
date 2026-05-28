import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../models/address_model.dart';
import '../widgets/floating_order_map.dart';

class OrderConfirmationMapScreen extends StatefulWidget {
  final double totalAmount;
  final String paymentMethod;
  final Address? deliveryAddress;
  final int itemCount;

  const OrderConfirmationMapScreen({
    super.key,
    required this.totalAmount,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.itemCount,
  });

  @override
  State<OrderConfirmationMapScreen> createState() => _OrderConfirmationMapScreenState();
}

class _OrderConfirmationMapScreenState extends State<OrderConfirmationMapScreen> with SingleTickerProviderStateMixin {
  int _currentStep = 0; // 0: Confirmed, 1: Preparing, 2: Out for Delivery, 3: Delivered
  int _cancelTimer = 60;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _startCancelTimer();
    
    // Simulate order progress
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _currentStep = 1);
    });
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) setState(() => _currentStep = 2);
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startCancelTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cancelTimer > 0) {
        setState(() => _cancelTimer--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) { // Or onPopInvokedWithResult in newer flutter, we will try onPopInvoked
        if (didPop) return;
        FloatingOrderMapService().show(
          context,
          totalAmount: widget.totalAmount,
          paymentMethod: widget.paymentMethod,
          deliveryAddress: widget.deliveryAddress,
          itemCount: widget.itemCount,
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FB),
        body: Stack(
        children: [
          // 1. Simulated Map Section (Top 60%)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.65, // slightly more to hide under bottom sheet
            child: _buildSimulatedMap(),
          ),

          // Custom App Bar Overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                   onTap: () {
                     FloatingOrderMapService().show(
                       context,
                       totalAmount: widget.totalAmount,
                       paymentMethod: widget.paymentMethod,
                       deliveryAddress: widget.deliveryAddress,
                       itemCount: widget.itemCount,
                     );
                     Navigator.of(context).popUntil((route) => route.isFirst);
                   },
                   child: Container(
                     padding: const EdgeInsets.all(10),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       shape: BoxShape.circle,
                       boxShadow: [
                         BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                       ],
                     ),
                     child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B)),
                   ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                         BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => AppColors.premiumLinearGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: const Icon(Icons.support_agent, size: 18, color: const Color(0xFFE65100)),
                      ),
                      const SizedBox(width: 8),
                      Text('Help', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Sliding Up Bottom Panel
          _buildDraggableBottomSheet(),
        ],
      ),
    ));
  }

  Widget _buildSimulatedMap() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE8F2E9), // Light greenish map base
      ),
      child: Stack(
        children: [
          // Grid lines simulation
          CustomPaint(
            size: Size.infinite,
            painter: _GridPainter(),
          ),
          
          // Route Polyline
          CustomPaint(
            size: Size.infinite,
            painter: _RoutePainter(),
          ),

          // Store Marker
          Positioned(
            top: MediaQuery.of(context).size.height * 0.20,
            left: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                  ),
                  child: Text('FreshHub Store', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.storefront, color: Color(0xFF1B1B1B), size: 32),
              ],
            ),
          ),

          // Customer Marker (Animated)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.45,
            left: MediaQuery.of(context).size.width * 0.65,
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumLinearGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)],
                    ),
                    child: Text('4.2 km', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFE65100))),
                  ),
                  const SizedBox(height: 4),
                  Container(
                     padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       shape: BoxShape.circle,
                       border: Border.all(color: const Color(0xFF1B1B1B), width: 2),
                     ),
                     child: ShaderMask(
                       shaderCallback: (bounds) => AppColors.premiumLinearGradient.createShader(
                         Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                       ),
                       child: const Icon(Icons.home, color: const Color(0xFFE65100), size: 24),
                     ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.45,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white, // Changed back to white
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 20),
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                
                // Delivery ETA header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated Delivery',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => AppColors.premiumLinearGradient.createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                            child: Text(
                              '25 - 30 mins',
                              style: GoogleFonts.barlowCondensed(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFE65100), // The color must be white for ShaderMask to apply gradient correctly
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F5),
                          shape: BoxShape.circle,
                        ),
                        child: ShaderMask(
                            shaderCallback: (bounds) => AppColors.premiumLinearGradient.createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                            child: const Icon(Icons.timer_outlined, color: const Color(0xFFE65100), size: 28),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Order Stepper
                _buildTimelineStepper(),
                
                const Divider(height: 32, thickness: 8, color: Color(0xFFF6F8FB)),

                // Order Summary
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                          shaderCallback: (bounds) => AppColors.premiumLinearGradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: Text('Order Details', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFE65100))),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.receipt_long, 'Order ID', '#ORD-12893'),
                      _buildInfoRow(Icons.shopping_bag_outlined, 'Items', '${widget.itemCount} Items'),
                      _buildInfoRow(Icons.location_on_outlined, 'Delivery Address', widget.deliveryAddress?.label ?? 'Home'),
                    ],
                  ),
                ),

                const Divider(height: 32, thickness: 8, color: Color(0xFFF6F8FB)),

                // Payment Status
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                          shaderCallback: (bounds) => AppColors.premiumLinearGradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: Text('Payment details', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFE65100))),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE1E1E5)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: widget.paymentMethod == 'COD' ? Colors.orange.withOpacity(0.1) : const Color(0xFF1B1B1B).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: widget.paymentMethod == 'COD'
                                ? const Icon(Icons.money, color: Colors.orange)
                                : ShaderMask(
                                    shaderCallback: (bounds) => AppColors.premiumLinearGradient.createShader(
                                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                                    ),
                                    child: const Icon(Icons.check_circle, color: const Color(0xFFE65100)),
                                  ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.paymentMethod == 'COD' ? 'Cash on Delivery' : 'Paid securely via ${widget.paymentMethod}',
                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '₹${widget.totalAmount.toStringAsFixed(2)}',
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 32, thickness: 8, color: Color(0xFFF6F8FB)),
                
                // Cancellation & Safety
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4F4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFEBEE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cancel_outlined, color: Colors.red),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text('Free Cancellation', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: Colors.red)),
                               Text(
                                 _cancelTimer > 0 
                                   ? 'You can cancel within $_cancelTimer seconds without charges.'
                                   : 'Free cancellation window has expired.',
                                 style: AppTextStyles.bodySmall.copyWith(color: Colors.red.withOpacity(0.8), fontSize: 11),
                               ),
                            ],
                          ),
                        ),
                        if (_cancelTimer > 0)
                          TextButton(
                            onPressed: () {
                               // Handle Cancel
                               Navigator.pop(context);
                            },
                            child: Text('Cancel', style: AppTextStyles.bodyMedium.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
                          )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimelineStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildStepRow(0, 'Order Confirmed', 'Your order has been placed successfully.', Icons.receipt_long),
          _buildStepConnector(0),
          _buildStepRow(1, 'Preparing', 'The store is packing your items.', Icons.inventory_2_outlined),
          _buildStepConnector(1),
          _buildStepRow(2, 'Out for Delivery', 'Delivery partner is on the way.', Icons.delivery_dining_outlined),
          _buildStepConnector(2),
          _buildStepRow(3, 'Delivered', 'Your order has arrived.', Icons.home_outlined, isLast: true),
        ],
      ),
    );
  }

  Widget _buildStepRow(int stepIndex, String title, String subtitle, IconData icon, {bool isLast = false}) {
    final isActive = _currentStep >= stepIndex;
    final isCurrent = _currentStep == stepIndex;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: isActive ? AppColors.premiumLinearGradient : null,
                color: !isActive ? const Color(0xFFF1F1F5) : null,
                shape: BoxShape.circle,
                border: isActive ? Border.all(color: Colors.black.withOpacity(0.3), width: 4) : null,
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : AppColors.secondaryText,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.primaryText : AppColors.secondaryText,
                  ),
                ),
                if (isCurrent || isActive) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                  ),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(int stepIndex) {
    final isActive = _currentStep > stepIndex;
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 0, bottom: 0), // align with center of 40px circle
      alignment: Alignment.centerLeft,
      child: Container(
        width: 2,
        height: 30,
        decoration: BoxDecoration(
          color: isActive ? null : const Color(0xFFE1E1E5),
          gradient: isActive ? AppColors.premiumLinearGradient : null,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
           Icon(icon, color: AppColors.secondaryText, size: 20),
           const SizedBox(width: 12),
           Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText)),
           const Spacer(),
           Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// Custom Painter for Map Grid
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    double gridSpace = 40;
    for (double i = 0; i < size.width; i += gridSpace) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gridSpace) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Route Polyline
class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFF1B1B1B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    var path = Path();
    // Start at Store Marker position (approx)
    path.moveTo(size.width * 0.35, size.height * 0.25);
    // Draw some curves to Customer marker position (approx)
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.25, size.width * 0.5, size.height * 0.35);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.45, size.width * 0.65, size.height * 0.45);

    // Draw dashed path effect
    final dashPaint = Paint()
       ..color = const Color(0xFF1B1B1B)
       ..style = PaintingStyle.stroke
       ..strokeWidth = 4
       ..strokeCap = StrokeCap.round;

    double dashWidth = 10, dashSpace = 8, startY = 0;
    // Basic dash drawing (approximate path length)
    // For a real dashed path, we'd use path_metrics, but here we just draw the solid path for premium look.
    // Instead of dashes, let's draw a glowing trail
    
    var glowPaint = Paint()
      ..color = const Color(0xFF1B1B1B).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
