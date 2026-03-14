import 'package:flutter/material.dart';
import '../theme.dart';
import 'microfin_logo.dart';
import '../screens/profile_screen.dart';

class GlobalHeader extends StatelessWidget {
  final bool showBackButton;
  final String? title;

  const GlobalHeader({super.key, this.showBackButton = false, this.title});

  @override
  Widget build(BuildContext context) {
    final Color bgColor = AppTheme.bg(context);
    final Color cardVar = AppTheme.cardVariant(context);
    final Color sepColor = AppTheme.sep(context);
    final Color labelColor = AppTheme.lbl(context);
    final Color labelSecColor = AppTheme.lblSecondary(context);

    return SliverAppBar(
      pinned: true,
      floating: false,
      backgroundColor: bgColor.withOpacity(0.97),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black.withOpacity(0.4),
      expandedHeight: 110,
      toolbarHeight: 80,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: labelColor, size: 20),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              bottom: BorderSide(color: sepColor, width: 1),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: showBackButton ? 68.0 : 20.0,
                right: 20.0,
                top: 16,
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Section
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cardVar,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: sepColor, width: 1),
                        ),
                        child: MicroFinLogo(
                          size: showBackButton ? 22.0 : 26.0,
                          showText: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title ?? 'MicroFin',
                            style: TextStyle(
                              fontSize: showBackButton ? 20 : 22,
                              fontWeight: FontWeight.w900,
                              color: labelColor,
                              letterSpacing: -1.0,
                              height: 1.1,
                            ),
                          ),
                          if (title == null)
                            const Text(
                              'Hub',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                                letterSpacing: 1.2,
                                height: 1.0,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  // Action buttons
                  Row(
                    children: [
                      _NavIconButton(
                        icon: Icons.notifications_none_rounded,
                        onTap: () {},
                        hasBadge: true,
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primary.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 17,
                            backgroundColor: cardVar,
                            child: Icon(
                              Icons.person,
                              color: labelSecColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool hasBadge;

  const _NavIconButton({required this.icon, this.onTap, this.hasBadge = false});

  @override
  Widget build(BuildContext context) {
    final Color cardVar = AppTheme.cardVariant(context);
    final Color sepColor = AppTheme.sep(context);
    final Color labelSecColor = AppTheme.lblSecondary(context);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cardVar,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: sepColor, width: 1),
            ),
            child: Icon(icon, size: 20, color: labelSecColor),
          ),
          if (hasBadge)
            Positioned(
              top: 7,
              right: 7,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.danger,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
