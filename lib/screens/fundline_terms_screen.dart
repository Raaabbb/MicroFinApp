import 'package:flutter/material.dart';

class FundlineTermsScreen extends StatefulWidget {
  const FundlineTermsScreen({super.key});

  @override
  State<FundlineTermsScreen> createState() => _FundlineTermsScreenState();
}

class _FundlineTermsScreenState extends State<FundlineTermsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const Color _red = Color(0xFFB91C1C);
  static const Color _bg = Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
              color: Color(0xFF1C1C1E),
            ),
          ),
        ),
        title: const Text(
          'Legal',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1C1E),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(50),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: _red,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: _red.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF6B7280),
              tabs: const [
                Tab(text: 'Terms and Conditions'),
                Tab(text: 'Privacy Policy'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildTerms(), _buildPrivacy()],
      ),
    );
  }

  // ─────────────────── TERMS & CONDITIONS ───────────────────
  Widget _buildTerms() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoBox(
            'Agreement: By submitting a loan application, you acknowledge and agree to the following terms, rates, and policies of Fundline Finance Corporation.',
            isInfo: true,
          ),
          const SizedBox(height: 24),

          _sectionTitle('1. Loan Products & Interest Rates'),
          const SizedBox(height: 8),
          const Text(
            'Interest rates are fixed for the duration of the loan term. Processing fees, documentary stamps, and service charges are deducted from the net proceeds.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF4B5563),
              height: 1.7,
            ),
          ),
          const SizedBox(height: 14),
          _rateTable(),
          const SizedBox(height: 6),
          const Text(
            '* Interest rates are subject to change based on credit assessment and market conditions.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),

          _sectionTitle('2. Eligibility & Application'),
          const SizedBox(height: 8),
          _policyItem(
            'Age & Residency',
            'Applicants must be at least 18 years old and a resident of the Philippines.',
          ),
          _policyItem(
            'Co-maker Policy',
            'A Co-maker is MANDATORY for all loan applications. The co-maker must be immediate family or a financially stable relative.',
            bold: true,
          ),
          _policyItem(
            'Active Loan Limit',
            'You may only have one (active or pending) loan per category (Personal, Business, etc.) at any given time.',
          ),
          _policyItem(
            'Credit Limit',
            'Your maximum loanable amount is determined by your verification level and income bracket. You cannot borrow more than your assigned credit limit.',
          ),
          const SizedBox(height: 24),

          _sectionTitle('3. Repayment & Penalties'),
          const SizedBox(height: 10),
          // Grace period & Default cards
          Row(
            children: [
              Expanded(
                child: _highlightCard(
                  title: 'Grace Period',
                  highlight: '5 Days',
                  desc: 'after due date before penalties apply.',
                  color: _red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _highlightCard(
                  title: 'Default',
                  highlight: '90 Days',
                  desc:
                      'unpaid are considered in default and subject to legal action.',
                  color: const Color(0xFFDC2626),
                  isDanger: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _detailBox(
            title: 'Late Payment Penalty',
            body:
                'For loans that remain unpaid for a period of 6 months or more past the due date, a one-time penalty charge equivalent to 10% of the total outstanding balance shall be automatically applied to the account.',
          ),
          const SizedBox(height: 10),
          _detailBox(
            title: 'Early Settlement Policy (Pre-termination)',
            body:
                'Borrowers may settle their loan in full before maturity. The final repayment will include:\n\n• Pro-rated Interest: Interest charged only for the actual months the loan was active.\n\n• Termination Fee: 0.06% of the remaining outstanding balance upon settlement.',
          ),
          const SizedBox(height: 24),

          _sectionTitle('4. Verification & Privacy'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Text(
              'Fundline reserves the right to conduct Credit Investigations (CI), including but not limited to home visits, employment verification, and contacting references/co-makers. Providing false information (falsified documents) will result in immediate rejection and permanent blacklisting.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF4B5563),
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ─────────────────── PRIVACY POLICY ───────────────────
  Widget _buildPrivacy() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoBox(
            'Your privacy is our priority. This policy outlines how Fundline protects your personal and financial data.\n\nLast Updated: January 25, 2026',
            isInfo: false,
          ),
          const SizedBox(height: 24),

          // Two-column: Data Collection + Use of Data
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _privacyCard(
                  title: '1. Data Collection',
                  intro:
                      'We collect the following to process your application:',
                  items: [
                    'Personal Data: Name, Address, Date of Birth.',
                    'Contact Info: Email, Phone Number.',
                    'Financial Data: Income proof, Bank details.',
                    'Govt ID: Passport, UMID, Driver\'s License.',
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _privacyCard(
                  title: '2. Use of Data',
                  intro: 'Your data is primarily used for:',
                  items: [
                    'Credit Risk Assessment & Scoring.',
                    'Identity Verification (KYC).',
                    'Loan Disbursement & Collections.',
                    'Regulatory Compliance (AMLA).',
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _sectionTitle('3. Information Sharing'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'We do not sell your personal data. We only share it with trusted partners necessary for our operations:',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip('Credit Information Corp (CIC)'),
                    _chip('Payment Gateways'),
                    _chip('Background Check Providers'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          _sectionTitle('4. Security Measures'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: _red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'We use industry-standard 256-bit SSL encryption to protect your data during transmission. Our databases are secured with strict access controls and regular audits.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ─────────────────── HELPERS ───────────────────
  Widget _infoBox(String text, {required bool isInfo}) {
    final color = isInfo ? _red : const Color(0xFF6B7280);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isInfo ? Icons.info_outline_rounded : Icons.shield_outlined,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF374151),
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: _red,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _policyItem(String label, String content, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 6, right: 10),
              decoration: const BoxDecoration(
                color: _red,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$label: ',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    TextSpan(
                      text: content,
                      style: TextStyle(
                        fontSize: 13,
                        color: bold
                            ? const Color(0xFF111827)
                            : const Color(0xFF4B5563),
                        height: 1.5,
                        fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightCard({
    required String title,
    required String highlight,
    required String desc,
    required Color color,
    bool isDanger = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDanger ? const Color(0xFFFFF1F1) : const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDanger ? const Color(0xFFDC2626) : _red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            highlight,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: isDanger ? const Color(0xFFDC2626) : _red,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailBox({required String title, required String body}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF4B5563),
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }

  Widget _privacyCard({
    required String title,
    required String intro,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: _red,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            intro,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(top: 5, right: 8),
                    decoration: const BoxDecoration(
                      color: _red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF374151),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF374151),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _rateTable() {
    final rows = [
      [
        'Personal Loan',
        '2.5% per month',
        '3 - 24 Months',
        '5% monthly on overdue',
      ],
      [
        'Business Loan',
        '3.0% per month',
        '6 - 36 Months',
        '5% monthly on overdue',
      ],
      [
        'Emergency Loan',
        '3.0% per month',
        '1 - 12 Months',
        '10% monthly on overdue',
      ],
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'LOAN TYPE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'MONTHLY INTEREST',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'TERM DURATION',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'PENALTY RATE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...rows.map(
            (row) => Column(
              children: [
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: row
                        .asMap()
                        .entries
                        .map(
                          (e) => Expanded(
                            child: Text(
                              e.value,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: e.key == 0
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                                color: const Color(0xFF374151),
                                height: 1.4,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
