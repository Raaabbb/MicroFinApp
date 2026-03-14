import 'package:flutter/material.dart';

class FundlineHelpScreen extends StatelessWidget {
  const FundlineHelpScreen({super.key});

  static const Color _red = Color(0xFFB91C1C);
  static const Color _bg = Color(0xFFF8F9FA);

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
          'Help & Support',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1C1E),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [Color(0xFFB91C1C), Color(0xFF7F1D1D)],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'How can we help you?',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Find answers or connect with the Fundline team.',
                    style: TextStyle(
                      color: Color(0xFFFCA5A5),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Contact channels
            _sectionLabel('Contact Us'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _contactCard(
                    Icons.chat_bubble_outline_rounded,
                    'Live Chat',
                    'Reply in ~5 min',
                    _red,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _contactCard(
                    Icons.email_outlined,
                    'Email Us',
                    'Reply in 24 hrs',
                    const Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _contactCard(
                    Icons.phone_outlined,
                    'Call Us',
                    '+63 2 8888-FUND',
                    _red,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _contactCard(
                    Icons.location_on_outlined,
                    'Visit Office',
                    'Makati City, PH',
                    const Color(0xFF991B1B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // FAQ
            _sectionLabel('Frequently Asked Questions'),
            const SizedBox(height: 12),
            _faqList(context),
            const SizedBox(height: 28),

            // Office hours
            _sectionLabel('Office Hours'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  _hourRow('Monday – Friday', '8:00 AM – 6:00 PM'),
                  const Divider(height: 20, color: Color(0xFFE5E7EB)),
                  _hourRow('Saturday', '9:00 AM – 3:00 PM'),
                  const Divider(height: 20, color: Color(0xFFE5E7EB)),
                  _hourRow('Sunday & Holidays', 'Closed'),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1C1C1E),
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _contactCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _faqList(BuildContext context) {
    final faqs = [
      {
        'q': 'How do I apply for a Fundline loan?',
        'a':
            'Tap "Apply for Loan" on the dashboard. Complete the digital application form, upload the required documents, and submit. You will receive a decision within 24 hours.',
      },
      {
        'q': 'What documents are required?',
        'a':
            'A valid government-issued ID, proof of income (payslip or ITR), proof of billing, and a completed application form. A co-maker is mandatory for all loan types.',
      },
      {
        'q': 'When will I receive my loan proceeds?',
        'a':
            'After approval and document verification, proceeds are released within 1–3 banking days via bank transfer.',
      },
      {
        'q': 'Can I pay my loan early?',
        'a':
            'Yes! Early repayment is encouraged and there is no prepayment penalty. Full settlement closes your account in good standing.',
      },
      {
        'q': 'How do I check my loan status?',
        'a':
            'Go to the "My Applications" section on the Fundline Dashboard to view the real-time status of all your loan applications and active loans.',
      },
      {
        'q': 'What if I miss a payment?',
        'a':
            'A penalty of 5%–10% per month is charged on overdue amounts. Contact our support team immediately to discuss restructuring options.',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          color: Color(0xFFE5E7EB),
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, i) {
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              iconColor: _red,
              collapsedIconColor: const Color(0xFF9CA3AF),
              title: Text(
                faqs[i]['q']!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    faqs[i]['a']!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _hourRow(String day, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        Text(
          hours,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: hours == 'Closed' ? _red : const Color(0xFF059669),
          ),
        ),
      ],
    );
  }
}
