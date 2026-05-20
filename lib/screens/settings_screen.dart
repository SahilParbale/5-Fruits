import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/settings_provider.dart';
import 'privacy_policy_screen.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Notifications'),
                      _buildSettingsContainer(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.notifications_none_outlined,
                            iconColor: Colors.white,
                            title: 'Push Notifications',
                            subtitle: 'Receive order updates and offers',
                            trailing: Switch(
                              value: settings.pushNotifications,
                              onChanged: (val) => settings.togglePushNotifications(val),
                              activeColor: const Color(0xFF1B1B1B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSettingsTile(
                            icon: Icons.language,
                            iconColor: Colors.white,
                            title: 'Email Notifications',
                            subtitle: 'Get updates via email',
                            trailing: Switch(
                              value: settings.emailNotifications,
                              onChanged: (val) => settings.toggleEmailNotifications(val),
                              activeColor: const Color(0xFF1B1B1B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSettingsTile(
                            icon: Icons.smartphone_outlined,
                            iconColor: Colors.white,
                            title: 'SMS Notifications',
                            subtitle: 'Delivery alerts via SMS',
                            trailing: Switch(
                              value: settings.smsNotifications,
                              onChanged: (val) => settings.toggleSMSNotifications(val),
                              activeColor: const Color(0xFF1B1B1B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSectionHeader('App Preferences'),
                      _buildSettingsContainer(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.volume_up_outlined,
                            iconColor: Colors.white,
                            title: 'Sound Effects',
                            subtitle: 'Play sounds for actions',
                            trailing: Switch(
                              value: settings.soundEffects,
                              onChanged: (val) => settings.toggleSoundEffects(val),
                              activeColor: const Color(0xFF1B1B1B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSettingsTile(
                            icon: Icons.language,
                            iconColor: Colors.white,
                            title: 'Language',
                            subtitle: 'English (US)',
                            trailing: const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Privacy & Security'),
                      _buildSettingsContainer(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.lock_outline,
                            iconColor: Colors.white,
                            title: 'Biometric Authentication',
                            subtitle: 'Use fingerprint or Face ID',
                            trailing: Switch(
                              value: settings.biometricAuth,
                              onChanged: (val) => settings.toggleBiometricAuth(val),
                              activeColor: const Color(0xFF1B1B1B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSettingsTile(
                            icon: Icons.visibility_outlined,
                            iconColor: Colors.white,
                            title: 'Privacy Policy',
                            subtitle: 'Read our privacy policy',
                            trailing: const Icon(Icons.chevron_right, color: AppColors.secondaryText),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }




  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
      ),
    );
  }

  Widget _buildSettingsContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDefaults.smoothRadius), // 18.0
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            gradient: AppColors.premiumLinearGradient,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondaryText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        trailing,
      ],
    ),
    );
  }

}
