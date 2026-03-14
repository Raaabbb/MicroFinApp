import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import 'fundline_splash_screen.dart';
import 'plaridel_splash_screen.dart';
import 'sacredheart_splash_screen.dart';

// ─────────────────────────────────────────────
//  Data model passed from the dashboard
// ─────────────────────────────────────────────
class LoanAppInfo {
  final String name;
  final String tagline;
  final String description;
  final String tag;
  final Color color;
  final IconData icon;
  final String? imageAsset;

  const LoanAppInfo({
    required this.name,
    required this.tagline,
    required this.description,
    required this.tag,
    required this.color,
    required this.icon,
    this.imageAsset,
  });
}

// ─────────────────────────────────────────────
//  Main Screen
// ─────────────────────────────────────────────
class LoanAppDetailScreen extends StatefulWidget {
  final LoanAppInfo app;
  const LoanAppDetailScreen({super.key, required this.app});

  @override
  State<LoanAppDetailScreen> createState() => _LoanAppDetailScreenState();
}

class _LoanAppDetailScreenState extends State<LoanAppDetailScreen>
    with SingleTickerProviderStateMixin {
  double _loanAmount = 25000;
  int _loanTermMonths = 12;
  double _interestRate = 1.5;
  int _activeTab = 0;

  Color _getDarkerColor(Color color, [double amount = 0.3]) {
    final hsl = HSLColor.fromColor(color);
    final darkL = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(darkL).toColor();
  }

  double get _monthlyPayment {
    final r = _interestRate / 100;
    if (r == 0) return _loanAmount / _loanTermMonths;
    final n = _loanAmount * r * pow(1 + r, _loanTermMonths);
    final d = pow(1 + r, _loanTermMonths) - 1;
    return n / d;
  }

  double get _totalPayment => _monthlyPayment * _loanTermMonths;
  double get _totalInterest => _totalPayment - _loanAmount;

  static const _tabs = ['Overview', 'Reviews', 'Calculator'];

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, app),
          SliverToBoxAdapter(child: _buildHeroCard(app)),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(child: _buildTabBar(app)),
          SliverToBoxAdapter(child: _buildTabContent(app)),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      bottomNavigationBar: _buildApplyBar(app),
    );
  }

  // ─────────────────── SLIVER APP BAR ───────────────────────────────────────
  Widget _buildSliverAppBar(BuildContext context, LoanAppInfo app) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFFF5F7FA), // Match scaffold background
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1C1C1E),
            size: 15,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 14, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.ios_share_rounded,
              color: Color(0xFF1C1C1E),
              size: 17,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // ─────────────────── HERO CARD ───────────────────────────────────────
  Widget _buildHeroCard(LoanAppInfo app) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            48,
          ), // Oval shape matching dashboard
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [app.color, _getDarkerColor(app.color, 0.4)],
          ),
          boxShadow: [
            BoxShadow(
              color: _getDarkerColor(app.color, 0.4).withOpacity(0.3),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle cyan glow top-right
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Icon + Title ──────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App icon
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: Colors.white, // White background for the logo
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF051747).withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: app.imageAsset != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Image.asset(
                                    app.imageAsset!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : Icon(app.icon, color: app.color, size: 34),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tag pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.35),
                                ),
                              ),
                              child: Text(
                                app.tag.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              app.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              app.tagline,
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  const SizedBox(height: 16),
                  // ── Stat Row (App Store style) ─────────────────
                  Row(
                    children: [
                      _statCell('4.8', '★  RATING'),
                      _statDivider(),
                      _statCell('12K+', '↑  BORROWERS'),
                      _statDivider(),
                      _statCell('BSP', '✓  REGULATED'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCell(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statDivider() =>
      Container(width: 0.5, height: 32, color: Colors.white.withOpacity(0.15));

  // ─────────────────── TAB BAR ───────────────────────────────────────────────
  Widget _buildTabBar(LoanAppInfo app) {
    return Container(
      color: Colors.white,
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = i == _activeTab;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _activeTab = i);
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _tabs[i],
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 14,
                        color: selected ? app.color : const Color(0xFF8E8E93),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      width: selected ? 36 : 0,
                      decoration: BoxDecoration(
                        color: app.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────── TAB CONTENT ──────────────────────────────────────────
  Widget _buildTabContent(LoanAppInfo app) {
    switch (_activeTab) {
      case 0:
        return _buildOverview(app);
      case 1:
        return _buildReviews(app);
      case 2:
        return _buildCalculator(app);
      default:
        return const SizedBox();
    }
  }

  // ─────────────────── OVERVIEW ─────────────────────────────────────────────
  Widget _buildOverview(LoanAppInfo app) {
    bool isFundline = app.name.toLowerCase() == 'fundline';

    final offers = isFundline
        ? [
            {
              'icon': Icons.bolt_rounded,
              'title': '100% Digital Process',
              'desc': 'Apply completely online without leaving your home.',
              'color': const Color(0xFFEF4444),
            },
            {
              'icon': Icons.speed_rounded,
              'title': 'Fast Approval',
              'desc': 'Approved in 24 Hours. Quick and hassle-free.',
              'color': app.color,
            },
            {
              'icon': Icons.dashboard_customize_rounded,
              'title': 'Financial Dashboard',
              'desc': 'Track active loans, payment history, and credit limit.',
              'color': const Color(0xFF991B1B),
            },
            {
              'icon': Icons.shield_outlined,
              'title': 'Bank-Grade Security',
              'desc': 'Digital signatures and top-tier encryption.',
              'color': const Color(0xFFB91C1C),
            },
            {
              'icon': Icons.support_agent_rounded,
              'title': '24/7 Support',
              'desc': 'Dedicated customer service around the clock.',
              'color': const Color(0xFFEF4444),
            },
            {
              'icon': Icons.money_off_rounded,
              'title': 'No Hidden Fees',
              'desc':
                  'Transparent processing from application to disbursement.',
              'color': const Color(0xFF7F1D1D),
            },
          ]
        : [
            {
              'icon': Icons.bolt_rounded,
              'title': 'Fast Approval',
              'desc': 'Approved in as little as 24 hours with minimal docs.',
              'color': const Color(0xFFFF9500),
            },
            {
              'icon': Icons.percent_rounded,
              'title': 'Low Interest',
              'desc': 'Starting at 1.5% monthly — lowest in the market.',
              'color': AppTheme.primary,
            },
            {
              'icon': Icons.calendar_month_rounded,
              'title': 'Flexible Terms',
              'desc': 'Choose repayment terms from 3 to 36 months.',
              'color': const Color(0xFF7C3AED),
            },
            {
              'icon': Icons.shield_outlined,
              'title': 'BSP Regulated',
              'desc': 'Fully licensed by the Bangko Sentral ng Pilipinas.',
              'color': const Color(0xFF059669),
            },
            {
              'icon': Icons.support_agent_rounded,
              'title': '24/7 Support',
              'desc': 'Dedicated customer service around the clock.',
              'color': AppTheme.info,
            },
            {
              'icon': Icons.lock_outline_rounded,
              'title': 'Secure & Private',
              'desc': 'Bank-grade encryption for all your data.',
              'color': AppTheme.danger,
            },
          ];

    final String overviewDescription = isFundline
        ? 'Apply for Business, Education, Housing, or Emergency loans completely online. Track your credit limit, manage payments, and get funded without leaving your home.'
        : app.description;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About card
          _surfaceCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                overviewDescription,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF3C3C43),
                  height: 1.7,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          _sectionLabel('WHAT WE OFFER'),
          const SizedBox(height: 10),

          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.55,
            children: offers
                .map(
                  (o) => _offerTile(
                    o['icon'] as IconData,
                    o['title'] as String,
                    o['desc'] as String,
                    o['color'] as Color,
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 24),
          _sectionLabel('LOAN PRODUCTS'),
          const SizedBox(height: 10),

          _surfaceCard(
            child: Column(
              children: isFundline
                  ? [
                      _productRow(
                        'Business Loans',
                        'Up to ₱500K',
                        '6–60 mo',
                        'Expand enterprise',
                        app.color,
                      ),
                      _rowDivider(),
                      _productRow(
                        'Education Loans',
                        'Flexible',
                        'Flexible',
                        'Tuition assistance',
                        const Color(0xFFDC2626),
                      ),
                      _rowDivider(),
                      _productRow(
                        'Housing Loans',
                        'High Limit',
                        'Long term',
                        'Build or renovate',
                        const Color(0xFFB91C1C),
                      ),
                      _rowDivider(),
                      _productRow(
                        'Medical Emergency',
                        'Fast Cash',
                        'Prioritized',
                        'Health expenses',
                        const Color(0xFF991B1B),
                      ),
                      _rowDivider(),
                      _productRow(
                        'Personal Loans',
                        'Multi-purpose',
                        'Flexible',
                        'Travel or gadgets',
                        const Color(0xFFEF4444),
                      ),
                    ]
                  : [
                      _productRow(
                        'Personal Loan',
                        '₱1K – ₱50K',
                        '1–24 mo',
                        '1.5%/mo',
                        app.color,
                      ),
                      _rowDivider(),
                      _productRow(
                        'Business Loan',
                        '₱10K – ₱200K',
                        '6–36 mo',
                        '1.2%/mo',
                        const Color(0xFF059669),
                      ),
                      _rowDivider(),
                      _productRow(
                        'Emergency Loan',
                        '₱500 – ₱20K',
                        '1–12 mo',
                        '2.0%/mo',
                        AppTheme.danger,
                      ),
                    ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _offerTile(IconData icon, String title, String desc, Color color) {
    return _surfaceCard(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF8E8E93),
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _productRow(
    String name,
    String range,
    String term,
    String rate,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$range  ·  $term',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              rate,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey.shade300,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _rowDivider() => const Divider(
    height: 1,
    thickness: 0.5,
    color: Color(0xFFE5E7EB),
    indent: 66,
  );

  // ─────────────────── REVIEWS ───────────────────────────────────────────────
  Widget _buildReviews(LoanAppInfo app) {
    final reviews = [
      {
        'name': 'Maria Santos',
        'rating': 5,
        'date': '2 days ago',
        'text':
            'Super fast! Got my money within 24 hours. Very low interest and no hidden charges. Highly recommended!',
        'avatar': 'MS',
        'aColor': const Color(0xFF7C3AED),
        'loan': 'Personal Loan • ₱15,000',
      },
      {
        'name': 'Juan dela Cruz',
        'rating': 5,
        'date': '1 week ago',
        'text':
            'Best microfinance app I\'ve used! The loan calculator is super helpful. Customer support: 10/10.',
        'avatar': 'JD',
        'aColor': AppTheme.primary,
        'loan': 'Business Loan • ₱50,000',
      },
      {
        'name': 'Ana Reyes',
        'rating': 4,
        'date': '2 weeks ago',
        'text': 'Approval was quick and straightforward. Great service!',
        'avatar': 'AR',
        'aColor': const Color(0xFF059669),
        'loan': 'Emergency Loan • ₱8,000',
      },
      {
        'name': 'Roberto Lim',
        'rating': 5,
        'date': '3 weeks ago',
        'text':
            'Got my business loan without any stress. The team was very helpful!',
        'avatar': 'RL',
        'aColor': const Color(0xFFFF9500),
        'loan': 'Business Loan • ₱120,000',
      },
      {
        'name': 'Carla Mendoza',
        'rating': 5,
        'date': '1 month ago',
        'text':
            'As a small business owner, this was a lifesaver. So manageable!',
        'avatar': 'CM',
        'aColor': AppTheme.danger,
        'loan': 'Personal Loan • ₱25,000',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating banner
          _surfaceCard(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        '4.8',
                        style: TextStyle(
                          color: app.color,
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _stars(4, 15),
                      const SizedBox(height: 4),
                      const Text(
                        '5 Ratings',
                        style: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        _rBar(5, 0.82, app.color),
                        _rBar(4, 0.12, app.color),
                        _rBar(3, 0.04, app.color),
                        _rBar(2, 0.01, app.color),
                        _rBar(1, 0.01, app.color),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _sectionLabel('CUSTOMER REVIEWS'),
          const SizedBox(height: 10),
          _surfaceCard(
            child: Column(
              children: reviews
                  .asMap()
                  .entries
                  .map(
                    (e) => Column(
                      children: [
                        _reviewTile(
                          e.value['name'] as String,
                          e.value['rating'] as int,
                          e.value['date'] as String,
                          e.value['text'] as String,
                          e.value['avatar'] as String,
                          e.value['aColor'] as Color,
                          e.value['loan'] as String,
                          app.color,
                        ),
                        if (e.key < reviews.length - 1)
                          const Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Color(0xFFE5E7EB),
                            indent: 64,
                          ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _stars(int filled, double size) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      5,
      (i) => Icon(
        i < filled ? Icons.star_rounded : Icons.star_outline_rounded,
        color: const Color(0xFFFF9500),
        size: size,
      ),
    ),
  );

  Widget _rBar(int star, double fraction, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          Text(
            '$star',
            style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 10),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFFF9500)),
                minHeight: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewTile(
    String name,
    int rating,
    String date,
    String text,
    String avatar,
    Color aColor,
    String loan,
    Color accent,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: aColor,
                child: Text(
                  avatar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    _stars(rating, 11),
                  ],
                ),
              ),
              Text(
                date,
                style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              loan,
              style: TextStyle(
                color: accent,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF3C3C43),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── CALCULATOR ───────────────────────────────────────────
  Widget _buildCalculator(LoanAppInfo app) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Result hero
          _surfaceCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Monthly highlight with accent color
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: app.color.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: app.color.withOpacity(0.15)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Monthly Payment',
                          style: TextStyle(
                            color: app.color.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₱${_monthlyPayment.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: app.color,
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.5,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Three sub-stats
                  Row(
                    children: [
                      _calcStatCell(
                        'Total Loan',
                        '₱${_loanAmount.toStringAsFixed(0)}',
                        const Color(0xFF1C1C1E),
                      ),
                      Container(
                        width: 0.5,
                        height: 36,
                        color: const Color(0xFFE5E7EB),
                      ),
                      _calcStatCell(
                        'Total Interest',
                        '₱${_totalInterest.toStringAsFixed(0)}',
                        AppTheme.danger,
                      ),
                      Container(
                        width: 0.5,
                        height: 36,
                        color: const Color(0xFFE5E7EB),
                      ),
                      _calcStatCell(
                        'Total Due',
                        '₱${_totalPayment.toStringAsFixed(0)}',
                        app.color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          _sliderCard(
            'Loan Amount',
            '₱${_loanAmount.toStringAsFixed(0)}',
            app.color,
            '₱1K',
            '₱100K',
            Slider(
              value: _loanAmount,
              min: 1000,
              max: 100000,
              divisions: 99,
              activeColor: app.color,
              inactiveColor: app.color.withOpacity(0.15),
              onChanged: (v) => setState(() {
                _loanAmount = v;
                HapticFeedback.selectionClick();
              }),
            ),
          ),
          const SizedBox(height: 10),

          _sliderCard(
            'Loan Term',
            '$_loanTermMonths months',
            app.color,
            '1 mo',
            '36 mo',
            Slider(
              value: _loanTermMonths.toDouble(),
              min: 1,
              max: 36,
              divisions: 35,
              activeColor: app.color,
              inactiveColor: app.color.withOpacity(0.15),
              onChanged: (v) => setState(() {
                _loanTermMonths = v.round();
                HapticFeedback.selectionClick();
              }),
            ),
          ),
          const SizedBox(height: 10),

          _sliderCard(
            'Monthly Rate',
            '${_interestRate.toStringAsFixed(1)}%',
            app.color,
            '0.5%',
            '5.0%',
            Slider(
              value: _interestRate,
              min: 0.5,
              max: 5.0,
              divisions: 45,
              activeColor: app.color,
              inactiveColor: app.color.withOpacity(0.15),
              onChanged: (v) => setState(() {
                _interestRate = double.parse(v.toStringAsFixed(1));
                HapticFeedback.selectionClick();
              }),
            ),
          ),
          const SizedBox(height: 12),

          _surfaceCard(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: app.color, size: 18),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Estimates only. Actual rates may vary — contact us for a personalized offer.',
                      style: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _calcStatCell(String label, String value, Color valueColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sliderCard(
    String label,
    String value,
    Color color,
    String min,
    String max,
    Widget slider,
  ) {
    return _surfaceCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            slider,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    min,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  Text(
                    max,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── SHARED HELPERS ───────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF8E8E93),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _surfaceCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppTheme.separator, width: 0.5),
      ),
      child: child,
    );
  }

  // ─────────────────── BOTTOM BAR ───────────────────────────────────────────
  Widget _buildApplyBar(LoanAppInfo app) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bookmark icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.bookmark_outline_rounded,
              color: Color(0xFF1C1C1E),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                String urlString = 'https://fundlinecorp.ct.ws/includes/index.php';
                final lowerName = app.name.toLowerCase();
                
                if (lowerName.contains('sacred')) {
                  urlString = 'https://sacredheartsavings.ct.ws/?i=1';
                } else if (lowerName.contains('plaridel')) {
                  // Keep Fundline as default or add Plaridel specifically if needed. 
                  // For now, I'll just handle SacredHeart as requested.
                }

                final Uri url = Uri.parse(urlString);
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not launch application link')),
                    );
                  }
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: app.color,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: app.color.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_turned_in_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Apply Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
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

  // ─────────────────── APPLY SHEET ──────────────────────────────────────────
  void _showApplySheet(BuildContext context, LoanAppInfo app) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          8,
          24,
          MediaQuery.of(context).padding.bottom + 36,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 26),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: app.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: app.color.withOpacity(0.2), width: 2),
              ),
              child: Icon(Icons.check_rounded, color: app.color, size: 34),
            ),
            const SizedBox(height: 16),
            Text(
              'Apply to ${app.name}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1C1C1E),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You will be redirected to complete your application.\nPrepare a valid ID and income documents.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF8E8E93),
                height: 1.55,
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: app.color,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: app.color.withOpacity(0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Continue Application',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF8E8E93), fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
