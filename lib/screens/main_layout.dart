import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard_screen.dart';
import 'applications_screen.dart';
import 'profile_screen.dart';
import 'support_screen.dart';
import '../theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ApplicationsScreen(),
    const SupportScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool dark = AppTheme.isDark(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: AppTheme.card(context),
        systemNavigationBarIconBrightness:
            dark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final bool dark = AppTheme.isDark(context);
    final Color navBg = AppTheme.card(context);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        border: Border(
          top: BorderSide(color: AppTheme.sep(context), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(dark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.grid_view_outlined,
                selectedIcon: Icons.grid_view_rounded,
                label: 'Hub',
                index: 0,
                currentIndex: _selectedIndex,
                onTap: _onNavTap,
              ),
              _NavItem(
                icon: Icons.folder_outlined,
                selectedIcon: Icons.folder_open_rounded,
                label: 'Applications',
                index: 1,
                currentIndex: _selectedIndex,
                onTap: _onNavTap,
              ),
              _NavItem(
                icon: Icons.headset_mic_outlined,
                selectedIcon: Icons.headset_mic_rounded,
                label: 'Support',
                index: 2,
                currentIndex: _selectedIndex,
                onTap: _onNavTap,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: 'Profile',
                index: 3,
                currentIndex: _selectedIndex,
                onTap: _onNavTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    HapticFeedback.selectionClick();
  }
}

// --- Custom Nav Item ---
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == currentIndex;
    final Color unselectedColor = AppTheme.lblSecondary(context);
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 22,
              color: isSelected ? AppTheme.primary : unselectedColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : unselectedColor,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Coming Soon Placeholder ---
class _ComingSoonScreen extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ComingSoonScreen({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 36, color: AppTheme.primary),
            ),
            const SizedBox(height: 20),
            Text(
              label,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.label,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming soon',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.labelSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
