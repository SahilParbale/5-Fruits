import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';
import '../theme/app_theme.dart';
import '../screens/add_new_address_screen.dart';
import 'dart:math' as math;
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
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.secondaryText),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for area, street name...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mutedText),
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
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildActionTile(
                          icon: Icons.my_location,
                          iconColor: const Color(0xFFE65100),
                          title: 'Use current location',
                          titleColor: const Color(0xFFE65100),
                          subtitle: 'Tap to fetch auto location',
                          onTap: () {
                            _fetchAndSetGPSLocation(context);
                          },
                        ),
                        Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                        _buildActionTile(
                          icon: Icons.add,
                          iconColor: AppColors.primaryText,
                          title: 'Add new address',
                          titleColor: AppColors.primaryText,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddNewAddressScreen()),
                            );
                          },
                        ),
                        Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                        _buildActionTile(
                          customIcon: _buildWhatsAppIcon(),
                          title: 'Request address from someone else',
                          titleColor: AppColors.primaryText,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Your saved addresses',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
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
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    gradient: AppColors.premiumLinearGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    address.label.toLowerCase() == 'home' 
                                      ? Icons.home_rounded 
                                      : Icons.work_rounded,
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
                                              style: AppTextStyles.bodyMedium.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: AppColors.primaryText,
                                              ),
                                          ),
                                          if (address.isDefault)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                gradient: AppColors.premiumLinearGradient,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.check, color: const Color(0xFFE65100), size: 12),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Default',
                                                    style: AppTextStyles.bodySmall.copyWith(
                                                      color: const Color(0xFFE65100),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        address.address,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.secondaryText,
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
      // Stubbed out for mobile since dart:html is not supported.
      // In a real app, use the `geolocator` package.
      final double lat = 19.0269;
      final double lng = 73.0698;
      
      // Close bottom sheet first
      Navigator.pop(context);
      
      _reverseGeocodeAndSetAddress(context, lat, lng);
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
