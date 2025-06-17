import 'package:flutter/material.dart';
import 'dart:math';

class EquityLinkedSavingScheme extends StatefulWidget {
  const EquityLinkedSavingScheme({super.key});

  @override
  State<EquityLinkedSavingScheme> createState() => _EquityLinkedSavingSchemeState();
}

class _EquityLinkedSavingSchemeState extends State<EquityLinkedSavingScheme> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ELSS (SIP) calculators
  final TextEditingController _sipAmountController = TextEditingController();
  final TextEditingController _sipRateController = TextEditingController();
  final TextEditingController _sipYearsController = TextEditingController();

  // ELSS (Lump Sum) calculators
  final TextEditingController _lumpSumAmountController = TextEditingController();
  final TextEditingController _lumpSumRateController = TextEditingController();
  final TextEditingController _lumpSumYearsController = TextEditingController();

  // ELSS (SIP) Results
  double _sipInvestmentAmount = 0;
  double _sipEstimatedReturn = 0;
  double _sipTotalValue = 0;

  // ELSS (Lump Sum) results
  double _lumpSumInvestmentAmount = 0;
  double _lumpSumEstimatedReturn = 0;
  double _lumpSumTotalValue = 0;

  // Result visibility flags
  bool _showELLSSIPResults = false;
  bool _showELLSLumpSumResults = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sipAmountController.dispose();
    _sipRateController.dispose();
    _sipYearsController.dispose();
    _lumpSumAmountController.dispose();
    _lumpSumRateController.dispose();
    _lumpSumYearsController.dispose();
    super.dispose();
  }

  void _calculateELLSSIP() {
    // Validate input fields
    if (_sipAmountController.text.isEmpty ||
        _sipRateController.text.isEmpty ||
        _sipYearsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Parse inputs
    double monthlyInvestment = double.tryParse(_sipAmountController.text) ?? 0;
    double annualRate = double.tryParse(_sipRateController.text) ?? 0;
    int years = int.tryParse(_sipYearsController.text) ?? 0;

    // Validate positive values and minimum 3 years
    if (monthlyInvestment <= 0 || annualRate <= 0 || years <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter valid positive values'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    if (years < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Investment period must be at least 3 years'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Calculate monthly rate
    double monthlyRate = annualRate / 12 / 100;
    int totalMonths = years * 12;

    // SIP formula: FV = P × [((1 + i)^n – 1) / i] × (1 + i)
    num powerTerm = pow(1 + monthlyRate, totalMonths);
    double totalValue = monthlyInvestment *
        ((powerTerm - 1) / monthlyRate) *
        (1 + monthlyRate);

    // Round to nearest integer
    totalValue = totalValue.roundToDouble();

    // Calculate total investment and return
    double investmentAmount = monthlyInvestment * totalMonths;
    double estimatedReturn = totalValue - investmentAmount;

    // Update state with results
    setState(() {
      _sipTotalValue = totalValue;
      _sipInvestmentAmount = investmentAmount;
      _sipEstimatedReturn = estimatedReturn;
      _showELLSSIPResults = true;
    });
  }

  void _calculateELLSLumpSum() {
    // Validate input fields
    if (_lumpSumAmountController.text.isEmpty ||
        _lumpSumRateController.text.isEmpty ||
        _lumpSumYearsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Parse inputs
    double principal = double.tryParse(_lumpSumAmountController.text) ?? 0;
    double annualRate = double.tryParse(_lumpSumRateController.text) ?? 0;
    int years = int.tryParse(_lumpSumYearsController.text) ?? 0;

    // Validate positive values and minimum 3 years
    if (principal <= 0 || annualRate <= 0 || years <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter valid positive values'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    if (years < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Investment period must be at least 3 years'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Lump Sum formula: FV = C(1 + r)^t
    double totalValue = principal * pow(1 + (annualRate / 100), years);
    double estimatedReturn = totalValue - principal;

    // Update state with results
    setState(() {
      _lumpSumTotalValue = totalValue;
      _lumpSumInvestmentAmount = principal;
      _lumpSumEstimatedReturn = estimatedReturn;
      _showELLSLumpSumResults = true;
    });
  }

  void _resetELLSSIP() {
    setState(() {
      _sipAmountController.clear();
      _sipRateController.clear();
      _sipYearsController.clear();
      _sipTotalValue = 0;
      _sipInvestmentAmount = 0;
      _sipEstimatedReturn = 0;
      _showELLSSIPResults = false;
    });
  }

  void _resetELLSLumpSum() {
    setState(() {
      _lumpSumAmountController.clear();
      _lumpSumRateController.clear();
      _lumpSumYearsController.clear();
      _lumpSumTotalValue = 0;
      _lumpSumInvestmentAmount = 0;
      _lumpSumEstimatedReturn = 0;
      _showELLSLumpSumResults = false;
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
            keyboardType: TextInputType.number,
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

  Widget _buildSIPCalculator() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Monthly ELSS SIP Amount',
            hint: 'Enter monthly investment',
            controller: _sipAmountController,
            prefix: ' ₹ ',
            icon: Icons.monetization_on_outlined,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Expected Annual Return',
            hint: 'Enter expected return rate',
            controller: _sipRateController,
            prefix: ' % ',
            icon: Icons.trending_up,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Investment Period',
            hint: 'Enter number of years (min 3)',
            controller: _sipYearsController,
            prefix: ' ',
            icon: Icons.calendar_today,
          ),
          const SizedBox(height: 30),
          _buildActionButtons(
            onCalculate: _calculateELLSSIP,
            onReset: _resetELLSSIP,
          ),
          const SizedBox(height: 30),
          if (_showELLSSIPResults) ...[
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
              title: 'Total Value',
              amount: _sipTotalValue,
              color: Colors.green[600]!,
              icon: Icons.trending_up,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Investment Amount',
              amount: _sipInvestmentAmount,
              color: Colors.blue[600]!,
              icon: Icons.account_balance_wallet,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Estimated Return',
              amount: _sipEstimatedReturn,
              color: Colors.orange[600]!,
              icon: Icons.savings,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLumpSumCalculator() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildInputField(
            label: 'ELSS Lump Sum Amount',
            hint: 'Enter one-time investment',
            controller: _lumpSumAmountController,
            prefix: ' ₹ ',
            icon: Icons.account_balance,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Expected Annual Return',
            hint: 'Enter expected return rate',
            controller: _lumpSumRateController,
            prefix: ' % ',
            icon: Icons.trending_up,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Investment Period',
            hint: 'Enter number of years (min 3)',
            controller: _lumpSumYearsController,
            prefix: ' ',
            icon: Icons.calendar_today,
          ),
          const SizedBox(height: 30),
          _buildActionButtons(
            onCalculate: _calculateELLSLumpSum,
            onReset: _resetELLSLumpSum,
          ),
          const SizedBox(height: 30),
          if (_showELLSLumpSumResults) ...[
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
              title: 'Total Value',
              amount: _lumpSumTotalValue,
              color: Colors.green[600]!,
              icon: Icons.trending_up,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Investment Amount',
              amount: _lumpSumInvestmentAmount,
              color: Colors.blue[600]!,
              icon: Icons.account_balance_wallet,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Estimated Return',
              amount: _lumpSumEstimatedReturn,
              color: Colors.orange[600]!,
              icon: Icons.savings,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ELSS Calculator',
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.grey[800],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.grey[800],
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          tabs: const [
            Tab(text: 'ELSS SIP'),
            Tab(text: 'ELSS Lump Sum'),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSIPCalculator(),
              _buildLumpSumCalculator(),
            ],
          ),
        ),
      ),
    );
  }
}