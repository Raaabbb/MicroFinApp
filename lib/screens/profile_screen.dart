import 'package:flutter/material.dart';
import '../main.dart' show isDarkMode;
import '../theme.dart';
import '../widgets/global_header.dart';
import 'fundline_terms_screen.dart';
import 'fundline_help_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Color? brandingColor;
  const ProfileScreen({super.key, this.brandingColor});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsOn = true;

  @override
  Widget build(BuildContext context) {
    final bool dark = AppTheme.isDark(context);
    final Color cardColor = AppTheme.card(context);
    final Color labelColor = AppTheme.lbl(context);
    final Color labelSecColor = AppTheme.lblSecondary(context);
    final Color sepColor = AppTheme.sep(context);
    final Color bgColor = AppTheme.bg(context);
    final Color primaryColor = widget.brandingColor ?? AppTheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          const GlobalHeader(),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _buildAccountSection(
                          cardColor, labelColor, labelSecColor, sepColor, primaryColor),
                      const SizedBox(height: 24),
                      _buildSettingsSection(
                          context, dark, cardColor, labelColor, labelSecColor,
                          sepColor, bgColor, primaryColor),
                      const SizedBox(height: 24),
                      _buildHelpSection(
                          context, cardColor, labelColor, labelSecColor,
                          sepColor, bgColor, primaryColor),
                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(Color cardColor, Color labelColor,
      Color labelSecColor, Color sepColor, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: sepColor, width: 0.8),
        boxShadow: AppTheme.shadow(context),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withOpacity(0.25),
                width: 2,
              ),
              image: const DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Juan Dela Cruz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: labelColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+63 912 345 6789',
                  style: TextStyle(
                    fontSize: 14,
                    color: labelSecColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Fully Verified',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: labelSecColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    bool dark,
    Color cardColor,
    Color labelColor,
    Color labelSecColor,
    Color sepColor,
    Color bgColor,
    Color primaryColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: labelColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: sepColor, width: 0.8),
            boxShadow: AppTheme.shadow(context),
          ),
          child: Column(
            children: [
              _buildListTile(
                Icons.person_outline_rounded,
                'Personal Information',
                labelColor: labelColor,
                labelSecColor: labelSecColor,
                bgColor: bgColor,
                primaryColor: primaryColor,
              ),
              _buildDivider(sepColor),
              _buildListTile(
                Icons.security_rounded,
                'Security & PIN',
                labelColor: labelColor,
                labelSecColor: labelSecColor,
                bgColor: bgColor,
                primaryColor: primaryColor,
              ),
              _buildDivider(sepColor),
              _buildListTile(
                Icons.notifications_outlined,
                'Notifications',
                labelColor: labelColor,
                labelSecColor: labelSecColor,
                bgColor: bgColor,
                primaryColor: primaryColor,
                trailing: _buildSwitch(
                  _notificationsOn,
                  onChanged: (v) => setState(() => _notificationsOn = v),
                  primaryColor: primaryColor,
                ),
              ),
              _buildDivider(sepColor),
              _buildListTile(
                Icons.language_rounded,
                'Language',
                trailingText: 'English',
                labelColor: labelColor,
                labelSecColor: labelSecColor,
                bgColor: bgColor,
                primaryColor: primaryColor,
              ),
              _buildDivider(sepColor),
              // ── Dark Mode Toggle ──
              _buildDarkModeToggle(dark, labelColor, labelSecColor, bgColor, primaryColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDarkModeToggle(
    bool dark,
    Color labelColor,
    Color labelSecColor,
    Color bgColor,
    Color primaryColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 20,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              dark ? 'Dark Mode' : 'Light Mode',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
          ),
          // Animated pill toggle
          GestureDetector(
            onTap: () => isDarkMode.value = !isDarkMode.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeInOut,
              width: 52,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: dark ? primaryColor : AppTheme.separator,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOut,
                alignment:
                    dark ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      dark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                      size: 13,
                      color: dark ? primaryColor : AppTheme.warning,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(
    BuildContext context,
    Color cardColor,
    Color labelColor,
    Color labelSecColor,
    Color sepColor,
    Color bgColor,
    Color primaryColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Help & Support',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: labelColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: sepColor, width: 0.8),
            boxShadow: AppTheme.shadow(context),
          ),
          child: Column(
            children: [
              _buildListTile(
                Icons.help_outline_rounded,
                'FAQ',
                labelColor: labelColor,
                labelSecColor: labelSecColor,
                bgColor: bgColor,
                primaryColor: primaryColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FundlineHelpScreen()),
                ),
              ),
              _buildDivider(sepColor),
              _buildListTile(
                Icons.headset_mic_outlined,
                'Contact Support',
                labelColor: labelColor,
                labelSecColor: labelSecColor,
                bgColor: bgColor,
                primaryColor: primaryColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FundlineHelpScreen()),
                ),
              ),
              _buildDivider(sepColor),
              _buildListTile(
                Icons.policy_outlined,
                'Terms & Privacy Policy',
                labelColor: labelColor,
                labelSecColor: labelSecColor,
                bgColor: bgColor,
                primaryColor: primaryColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const FundlineTermsScreen()),
                ),
              ),
              _buildDivider(sepColor),
              _buildListTile(
                Icons.logout_rounded,
                'Log Out',
                color: AppTheme.danger,
                showChevron: false,
                labelColor: labelColor,
                labelSecColor: labelSecColor,
                bgColor: bgColor,
                primaryColor: primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title, {
    Widget? trailing,
    String? trailingText,
    Color color = Colors.transparent,
    bool showChevron = true,
    VoidCallback? onTap,
    required Color labelColor,
    required Color labelSecColor,
    required Color bgColor,
    required Color primaryColor,
  }) {
    final bool isDanger = color == AppTheme.danger;
    final Color iconBg = isDanger
        ? AppTheme.danger.withOpacity(0.1)
        : primaryColor.withOpacity(0.08);
    final Color iconColor = isDanger ? AppTheme.danger : primaryColor;
    final Color textColor = isDanger ? AppTheme.danger : labelColor;

    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (trailingText != null)
              Row(
                children: [
                  Text(
                    trailingText,
                    style: TextStyle(
                      fontSize: 14,
                      color: labelSecColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            if (showChevron && trailing == null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: labelSecColor.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(Color sepColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 66, right: 20),
      child: Divider(height: 1, color: sepColor),
    );
  }

  Widget _buildSwitch(bool value, {required ValueChanged<bool> onChanged, required Color primaryColor}) {
    return SizedBox(
      height: 24,
      width: 44,
      child: Transform.scale(
        scale: 0.8,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: primaryColor,
        ),
      ),
    );
  }
}
