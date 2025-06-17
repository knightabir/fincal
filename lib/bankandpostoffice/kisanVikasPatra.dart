import 'package:flutter/material.dart';
import 'dart:math';

class KisanVikasPatra extends StatefulWidget {
  const KisanVikasPatra({super.key});

  @override
  State<KisanVikasPatra> createState() => _KisanVikasPatraState();
}

class _KisanVikasPatraState extends State<KisanVikasPatra> {
  // Controllers
  final TextEditingController _depositController = TextEditingController();

  // Fixed values
  final String _fixedRate = '7.5'; // Fixed at 7.5%
  final String _fixedTenure = '9 years, 7 months'; // Fixed at 113 months

  // Results
  double _maturityAmount = 0;
  double _investedAmount = 0;
  double _interestEarned = 0;

  // Result visibility flag
  bool _showResults = false;

  @override
  void dispose() {
    _depositController.dispose();
    super.dispose();
  }

  void _calculateKVP() {
    // Validate input field
    if (_depositController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill the deposit amount field'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Parse input
    double principal = double.tryParse(_depositController.text) ?? 0;

    // Validate deposit amount
    if (principal < 1000 || principal > 10000000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Deposit amount must be between ₹1,000 and ₹1,00,00,000'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Fixed values
    double annualRate = 7.5;
    double tenureYears = 113 / 12; // 9 years, 7 months = 113 months

    // Calculate Maturity Amount: A = P × (1 + r/100)^t
    // double maturityAmount = principal * pow(1 + annualRate / 100, tenureYears);
    double maturityAmount = principal * 2;
    // Calculate invested amount and interest earned
    double investedAmount = principal;
    double interestEarned = maturityAmount - investedAmount;

    // Update state with results
    setState(() {
      _maturityAmount = maturityAmount.roundToDouble();
      _investedAmount = investedAmount;
      _interestEarned = interestEarned.roundToDouble();
      _showResults = true;
    });
  }

  void _resetKVP() {
    setState(() {
      _depositController.clear();
      _maturityAmount = 0;
      _investedAmount = 0;
      _interestEarned = 0;
      _showResults = false;
    });
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String prefix,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(
                icon,
                color: Colors.grey[600],
                size: 20,
              ),
              prefixText: prefix,
              prefixStyle: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.grey[600],
                size: 20,
              ),
              prefixText: ' ',
              prefixStyle: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons({
    required VoidCallback onCalculate,
    required VoidCallback onReset,
  }) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onCalculate,
            icon: const Icon(Icons.calculate, size: 18),
            label: const Text(
              'Calculate',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text(
              'Reset',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₹${amount.toStringAsFixed(0).replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
            )}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KVP Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.grey[800],
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildInputField(
                  label: 'Deposit Amount',
                  hint: 'Enter lump-sum deposit (min ₹1,000)',
                  controller: _depositController,
                  prefix: ' ₹ ',
                  icon: Icons.monetization_on_outlined,
                ),
                const SizedBox(height: 20),
                _buildReadOnlyField(
                  label: 'Annual Interest Rate',
                  value: '$_fixedRate %',
                  icon: Icons.trending_up,
                ),
                const SizedBox(height: 20),
                _buildReadOnlyField(
                  label: 'Tenure',
                  value: _fixedTenure,
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 30),
                _buildActionButtons(
                  onCalculate: _calculateKVP,
                  onReset: _resetKVP,
                ),
                const SizedBox(height: 30),
                if (_showResults) ...[
                  Text(
                    'Investment Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildResultCard(
                    title: 'Maturity Amount',
                    amount: _maturityAmount,
                    color: Colors.green[600]!,
                    icon: Icons.trending_up,
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard(
                    title: 'Invested Amount',
                    amount: _investedAmount,
                    color: Colors.blue[600]!,
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard(
                    title: 'Interest Earned',
                    amount: _interestEarned,
                    color: Colors.orange[600]!,
                    icon: Icons.savings,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}