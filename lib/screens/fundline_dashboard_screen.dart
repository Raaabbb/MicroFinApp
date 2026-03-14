import 'package:flutter/material.dart';
import '../theme.dart';
import 'fundline_web_ui_screen.dart';
import 'fundline_my_applications_screen.dart';
import 'fundline_my_loans_screen.dart';
import 'fundline_my_payments_screen.dart';
import 'profile_screen.dart';
import 'fundline_terms_screen.dart';
import 'fundline_help_screen.dart';

class FundlineDashboardScreen extends StatefulWidget {
  const FundlineDashboardScreen({super.key});

  @override
  State<FundlineDashboardScreen> createState() => _FundlineDashboardScreenState();
}

class _FundlineDashboardScreenState extends State<FundlineDashboardScreen> {
  // Fundline Brand Colors (from original design)
  static const Color fundlineRed = Color(0xFFEC1313);
  static const Color fundlineDarkRed = Color(0xFFB30F0F);
  static const Color fundlineDeepRed = Color(0xFF7F0909);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _buildFundlineHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCreditLimitCard(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Quick Actions'),
                  const SizedBox(height: 16),
                  _buildQuickActions(context),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Recent Activity'),
                  const SizedBox(height: 16),
                  _buildActivityList(),
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToApply(context),
        backgroundColor: fundlineRed,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Apply for Loan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildFundlineHeader() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.background.withOpacity(0.95),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 70,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.label, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.label,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Welcome back',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.labelSecondary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.labelSecondary),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: fundlineRed.withOpacity(0.1),
              child: const Text('U', style: TextStyle(color: fundlineRed, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: AppTheme.separator, thickness: 0.5),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        color: AppTheme.label,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildCreditLimitCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [fundlineRed, fundlineDarkRed, fundlineDeepRed],
        ),
        boxShadow: [
          BoxShadow(
            color: fundlineRed.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.account_balance_rounded,
              size: 150,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Credit Limit',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '₱150,000.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildLimitStat('₱150,000', 'Available'),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      width: 1,
                      height: 24,
                      color: Colors.white.withOpacity(0.15),
                    ),
                    _buildLimitStat('₱0', 'Used Balance'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.75,
      children: [
        _buildActionItem(Icons.add_circle_outline_rounded, 'Apply Loan', fundlineRed, () => _navigateToApply(context)),
        _buildActionItem(Icons.folder_open_outlined, 'Applications', fundlineRed, () => _navigateToMyApplications(context)),
        _buildActionItem(Icons.account_balance_wallet_outlined, 'My Loans', fundlineRed, () => _navigateToMyLoans(context)),
        _buildActionItem(Icons.payments_outlined, 'My Payments', fundlineRed, () => _navigateToMyPayments(context)),
        _buildActionItem(Icons.person_outline_rounded, 'Profile', fundlineRed, () => _navigateToProfile(context)),
        _buildActionItem(Icons.gavel_outlined, 'Terms', fundlineRed, () => _navigateToTerms(context)),
        _buildActionItem(Icons.help_outline_rounded, 'Support', fundlineRed, () => _navigateToSupport(context)),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.separator, width: 0.8),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.labelSecondary,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityList() {
    final activities = [
      {
        'title': 'Credit Limit Increased',
        'subtitle': 'Your limit is now ₱150k',
        'date': 'Today',
        'icon': Icons.trending_up_rounded,
        'color': fundlineRed,
      },
      {
        'title': 'Welcome to Fundline',
        'subtitle': 'Your lending partner',
        'date': '2 days ago',
        'icon': Icons.auto_awesome_rounded,
        'color': fundlineDarkRed,
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final a = activities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.separator, width: 0.5),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (a['color'] as Color).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  a['icon'] as IconData,
                  color: a['color'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppTheme.label,
                      ),
                    ),
                    Text(
                      a['subtitle'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.labelSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                a['date'] as String,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.labelSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToApply(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const FundlineWebUiScreen()));
  }
  void _navigateToMyApplications(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const FundlineMyApplicationsScreen()));
  }
  void _navigateToMyLoans(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const FundlineMyLoansScreen()));
  }
  void _navigateToMyPayments(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const FundlineMyPaymentsScreen()));
  }
  void _navigateToProfile(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen(brandingColor: fundlineRed)));
  }
  void _navigateToSupport(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const FundlineHelpScreen()));
  }
  void _navigateToTerms(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const FundlineTermsScreen()));
  }
}
