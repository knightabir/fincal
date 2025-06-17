import 'package:flutter/material.dart';
import 'dart:math';

class SIP extends StatefulWidget {
  const SIP({super.key});

  @override
  State<SIP> createState() => _SIPState();
}

class _SIPState extends State<SIP> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // SIP Calculator Controllers
  final TextEditingController _sipAmountController = TextEditingController();
  final TextEditingController _sipRateController = TextEditingController();
  final TextEditingController _sipYearsController = TextEditingController();

  // Lump Sum Calculator Controllers
  final TextEditingController _lumpSumAmountController = TextEditingController();
  final TextEditingController _lumpSumRateController = TextEditingController();
  final TextEditingController _lumpSumYearsController = TextEditingController();

  // Results
  double _sipMaturityAmount = 0;
  double _sipTotalDeposit = 0;
  double _sipTotalReturn = 0;

  double _lumpSumMaturityAmount = 0;
  double _lumpSumTotalDeposit = 0;
  double _lumpSumTotalReturn = 0;

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

  // Result visibility flags
  bool _showSipResults = false;
  bool _showLumpSumResults = false;

  void _calculateSIP() {
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

    // Validate positive values
    if (monthlyInvestment <= 0 || annualRate <= 0 || years <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter valid positive values'),
          backgroundColor:Colors.orange[600],
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

    // Corrected SIP formula: M = P × [((1 + i)^n – 1) / i] × (1 + i)
    num powerTerm = pow(1 + monthlyRate, totalMonths);
    double maturityAmount = monthlyInvestment *
        ((powerTerm - 1) / monthlyRate) *
        (1 + monthlyRate);

    // Round to nearest integer to match Groww's display
    maturityAmount = maturityAmount.roundToDouble();

    // Calculate total deposit and return
    double totalDeposit = monthlyInvestment * totalMonths;
    double totalReturn = maturityAmount - totalDeposit;

    // Update state with results
    setState(() {
      _sipMaturityAmount = maturityAmount;
      _sipTotalDeposit = totalDeposit;
      _sipTotalReturn = totalReturn;
      _showSipResults = true;
    });
  }


  void _calculateLumpSum() {
    if (_lumpSumAmountController.text.isEmpty ||
        _lumpSumRateController.text.isEmpty ||
        _lumpSumYearsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
      );
      return;
    }

    double principal = double.tryParse(_lumpSumAmountController.text) ?? 0;
    double annualRate = double.tryParse(_lumpSumRateController.text) ?? 0;
    int years = int.tryParse(_lumpSumYearsController.text) ?? 0;

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

    // Compound Interest Formula: A = P(1 + r/n)^(nt)
    // Assuming annual compounding: A = P(1 + r)^t
    double maturityAmount = principal * pow(1 + (annualRate / 100), years);
    double totalReturn = maturityAmount - principal;

    setState(() {
      _lumpSumMaturityAmount = maturityAmount;
      _lumpSumTotalDeposit = principal;
      _lumpSumTotalReturn = totalReturn;
      _showLumpSumResults = true;
    });
  }

  void _resetSIP() {
    setState(() {
      _sipAmountController.clear();
      _sipRateController.clear();
      _sipYearsController.clear();
      _sipMaturityAmount = 0;
      _sipTotalDeposit = 0;
      _sipTotalReturn = 0;
      _showSipResults = false;
    });
  }

  void _resetLumpSum() {
    setState(() {
      _lumpSumAmountController.clear();
      _lumpSumRateController.clear();
      _lumpSumYearsController.clear();
      _lumpSumMaturityAmount = 0;
      _lumpSumTotalDeposit = 0;
      _lumpSumTotalReturn = 0;
      _showLumpSumResults = false;
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
            label: 'Monthly SIP Amount',
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
            hint: 'Enter number of years',
            controller: _sipYearsController,
            prefix: ' ',
            icon: Icons.calendar_today,
          ),
          const SizedBox(height: 30),
          _buildActionButtons(
            onCalculate: _calculateSIP,
            onReset: _resetSIP,
          ),
          const SizedBox(height: 30),
          if (_showSipResults) ...[
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
              amount: _sipMaturityAmount,
              color: Colors.green[600]!,
              icon: Icons.trending_up,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Total Deposit',
              amount: _sipTotalDeposit,
              color: Colors.blue[600]!,
              icon: Icons.account_balance_wallet,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Total Return',
              amount: _sipTotalReturn,
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
            label: 'Lump Sum Amount',
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
            hint: 'Enter number of years',
            controller: _lumpSumYearsController,
            prefix: ' ',
            icon: Icons.calendar_today,
          ),
          const SizedBox(height: 30),
          _buildActionButtons(
            onCalculate: _calculateLumpSum,
            onReset: _resetLumpSum,
          ),
          const SizedBox(height: 30),
          if (_showLumpSumResults) ...[
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
              amount: _lumpSumMaturityAmount,
              color: Colors.green[600]!,
              icon: Icons.trending_up,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Total Deposit',
              amount: _lumpSumTotalDeposit,
              color: Colors.blue[600]!,
              icon: Icons.account_balance_wallet,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Total Return',
              amount: _lumpSumTotalReturn,
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
          'Investment Calculator',
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
            Tab(text: 'SIP Calculator'),
            Tab(text: 'Lump Sum'),
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