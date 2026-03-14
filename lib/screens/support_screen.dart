import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/global_header.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bg = AppTheme.bg(context);
    final Color labelColor = AppTheme.lbl(context);
    final Color labelSecColor = AppTheme.lblSecondary(context);

    return Scaffold(
      backgroundColor: bg,
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
                      Text(
                        'How can we help you?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: labelColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Find answers to your questions or get in touch with our team.',
                        style: TextStyle(fontSize: 14, color: labelSecColor),
                      ),
                      const SizedBox(height: 24),
                      _buildSearchField(context),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Quick Actions', labelColor),
                      const SizedBox(height: 16),
                      _buildQuickActionCards(context),
                      const SizedBox(height: 32),
                      _buildSectionTitle(
                          'Frequently Asked Questions', labelColor),
                      const SizedBox(height: 16),
                      _buildFaqList(context),
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

  Widget _buildSearchField(BuildContext context) {
    final Color cardBg = AppTheme.card(context);
    final Color labelSecColor = AppTheme.lblSecondary(context);
    final Color sepColor = AppTheme.sep(context);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sepColor, width: 0.8),
        boxShadow: AppTheme.shadow(context),
      ),
      child: TextField(
        style: TextStyle(color: AppTheme.lbl(context)),
        decoration: InputDecoration(
          hintText: 'Search for help topics...',
          prefixIcon: Icon(Icons.search, color: labelSecColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: cardBg,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color labelColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: labelColor,
      ),
    );
  }

  Widget _buildQuickActionCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Live Chat',
            subtitle: 'Typical reply in 5 mins',
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Icons.email_outlined,
            title: 'Email Us',
            subtitle: 'We will reply in 24 hrs',
            color: const Color(0xFF059669),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final Color cardBg = AppTheme.card(context);
    final Color labelColor = AppTheme.lbl(context);
    final Color labelSecColor = AppTheme.lblSecondary(context);
    final Color sepColor = AppTheme.sep(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sepColor, width: 0.8),
        boxShadow: AppTheme.shadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: labelSecColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqList(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'question': 'How do I apply for a loan?',
        'answer':
            'Navigate to the Dashboard, select a provider, and click "Apply Now". Follow the instructions on the application form.',
      },
      {
        'question': 'What are the required documents?',
        'answer':
            'Typically, you will need a valid government ID, proof of income, and proof of billing. Specific requirements vary by provider.',
      },
      {
        'question': 'How long does approval take?',
        'answer':
            'Approval times vary. Some providers offer instant approval, while others may take 24-48 hours to process your application.',
      },
      {
        'question': 'Can I have multiple active loans?',
        'answer':
            'This depends on your credit limit and the specific terms of the loan providers. Check the "Applications" tab to see your active loans.',
      },
    ];

    final Color cardBg = AppTheme.card(context);
    final Color sepColor = AppTheme.sep(context);
    final Color labelColor = AppTheme.lbl(context);
    final Color labelSecColor = AppTheme.lblSecondary(context);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: sepColor, width: 0.8),
        boxShadow: AppTheme.shadow(context),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: faqs.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: sepColor),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                faq['question']!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    faq['answer']!,
                    style: TextStyle(
                      fontSize: 13,
                      color: labelSecColor,
                      height: 1.5,
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
}
