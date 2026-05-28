import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/upi_provider.dart';
import '../models/upi_model.dart';

class AddNewUPIScreen extends StatefulWidget {
  final UPIModel? upiToEdit;
  const AddNewUPIScreen({super.key, this.upiToEdit});

  @override
  State<AddNewUPIScreen> createState() => _AddNewUPIScreenState();
}

class _AddNewUPIScreenState extends State<AddNewUPIScreen> {
  String _selectedProvider = 'Google Pay';
  final TextEditingController _upiIdController = TextEditingController();
  bool _isDefault = false;
  bool _isVerified = true;

  @override
  void initState() {
    super.initState();
    if (widget.upiToEdit != null) {
      _selectedProvider = widget.upiToEdit!.providerName;
      _upiIdController.text = widget.upiToEdit!.upiId;
      _isDefault = widget.upiToEdit!.isDefault;
      _isVerified = widget.upiToEdit!.isVerified;
    }
  }

  final List<Map<String, dynamic>> _providers = [
    {
      'name': 'Google Pay',
      'handle': '@okaxis, @oksbi',
      'icon': Icons.radio_button_checked,
      'color': const Color(0xFF4285F4),
    },
    {
      'name': 'PhonePe',
      'handle': '@ybl, @ibl',
      'icon': Icons.radio_button_checked,
      'color': const Color(0xFF673AB7),
    },
    {
      'name': 'Paytm',
      'handle': '@paytm',
      'icon': Icons.radio_button_checked,
      'color': const Color(0xFF00B9F1),
    },
  ];

  @override
  void dispose() {
    _upiIdController.dispose();
    super.dispose();
  }

  Color _getProviderColor(String? name) {
    final provider = _providers.firstWhere((p) => p['name'] == (name ?? _selectedProvider));
    return provider['color'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.upiToEdit != null ? 'Edit UPI ID' : 'Add UPI ID', style: AppTextStyles.titleLarge),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUPICardPreview(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Select UPI Provider'),
                      const SizedBox(height: 12),
                      _buildProviderGrid(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Enter UPI ID'),
                      const SizedBox(height: 12),
                      _buildInputField(),
                      const SizedBox(height: 24),
                      _buildDefaultToggle(),
                      const SizedBox(height: 24),
                      _buildHelpBox(),
                      const SizedBox(height: 120),
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
            child: _buildSaveButton(),
          ),
        ],
      ),
    );
  }



  Widget _buildUPICardPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white, // White background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground, // Light grey for icon bg
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.primaryText, // Dark icon
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROVIDER',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondaryText, // Secondary text
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _selectedProvider,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primaryText, // Dark text
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'UPI ID',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.secondaryText, // Secondary text
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          ValueListenableBuilder(
            valueListenable: _upiIdController,
            builder: (context, value, child) {
              final text = value.text.isEmpty ? 'yourname@bank' : value.text;
              return Text(
                text,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primaryText, // Dark text
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                  fontSize: 16,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.bold,
        color: const Color(0xFF3B3B3B),
      ),
    );
  }

  Widget _buildProviderGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: _providers.length,
      itemBuilder: (context, index) {
        final provider = _providers[index];
        final isSelected = _selectedProvider == provider['name'];
        return GestureDetector(
          onTap: () => setState(() => _selectedProvider = provider['name']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.premiumLinearGradient : null,
              color: isSelected ? null : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withOpacity(0.2) : const Color(0xFF1B1B1B).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    provider['icon'],
                    color: isSelected ? Colors.white : const Color(0xFF1B1B1B),
                    size: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  provider['name'],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  provider['handle'],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.mutedText,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Container(
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
        controller: _upiIdController,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'yourname@bank',
          hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.mutedText.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.premiumLinearGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.alternate_email, color: const Color(0xFFE65100), size: 20),
          ),
          suffixIcon: _isVerified 
              ? const Icon(Icons.check_circle, color: AppColors.primaryGreen) 
              : null,
        ),
      ),
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
            child: const Icon(Icons.star_rounded, color: const Color(0xFFE65100), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set as Default',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B1B1B),
                  ),
                ),
                Text(
                  'Use as my default UPI payment',
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
            onChanged: (value) => setState(() => _isDefault = value),
            activeColor: const Color(0xFF2C3E50), // Midnight Navy
          ),
        ],
      ),
    );
  }

  Widget _buildHelpBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E1E5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              gradient: AppColors.premiumLinearGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, color: const Color(0xFFE65100), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to find your UPI ID?',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF1B1B1B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Open your UPI app (Google Pay, PhonePe, etc.) → Profile → Your UPI ID will be displayed at the top',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF1B1B1B).withOpacity(0.8),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        if (_upiIdController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a UPI ID')),
          );
          return;
        }
        final provider = Provider.of<UPIProvider>(context, listen: false);
        if (widget.upiToEdit != null) {
          provider.updateUPI(
            widget.upiToEdit!.id,
            widget.upiToEdit!.copyWith(
              providerName: _selectedProvider,
              upiId: _upiIdController.text,
              isDefault: _isDefault,
              isVerified: _isVerified,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('UPI ID Updated Successfully!')),
          );
        } else {
          provider.addUPI(UPIModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            providerName: _selectedProvider,
            upiId: _upiIdController.text,
            isDefault: _isDefault,
            isVerified: _isVerified,
          ));
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
            widget.upiToEdit != null ? 'Update UPI ID' : 'Save UPI ID',
            style: GoogleFonts.barlowCondensed(
              color: const Color(0xFFE65100),
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
