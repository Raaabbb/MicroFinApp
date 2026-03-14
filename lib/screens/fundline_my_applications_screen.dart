import 'package:flutter/material.dart';
import '../theme.dart';

class FundlineMyApplicationsScreen extends StatelessWidget {
  const FundlineMyApplicationsScreen({super.key});

  static const Color fundlineRed = Color(0xFFEC1313);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  const Text(
                    'Applications',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.label,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildApplicationCard(
                    productName: 'Personal Loan',
                    applicationNumber: 'APP-1020304',
                    status: 'Pending',
                    amount: 15000,
                    term: 12,
                    rate: 2.5,
                    submittedDate: 'Mar 10, 2026',
                  ),
                  const SizedBox(height: 16),
                  _buildApplicationCard(
                    productName: 'Business Loan',
                    applicationNumber: 'APP-5060708',
                    status: 'Approved',
                    amount: 50000,
                    term: 24,
                    rate: 3.0,
                    submittedDate: 'Jan 05, 2026',
                    approvedAmount: 50000,
                  ),
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.background.withOpacity(0.95),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.label, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'My Applications',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppTheme.label,
          letterSpacing: -0.5,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: AppTheme.separator, thickness: 0.5),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGradientStatCard(
                title: 'Total Apps',
                value: '2',
                icon: Icons.folder_open_outlined,
                gradientColors: const [
                  fundlineRed,
                  Color(0xFFB30F0F),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGradientStatCard(
                title: 'Pending',
                value: '1',
                icon: Icons.pending_actions_outlined,
                gradientColors: const [
                  Color(0xFFFF5F5F),
                  fundlineRed,
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGradientStatCard(
                title: 'Approved',
                value: '1',
                icon: Icons.check_circle_outline,
                gradientColors: const [
                  Color(0xFFDC2626),
                  Color(0xFF991B1B),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGradientStatCard(
                title: 'Rejected',
                value: '0',
                icon: Icons.cancel_outlined,
                gradientColors: const [
                  Color(0xFF7F1D1D),
                  Color(0xFF450A0A),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGradientStatCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 28),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard({
    required String productName,
    required String applicationNumber,
    required String status,
    required double amount,
    required int term,
    required double rate,
    required String submittedDate,
    double? approvedAmount,
    String? rejectionReason,
  }) {
    Color statusColor;
    Color statusBgColor;

    if (status == 'Approved' || status == 'Paid') {
      statusColor = const Color(0xFFB30F0F); // Fundline dark red
      statusBgColor = const Color(0xFFB30F0F).withOpacity(0.1);
    } else if (status == 'Pending') {
      statusColor = const Color(0xFFEC1313); // Fundline red
      statusBgColor = const Color(0xFFEC1313).withOpacity(0.1);
    } else {
      statusColor = const Color(0xFF7F0909); // Fundline deep red
      statusBgColor = const Color(0xFF7F0909).withOpacity(0.1);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.separator, width: 0.5),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.label,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      applicationNumber,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.labelSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.separator),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Amount',
                        '₱${amount.toStringAsFixed(2)}',
                        isPrimary: true,
                      ),
                    ),
                    Expanded(child: _buildDetailItem('Term', '$term Months')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildDetailItem('Rate', '$rate%')),
                    Expanded(
                      child: _buildDetailItem('Submitted', submittedDate),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.separator),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.separator),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.labelSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: AppTheme.labelSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value, {
    bool isPrimary = false,
  }) {
    Color valColor = isPrimary ? fundlineRed : AppTheme.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.labelSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: valColor,
          ),
        ),
      ],
    );
  }
}
