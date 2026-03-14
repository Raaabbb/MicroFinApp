import 'package:flutter/material.dart';
import '../theme.dart';

class FundlineMyPaymentsScreen extends StatelessWidget {
  const FundlineMyPaymentsScreen({super.key});

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
                  _buildTotalPaidCard(),
                  const SizedBox(height: 32),
                  const Text(
                    'Recent Payments',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.label,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentHistoryList(),
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
        'My Payments',
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

  Widget _buildTotalPaidCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.payments_rounded, color: Colors.white, size: 24),
              ),
              const Icon(Icons.qr_code_2_rounded, color: Colors.white70, size: 24),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'TOTAL AMOUNT PAID',
            style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 4),
          const Text(
            '₱7,500.00',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_rounded, color: Colors.white70, size: 16),
                SizedBox(width: 8),
                Text('Last payment: Mar 05, 2026', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryList() {
    final payments = [
      {'date': 'Mar 05, 2026', 'amount': 1250.00, 'method': 'GCash', 'status': 'Posted'},
      {'date': 'Feb 05, 2026', 'amount': 1250.00, 'method': 'GCash', 'status': 'Posted'},
      {'date': 'Jan 05, 2026', 'amount': 1250.00, 'method': 'Over-the-Counter', 'status': 'Posted'},
      {'date': 'Dec 05, 2025', 'amount': 1250.00, 'method': 'Maya', 'status': 'Posted'},
    ];

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final p = payments[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.separator, width: 0.5),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: fundlineRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.receipt_long_rounded, color: fundlineRed, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['method'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.label),
                    ),
                    Text(
                      p['date'] as String,
                      style: const TextStyle(fontSize: 12, color: AppTheme.labelSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₱${(p['amount'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.label),
                  ),
                  const SizedBox(height: 2),
                  const Text('SUCCESS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: fundlineRed, letterSpacing: 0.5)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
