import 'package:flutter/material.dart';
import '../theme.dart';

class FundlineMyLoansScreen extends StatelessWidget {
  const FundlineMyLoansScreen({super.key});

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
                  _buildSummaryCards(),
                  const SizedBox(height: 32),
                  const Text(
                    'Active Loans',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.label,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLoanCard(
                    productName: 'Personal Flexi Loan',
                    loanNumber: 'LN-2024-001',
                    outstandingBalanced: 12450.00,
                    nextPaymentAmount: 1250.00,
                    dueDate: 'Apr 05, 2026',
                    totalLoan: 25000,
                    progress: 0.5,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Past Loans',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.label,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLoanCard(
                    productName: 'Emergency Loan',
                    loanNumber: 'LN-2023-088',
                    outstandingBalanced: 0.00,
                    nextPaymentAmount: 0.00,
                    dueDate: '-',
                    totalLoan: 5000,
                    progress: 1.0,
                    status: 'Settled',
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
        'My Loans',
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

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [fundlineRed, Color(0xFFB91C1C)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: fundlineRed.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL OUTSTANDING',
                  style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                const Text(
                  '₱12,450.00',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ACTIVE LOANS',
                  style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanCard({
    required String productName,
    required String loanNumber,
    required double outstandingBalanced,
    required double nextPaymentAmount,
    required String dueDate,
    required double totalLoan,
    required double progress,
    String status = 'Active',
  }) {
    Color statusColor = status == 'Settled' ? const Color(0xFF991B1B) : fundlineRed;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.separator, width: 0.5),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.account_balance_wallet_rounded, color: statusColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.label),
                      ),
                      Text(
                        loanNumber,
                        style: const TextStyle(fontSize: 12, color: AppTheme.labelSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLoanStat('BALANCE', '₱${outstandingBalanced.toStringAsFixed(2)}', isPrimary: status != 'Settled'),
                    _buildLoanStat('NEXT DUE', '₱${nextPaymentAmount.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('REPAYMENT PROGRESS', style: TextStyle(fontSize: 10, color: AppTheme.labelSecondary, fontWeight: FontWeight.bold)),
                    Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.label)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AppTheme.separator,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.event_outlined, size: 14, color: AppTheme.labelSecondary),
                    const SizedBox(width: 6),
                    Text('Next Due: $dueDate', style: const TextStyle(fontSize: 12, color: AppTheme.labelSecondary, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          if (status != 'Settled') ...[
            const Divider(height: 1, color: AppTheme.separator),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fundlineRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text('PAY NOW', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoanStat(String label, String value, {bool isPrimary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.labelSecondary, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: isPrimary ? fundlineRed : AppTheme.label,
          ),
        ),
      ],
    );
  }
}
