import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../theme.dart';
import 'fundline_terms_screen.dart';

class FundlineWebUiScreen extends StatefulWidget {
  const FundlineWebUiScreen({super.key});

  @override
  State<FundlineWebUiScreen> createState() => _FundlineWebUiScreenState();
}

class _FundlineWebUiScreenState extends State<FundlineWebUiScreen> {
  // Application Data
  String _selectedProduct = '- Choose a product -';
  String _selectedTerm = '- Select Duration -';
  String _selectedCategory = '- Select Purpose -';
  double _loanAmount = 0;

  // Controllers
  final _amountController = TextEditingController();
  final _purposeDescController = TextEditingController();

  // Data
  final List<Map<String, dynamic>> _products = [
    {'name': 'Personal Loan - Standard', 'rate': 2.5},
    {
      'name': 'Business Loan - SME',
      'rate': 2.0,
      'status': 'Already Active',
      'enabled': false,
    },
    {'name': 'Emergency Loan', 'rate': 3.0},
  ];

  final List<String> _terms = [
    '6 Months',
    '12 Months',
    '18 Months',
    '24 Months',
    '36 Months',
  ];
  final List<String> _categories = [
    'Personal',
    'Business',
    'Medical',
    'Education',
    'Housing',
    'Agricultural',
  ];

  double get _interestRate {
    if (_selectedProduct == '- Choose a product -') return 0;
    final p = _products.firstWhere(
      (e) => e['name'] == _selectedProduct.split(' - ')[0],
      orElse: () => {'rate': 0.0},
    );
    return p['rate'];
  }

