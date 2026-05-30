import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../../theme/app_theme.dart';
import '../../models/ticket_model.dart';
import '../order_history_screen.dart';
import 'resolution_preference_screen.dart';

class IssueDetailsScreen extends StatefulWidget {
  final OrderModel order;
  final Set<IssueType> selectedIssueTypes;
  final Map<String, int> selectedItems;

  const IssueDetailsScreen({
    super.key,
    required this.order,
    required this.selectedIssueTypes,
    required this.selectedItems,
  });

  @override
  State<IssueDetailsScreen> createState() => _IssueDetailsScreenState();
}

class _IssueDetailsScreenState extends State<IssueDetailsScreen> {
  final List<String> _reasonChips = [];
  final Set<String> _selectedReasons = {};
  final TextEditingController _noteController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _loadReasons();
  }

  void _loadReasons() {
    _reasonChips.clear();
    for (var type in widget.selectedIssueTypes) {
      if (type == IssueType.damaged) {
        _reasonChips.addAll(['Overripe', 'Rotten', 'Leaking', 'Crushed', 'Bad smell']);
      } else if (type == IssueType.wrongProduct) {
        _reasonChips.addAll(['Different fruit', 'Wrong quantity', 'Wrong variant']);
      } else if (type == IssueType.missingItem) {
        _reasonChips.addAll(['Items missing']);
      } else {
         _reasonChips.addAll(['Package open', 'Other']);
      }
    }
    // Remove duplicates if any
    final uniqueReasons = _reasonChips.toSet().toList();
    _reasonChips.clear();
    _reasonChips.addAll(uniqueReasons);
  }

  void _toggleReason(String reason) {
    setState(() {
      if (_selectedReasons.contains(reason)) {
        _selectedReasons.remove(reason);
      } else {
        _selectedReasons.add(reason);
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Issue Details',
          style: GoogleFonts.barlowCondensed(
            color: AppColors.primaryText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Evidence (Recommended)',
              style: GoogleFonts.barlowCondensed(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text('Photos help us resolve issues faster.', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildUploadButton(Icons.camera_alt_outlined, 'Camera', () => _pickImage(ImageSource.camera)),
                const SizedBox(width: 16),
                _buildUploadButton(Icons.image_outlined, 'Gallery', () => _pickImage(ImageSource.gallery)),
              ],
            ),
            if (_selectedImages.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                     return Stack(
                       children: [
                         Container(
                           margin: const EdgeInsets.only(right: 12),
                           width: 100,
                           height: 100,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(12),
                             image: DecorationImage(
                               image: FileImage(_selectedImages[index]),
                               fit: BoxFit.cover,
                             ),
                           ),
                         ),
                         Positioned(
                           top: -4,
                           right: 8,
                           child: IconButton(
                             icon: const Icon(Icons.remove_circle, color: Colors.red),
                             onPressed: () => _removeImage(index),
                             padding: EdgeInsets.zero,
                             constraints: const BoxConstraints(),
                           ),
                         ),
                       ],
                     );
                  },
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'What exactly is wrong?',
              style: GoogleFonts.barlowCondensed(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
             const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _reasonChips.map((reason) {
                final isSelected = _selectedReasons.contains(reason);
                return FilterChip(
                  label: Text(reason),
                  selected: isSelected,
                  onSelected: (_) => _toggleReason(reason),
                  selectedColor: const Color(0xFF2C3E50).withOpacity(0.1),
                  checkmarkColor: const Color(0xFF2C3E50),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF2C3E50) : AppColors.primaryText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF2C3E50) : Colors.grey[300]!,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Add a note (Optional)',
              style: GoogleFonts.barlowCondensed(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 4,
              cursorColor: const Color(0xFF2C3E50),
              decoration: InputDecoration(
                hintText: 'Describe the issue...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2C3E50), width: 1.5)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.premiumLinearGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResolutionPreferenceScreen(
                         order: widget.order,
                         selectedIssueTypes: widget.selectedIssueTypes,
                         selectedItems: widget.selectedItems,
                         selectedReasons: _selectedReasons.toList(),
                         description: _noteController.text,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Next: Resolution',
                  style: GoogleFonts.barlowCondensed(
                    color: const Color(0xFFE65100),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF2C3E50), size: 32),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}
