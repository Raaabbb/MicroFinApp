import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../theme.dart';
import '../widgets/global_header.dart';
import 'loan_app_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bg = AppTheme.bg(context);

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          const GlobalHeader(),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildSearchAndFilter(context),
                      const SizedBox(height: 32),
                      _buildSectionHeader(context, 'Featured Partner',
                          actionLabel: 'See All'),
                      const SizedBox(height: 14),
                      _buildFeaturedCard(context),
                      const SizedBox(height: 32),
                      _buildSectionHeader(context, 'Available Apps',
                          actionLabel: 'Browse'),
                      const SizedBox(height: 6),
                      Text(
                        'Select a provider to apply for a loan',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.lblSecondary(context),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildAppGrid(context),
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

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppTheme.lbl(context),
            letterSpacing: -0.5,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeaturedCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        gradient: const RadialGradient(
          center: Alignment.topRight,
          radius: 1.5,
          colors: [
            Color(0xFFEF4444), // fundline red
            Color(0xFFB91C1C), // fundline dark red
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB91C1C).withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentCyan.withOpacity(0.12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentCyan.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.accentCyan.withOpacity(0.35),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.accentCyan,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'TOP RATED',
                            style: TextStyle(
                              color: AppTheme.accentCyan,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fundline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get approved up to \u20B110,000\ninstantly with low interest rates.',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                    height: 1.55,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _navigateToApp(
                        context,
                        const LoanAppInfo(
                          name: 'Fundline',
                          tagline: 'Personal & Business Loans',
                          description:
                              'Fundline is your trusted micro-lending partner for personal and business growth. With fast approvals and competitive rates, we help Filipinos achieve financial freedom.',
                          icon: Icons.account_balance_rounded,
                          imageAsset: 'lib/assets/FundlineLogo.png',
                          color: Color(0xFFB91C1C),
                          tag: 'Popular',
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB91C1C), // fundline red
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFB91C1C).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Open App',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        child: const Text(
                          'Learn More',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppGrid(BuildContext context) {
    final List<LoanAppInfo> apps = [
      const LoanAppInfo(
        name: 'Fundline',
        tagline: 'Personal & Business Loans',
        description:
            'Fundline is your trusted micro-lending partner for personal and business growth. With fast approvals and competitive rates, we help Filipinos achieve financial freedom.',
        icon: Icons.account_balance_rounded,
        imageAsset: 'lib/assets/FundlineLogo.png',
        color: Color(0xFFB91C1C),
        tag: 'Popular',
      ),
      const LoanAppInfo(
        name: 'Plaridel',
        tagline: 'Farmers & Agricultural Loans',
        description:
            'Plaridel MicroFin empowers Filipino farmers and agri-entrepreneurs with accessible loan products designed for agricultural needs and rural livelihoods.',
        icon: Icons.grass_rounded,
        color: Color(0xFF059669),
        tag: 'Low Rates',
      ),
      const LoanAppInfo(
        name: 'SacredHeart',
        tagline: 'Cooperative Loan Solutions',
        description:
            'SacredHeart Cooperative provides community-based microfinancing with a mission to uplift underserved communities through affordable and transparent lending.',
        icon: Icons.handshake_rounded,
        imageAsset: 'lib/assets/SacredLogo.png',
        color: Color(0xFF7C3AED),
        tag: 'Trusted',
      ),
    ];

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 700;
    final bool isMedium = screenWidth > 480;

    if (isWide) {
      // Wide: 3-column grid
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: apps.length,
        itemBuilder: (context, index) =>
            _buildAppCard(context, apps[index]),
      );
    } else if (isMedium) {
      // Medium: 2-column grid
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.82,
        ),
        itemCount: apps.length,
        itemBuilder: (context, index) =>
            _buildAppCard(context, apps[index]),
      );
    } else {
      // Narrow (phone): horizontal scroll
      return SizedBox(
        height: 280,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 260,
                  child: _buildAppCard(context, app),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  void _navigateToApp(BuildContext context, LoanAppInfo app) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => LoanAppDetailScreen(app: app)));
  }

  Widget _buildAppCard(BuildContext context, LoanAppInfo app) {
    final bool dark = AppTheme.isDark(context);
    final Color cardBg = AppTheme.card(context);
    final Color labelColor = AppTheme.lbl(context);
    final Color labelSecColor = AppTheme.lblSecondary(context);
    final Color color = app.color;
    final String? imageAsset = app.imageAsset;

    return GestureDetector(
      onTap: () => _navigateToApp(context, app),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppTheme.shadow(context),
          border: Border.all(color: color.withOpacity(0.18), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: color.withOpacity(0.2), width: 1),
                  ),
                  child: imageAsset != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                                Image.asset(imageAsset, fit: BoxFit.contain),
                          ),
                        )
                      : Icon(app.icon, color: color, size: 32),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    app.tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: labelColor,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  app.tagline,
                  style: TextStyle(
                    fontSize: 13,
                    color: labelSecColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Apply Now',
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: color,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    final Color cardBg = AppTheme.card(context);
    final Color sepColor = AppTheme.sep(context);
    final Color labelSecColor = AppTheme.lblSecondary(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: sepColor, width: 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: labelSecColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'Search providers, loans...',
                  style: TextStyle(
                    color: labelSecColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.tune_rounded,
              color: Colors.white, size: 20),
        ),
      ],
    );
  }
}
