import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';
import '../theme/app_theme.dart';
import '../screens/add_new_address_screen.dart';
import 'dart:math' as math;
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';

class AddressBottomSheet extends StatelessWidget {
  const AddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select delivery location',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3B3B3B),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black87, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.black54),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for area, street name...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action Items Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildActionTile(
                          icon: Icons.my_location,
                          iconColor: AppColors.primaryGreen,
                          title: 'Use current location',
                          titleColor: AppColors.primaryGreen,
                          subtitle: 'Tap to fetch auto location',
                          onTap: () {
                            _fetchAndSetGPSLocation(context);
                          },
                        ),
                        const Divider(height: 1),
                        _buildActionTile(
                          icon: Icons.add,
                          iconColor: const Color(0xFF2E4035),
                          title: 'Add new address',
                          titleColor: const Color(0xFF2E4035),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddNewAddressScreen()),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        _buildActionTile(
                          customIcon: _buildWhatsAppIcon(),
                          title: 'Request address from someone else',
                          titleColor: const Color(0xFF3B3B3B),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Your saved addresses',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: const Color(0xFF3B3B3B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Saved Addresses List
                  Consumer<AddressProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        children: provider.addresses.map((address) {
                          return GestureDetector(
                            onTap: () {
                              provider.setDefault(address.id);
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black87, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    address.label.toLowerCase() == 'home' 
                                      ? Icons.home 
                                      : Icons.work,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            address.label,
                                            style: AppTextStyles.titleMedium.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          if (address.isDefault)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.black87,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                'Default',
                                                style: AppTextStyles.bodySmall.copyWith(
                                                  color: const Color(0xFFE65100),
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        address.address,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    IconData? icon,
    Color? iconColor,
    Widget? customIcon,
    required String title,
    required Color titleColor,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            if (customIcon != null)
              customIcon
            else if (icon != null)
              Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatsAppIcon() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF25D366),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: const Icon(Icons.chat_bubble, color: const Color(0xFFE65100), size: 18),
            ),
            const Icon(Icons.call, color: Color(0xFF25D366), size: 10),
          ],
        ),
      ),
    );
  }

  void _fetchAndSetGPSLocation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fetching current GPS location...'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.black87,
      ),
    );

    try {
      html.window.navigator.geolocation.getCurrentPosition(enableHighAccuracy: true).then((position) {
        final double lat = position.coords?.latitude?.toDouble() ?? 19.0269;
        final double lng = position.coords?.longitude?.toDouble() ?? 73.0698;
        
        // Close bottom sheet first
        Navigator.pop(context);
        
        _reverseGeocodeAndSetAddress(context, lat, lng);
      }).catchError((error) {
        debugPrint('[GPS BottomSheet] Failed to get position: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $error')),
        );
      });
    } catch (e) {
      debugPrint('[GPS BottomSheet] Geolocation error: $e');
    }
  }

  Future<void> _reverseGeocodeAndSetAddress(BuildContext context, double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse('${AuthProvider.baseUrl}/geocode/reverse?latitude=$lat&longitude=$lng'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final resolvedAddress = data['address'] as String;
        
        Provider.of<AddressProvider>(context, listen: false)
            .setDetectedGPSAddress(resolvedAddress, lat, lng);
            
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location updated: $resolvedAddress'),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('[GPS BottomSheet] Error reverse geocoding: $e');
    }
  }
}
