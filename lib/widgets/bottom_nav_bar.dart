import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _buildNavItem(int index, IconData icon, String label, {int badgeCount = 0}) {
    final bool isSelected = currentIndex == index;
    IconData displayIcon = icon;
    
    // Icon logic based on index
    if (index == 0) displayIcon = isSelected ? Icons.home : Icons.home_outlined;
    if (index == 1) displayIcon = isSelected ? Icons.grid_view_rounded : Icons.grid_view;
    if (index == 2) displayIcon = isSelected ? Icons.list_alt : Icons.list_alt_outlined;
    if (index == 3) displayIcon = isSelected ? Icons.person : Icons.person_outline;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 18 : 12, 
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFFFE082) // Solid light yellow active tab background
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFFFFE082).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  displayIcon,
                  size: 24,
                  color: isSelected ? const Color(0xFFE65100) : const Color(0xFF8D8D8D),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF57C00),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.barlowCondensed(
                  color: const Color(0xFFE65100),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF7).withOpacity(0.9),
              borderRadius: BorderRadius.circular(38),
              border: Border.all(
                color: const Color(0xFFEAE5D9),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, Icons.home, 'Home'),
                _buildNavItem(1, Icons.grid_view, 'Categories'),
                _buildNavItem(2, Icons.list_alt, 'Items'),
                _buildNavItem(3, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
