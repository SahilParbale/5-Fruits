// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';

class AddNewAddressScreen extends StatefulWidget {
  final Address? address;
  const AddNewAddressScreen({super.key, this.address});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  String _selectedType = 'Home';
  bool _isDefault = false;
  
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    if (address != null) {
      _selectedType = address.label;
      _isDefault = address.isDefault;
      _nameController = TextEditingController(text: address.name);
      _phoneController = TextEditingController(text: address.phone);
      
      // Parse address string for simple pre-fill or just put full address in street for now
      // The current mockup is simple, so we'll just put the full address in street if editing
      _streetController = TextEditingController(text: address.address);
      _cityController = TextEditingController();
      _stateController = TextEditingController();
      _zipController = TextEditingController();
    } else {
      _nameController = TextEditingController();
      _phoneController = TextEditingController();
      _streetController = TextEditingController();
      _cityController = TextEditingController();
      _stateController = TextEditingController();
      _zipController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.address != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Address' : 'Add New Address', style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 120), // Bottom padding for sticky button
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildSectionTitle('Address Type'),
                       const SizedBox(height: 16),
                       Row(
                         children: [
                           Expanded(child: _buildTypeOption('Home', Icons.home_rounded, const Color(0xFF1B1B1B))), 
                           const SizedBox(width: 12),
                           Expanded(child: _buildTypeOption('Work', Icons.work_rounded, const Color(0xFF1B1B1B))), 
                           const SizedBox(width: 12),
                           Expanded(child: _buildTypeOption('Other', Icons.location_on_rounded, const Color(0xFF1B1B1B))), 
                         ],
                       ),
                       const SizedBox(height: 32),
                       
                       _buildInputField(
                         'Full Name', 
                         'Enter your full name', 
                         _nameController, 
                         icon: Icons.person_rounded,
                         iconColor: const Color(0xFF1B1B1B),
                       ),
                       _buildInputField(
                         'Phone Number', 
                         '+1 (555) 123-4567', 
                         _phoneController, 
                         keyboardType: TextInputType.phone,
                         icon: Icons.phone_rounded,
                         iconColor: const Color(0xFF1B1B1B),
                       ),
                       _buildInputField(
                         'Street Address', 
                         'House number and street name', 
                         _streetController,
                         icon: Icons.add_road_rounded,
                         iconColor: const Color(0xFF1B1B1B),
                       ),
                       
                       Row(
                         children: [
                           Expanded(child: _buildInputField(
                             'City', 
                             'City', 
                             _cityController,
                             icon: Icons.location_city_rounded,
                             iconColor: const Color(0xFF1B1B1B),
                           )),
                           const SizedBox(width: 16),
                           Expanded(child: _buildInputField(
                             'State', 
                             'State', 
                             _stateController,
                             icon: Icons.map_rounded,
                             iconColor: const Color(0xFF1B1B1B),
                           )),
                         ],
                       ),
                       
                       _buildInputField(
                         'Zip Code', 
                         'Enter zip code', 
                         _zipController, 
                         keyboardType: TextInputType.number,
                         icon: Icons.pin_drop_rounded,
                         iconColor: const Color(0xFF1B1B1B),
                       ),
                       
                       const SizedBox(height: 16),
                       _buildDefaultToggle(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            left: 12,
            right: 12,
            child: _buildSaveButton(isEdit),
          ),
        ],
      ),
    );
  }



  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: const Color(0xFF3B3B3B),
      ),
    );
  }

  Widget _buildTypeOption(String label, IconData icon, Color activeColor) {
    final isSelected = _selectedType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.premiumLinearGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.secondaryText,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? Colors.white : AppColors.secondaryText,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label, 
    String hint, 
    TextEditingController controller, 
    {TextInputType? keyboardType, required IconData icon, required Color iconColor}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3B3B3B),
            fontSize: 13, // Slightly smaller label to emphasize input
          ),
        ),
        const SizedBox(height: 8),
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
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mutedText.withOpacity(0.7)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.premiumLinearGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDefaultToggle() {
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
              gradient: AppColors.premiumLinearGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set as Default Address',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B1B1B),
                  ),
                ),
                Text(
                  'Use this address for checkout',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF1B1B1B).withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isDefault,
            onChanged: (value) {
              setState(() {
                _isDefault = value;
              });
            },
            activeColor: const Color(0xFF1B1B1B),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(bool isEdit) {
    return GestureDetector(
      onTap: () {
        final provider = Provider.of<AddressProvider>(context, listen: false);
        
        final isMom = _selectedType.contains("Mom") || _nameController.text.contains("Mom");
        final addressIcon = _selectedType == 'Home' ? Icons.home_rounded : (_selectedType == 'Work' ? Icons.work_rounded : (isMom ? Icons.favorite_rounded : Icons.location_on_rounded));
        
        final updatedAddress = Address(
          id: isEdit ? widget.address!.id : DateTime.now().millisecondsSinceEpoch.toString(),
          label: _selectedType,
          name: _nameController.text,
          address: _streetController.text,
          phone: _phoneController.text,
          isDefault: _isDefault,
          icon: addressIcon,
          iconColor: Colors.white,
          iconBgColor: const Color(0xFF1B1B1B), // Keep internal model as is, but UI will use gradient
        );

        if (isEdit) {
          provider.updateAddress(updatedAddress);
        } else {
          provider.addAddress(updatedAddress);
        }
        
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppColors.premiumLinearGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            isEdit ? 'Update Address' : 'Save Address',
            style: GoogleFonts.barlowCondensed(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
