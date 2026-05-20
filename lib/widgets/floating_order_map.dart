import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/address_model.dart';
import '../screens/order_confirmation_map_screen.dart';
import '../theme/app_theme.dart';

class FloatingOrderMapService {
  static final FloatingOrderMapService _instance = FloatingOrderMapService._internal();
  factory FloatingOrderMapService() => _instance;
  FloatingOrderMapService._internal();

  OverlayEntry? _overlayEntry;

  bool get isShowing => _overlayEntry != null;

  void show(
    BuildContext context, {
    required double totalAmount,
    required String paymentMethod,
    required Address? deliveryAddress,
    required int itemCount,
  }) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (ctx) => _FloatingOrderMapWidget(
        onTap: () {
          hide();
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (_) => OrderConfirmationMapScreen(
                totalAmount: totalAmount,
                paymentMethod: paymentMethod,
                deliveryAddress: deliveryAddress,
                itemCount: itemCount,
              ),
            ),
          );
        },
        onClose: () => hide(),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _FloatingOrderMapWidget extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onClose;

  const _FloatingOrderMapWidget({
    required this.onTap,
    required this.onClose,
  });

  @override
  State<_FloatingOrderMapWidget> createState() => _FloatingOrderMapWidgetState();
}

class _FloatingOrderMapWidgetState extends State<_FloatingOrderMapWidget> with SingleTickerProviderStateMixin {
  double _top = -1;
  double _left = -1;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
       vsync: this,
       duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_top == -1) {
      final size = MediaQuery.of(context).size;
      _top = size.height - 240;
      _left = size.width - 170;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _top,
      left: _left,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _top += details.delta.dy;
            _left += details.delta.dx;
            
            // Constrain within screen bounds
            final size = MediaQuery.of(context).size;
            if (_top < 50) _top = 50;
            if (_left < 10) _left = 10;
            if (_top > size.height - 200) _top = size.height - 200;
            if (_left > size.width - 160) _left = size.width - 160;
          });
        },
        onTap: widget.onTap,
        child: Material(
          color: Colors.transparent,
          elevation: 12,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 150,
            height: 180,
            decoration: BoxDecoration(
              gradient: AppColors.premiumLinearGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFFF39C12).withOpacity(0.15), // Premium orange glow
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    // Top: Map snippet
                    Expanded(
                      child: ClipRRect(
                         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                         child: Stack(
                           children: [
                             // Simulated Map Base
                             Container(color: Colors.white),
                             Transform.scale(
                               scale: 1.5,
                               child: CustomPaint(
                                 size: const Size(150, 120),
                                 painter: _MiniMapPainter(),
                               ),
                             ),
                             // Blur fade effect at the bottom of the map
                             Positioned(
                               bottom: 0,
                               left: 0, 
                               right: 0,
                               height: 30,
                               child: Container(
                                 decoration: BoxDecoration(
                                   gradient: LinearGradient(
                                     begin: Alignment.topCenter,
                                     end: Alignment.bottomCenter,
                                     colors: [Colors.white.withOpacity(0.0), Colors.white],
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ),
                      ),
                    ),
                    // Bottom: ETA text
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Arriving in',
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white70, fontSize: 11),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '25 mins',
                            style: GoogleFonts.barlowCondensed(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Close button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                    ),
                  ),
                ),
                // Pulse indicator
                Positioned(
                  top: 40,
                  left: 60,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.2).animate(_pulseController),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF27AE60),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF27AE60).withOpacity(0.4), blurRadius: 8, spreadRadius: 2)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Grid
    var gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
    // Route Polyline
    var path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.3, size.width * 0.6, size.height * 0.8);
    
    var glowPaint = Paint()
      ..color = const Color(0xFF1B1B1B).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
      
    var paint = Paint()
      ..color = const Color(0xFF1B1B1B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
      
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