  double get _monthlyPayment {
    if (_loanAmount <= 0 || _selectedTerm == '- Select Duration -') return 0;
    int months = int.parse(_selectedTerm.split(' ')[0]);
    double rate = _interestRate / 100;
    // Simple Interest Method: (Principal + (Principal * Rate * Months)) / Months
    return (_loanAmount + (_loanAmount * rate * months)) / months;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _purposeDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 900;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 2, child: _buildMainForm()),
                                const SizedBox(width: 32),
                                Expanded(flex: 1, child: _buildSidePanel()),
                              ],
                            )
                          : Column(
                              children: [
                                _buildMainForm(),
                                const SizedBox(height: 24),
                                _buildSidePanel(),
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainForm() {
    return _buildContainerCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.assignment_rounded,
                color: Color(0xFFB91C1C),
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Loan Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFB91C1C),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Product Selection
          _buildFieldLabel('Select Loan Product', required: true),
          _buildDropdownField(
            value: _selectedProduct,
            items:
                ['- Choose a product -'] +
                _products.map((e) {
                  String label =
                      "${e['name']} - ${e['rate'].toStringAsFixed(2)}% Interest";
                  if (e['enabled'] == false) label += " (${e['status']})";
                  return label;
                }).toList(),
            onChanged: (v) {
              if (v != null && !v.contains('(Already Active)')) {
                setState(() => _selectedProduct = v);
              }
            },
            icon: Icons.shopping_bag_outlined,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Interest rates are fixed based on the selected product.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Amount and Term Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Amount to Borrow', required: true),
                    _buildInputField(
                      hint: '0.00',
                      prefix: '₱',
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (v) =>
                          setState(() => _loanAmount = double.tryParse(v) ?? 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Repayment Term', required: true),
                    _buildDropdownField(
                      value: _selectedTerm,
                      items: ['- Select Duration -'] + _terms,
                      onChanged: (v) => setState(() => _selectedTerm = v!),
                      icon: Icons.calendar_today_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Category
          _buildFieldLabel('Purpose Category', required: true),
          _buildDropdownField(
            value: _selectedCategory,
            items: ['- Select Purpose -'] + _categories,
            onChanged: (v) => setState(() => _selectedCategory = v!),
            icon: Icons.category_rounded,
          ),
          const SizedBox(height: 24),

          // Description
          _buildFieldLabel('Specific Purpose Description', required: true),
          TextField(
            controller: _purposeDescController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Please describe exactly how you will use the funds...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  color: Color(0xFFB91C1C),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.all(24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidePanel() {
    return Column(
      children: [
        // Credit Limit Card
        _buildCreditLimitCard(),
        const SizedBox(height: 24),

        // Estimation Card
        _buildEstimationCard(),
        const SizedBox(height: 24),

        // Review Section
        _buildContainerCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ready to Apply?',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppTheme.label,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    height: 1.6,
                  ),
                  children: [
                    const TextSpan(
                      text: 'By clicking Submit, you agree to our ',
                    ),
                    TextSpan(
                      text: 'Terms of Service',
                      style: const TextStyle(
                        color: Color(0xFFB91C1C),
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FundlineTermsScreen(),
                            ),
                          );
                        },
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                        color: Color(0xFFB91C1C),
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FundlineTermsScreen(),
                            ),
                          );
                        },
                    ),
                    const TextSpan(
                      text: '. Your application will be reviewed by our team.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _handleReview(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB91C1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Review Application',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.visibility_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreditLimitCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFB91C1C),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB91C1C).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AVAILABLE CREDIT LIMIT',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '₱15,000.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 10000 / 25000,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ₱25,000.00',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                'Used: ₱10,000.00',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: Colors.white24, height: 1),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Loans:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '₱10,000.00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pending Apps:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '₱0.00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstimationCard() {
    double monthly = _monthlyPayment;
    int months = (_selectedTerm != '- Select Duration -')
        ? int.parse(_selectedTerm.split(' ')[0])
        : 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Dotted border simulation
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFFEE2E2),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calculate_outlined,
                      color: Color(0xFFB91C1C),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Estimation',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: AppTheme.label,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'MONTHLY PAYMENT',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₱${monthly.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFFB91C1C),
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  'for $months months',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'Principal:',
                        '₱${_loanAmount.toStringAsFixed(2)}',
                      ),
                      _buildSummaryRow(
                        'Interest (${_interestRate.toStringAsFixed(2)}%):',
                        '₱${(monthly * months - _loanAmount).clamp(0, double.infinity).toStringAsFixed(2)}',
                        color: const Color(0xFFB91C1C),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                      ),
                      _buildSummaryRow(
                        'Total Repayment:',
                        '₱${(monthly * months).toStringAsFixed(2)}',
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
              fontSize: 13,
              color: color ?? AppTheme.label,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: AppTheme.label,
          ),
          children: required
              ? [
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Color(0xFFB91C1C)),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade400,
          ),
          items: items.map((String val) {
            bool isGray = val.contains('-') || val.contains('(Already Active)');
            return DropdownMenuItem<String>(
              value: val,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 20, color: Colors.grey.shade400),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      val,
                      style: TextStyle(
                        fontSize: 14,
                        color: isGray ? Colors.grey : Colors.black87,
                        fontWeight: isGray ? FontWeight.w400 : FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    String? prefix,
    TextEditingController? controller,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        prefixIcon: prefix != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      prefix,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade300,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB91C1C), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildContainerCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  void _handleReview() {
    if (_loanAmount <= 0 ||
        _selectedProduct == '- Choose a product -' ||
        _selectedTerm == '- Select Duration -') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete the loan details first.'),
          backgroundColor: Color(0xFFB91C1C),
        ),
      );
      return;
    }
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFFB91C1C),
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Application Submitted!',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your request for ₱${_loanAmount.toStringAsFixed(2)} has been successfully received by the Fundline Marilao branch.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB91C1C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Great, thanks!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white.withOpacity(0.95),
      elevation: 0,
      scrolledUnderElevation: 1,
      toolbarHeight: 90,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'lib/assets/FundlineLogo.png',
                width: 44,
                height: 44,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) =>
                    const Icon(Icons.account_balance, color: Color(0xFFB91C1C)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fundline',
                style: TextStyle(
                  color: Color(0xFFB91C1C),
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: -0.8,
                ),
              ),
              Text(
                'Mobile Application Form',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
