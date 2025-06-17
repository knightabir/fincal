import 'package:flutter/material.dart';
import 'dart:math';

class SWP extends StatefulWidget {
  const SWP({super.key});

  @override
  State<SWP> createState() => _SWPState();
}

class _SWPState extends State<SWP> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Regular SWP Calculator Controllers
  final TextEditingController _swpInitialAmountController = TextEditingController();
  final TextEditingController _swpWithdrawalAmountController = TextEditingController();
  final TextEditingController _swpRateController = TextEditingController();

  // Period-based SWP Calculator Controllers
  final TextEditingController _periodInitialAmountController = TextEditingController();
  final TextEditingController _periodWithdrawalAmountController = TextEditingController();
  final TextEditingController _periodRateController = TextEditingController();
  final TextEditingController _periodYearsController = TextEditingController();

  // Results for Regular SWP
  double _swpMonthsLasting = 0;
  double _swpTotalWithdrawn = 0;
  double _swpRemainingAmount = 0;

  // Results for Period-based SWP
  double _periodTotalWithdrawn = 0;
  double _periodRemainingAmount = 0;
  double _periodFinalValue = 0;

  // Result visibility flags
  bool _showSwpResults = false;
  bool _showPeriodResults = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _swpInitialAmountController.dispose();
    _swpWithdrawalAmountController.dispose();
    _swpRateController.dispose();
    _periodInitialAmountController.dispose();
    _periodWithdrawalAmountController.dispose();
    _periodRateController.dispose();
    _periodYearsController.dispose();
    super.dispose();
  }

  void _calculateRegularSWP() {
    if (_swpInitialAmountController.text.isEmpty ||
        _swpWithdrawalAmountController.text.isEmpty ||
        _swpRateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    double initialAmount = double.tryParse(_swpInitialAmountController.text) ?? 0;
    double monthlyWithdrawal = double.tryParse(_swpWithdrawalAmountController.text) ?? 0;
    double annualRate = double.tryParse(_swpRateController.text) ?? 0;

    if (initialAmount <= 0 || monthlyWithdrawal <= 0 || annualRate < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    double monthlyRate = annualRate / 12 / 100;
    double currentAmount = initialAmount;
    int months = 0;
    double totalWithdrawn = 0;

    // Calculate how many months the investment will last
    while (currentAmount > 0 && months < 1200) { // Max 100 years
      currentAmount = currentAmount * (1 + monthlyRate) - monthlyWithdrawal;
      months++;
      totalWithdrawn += monthlyWithdrawal;

      if (currentAmount < monthlyWithdrawal) {
        // Last partial withdrawal
        if (currentAmount > 0) {
          totalWithdrawn += currentAmount;
          currentAmount = 0;
        }
        break;
      }
    }

    setState(() {
      _swpMonthsLasting = months.toDouble();
      _swpTotalWithdrawn = totalWithdrawn;
      _swpRemainingAmount = currentAmount > 0 ? currentAmount : 0;
      _showSwpResults = true;
    });
  }

  void _calculatePeriodBasedSWP() {
    if (_periodInitialAmountController.text.isEmpty ||
        _periodWithdrawalAmountController.text.isEmpty ||
        _periodRateController.text.isEmpty ||
        _periodYearsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    double initialAmount = double.tryParse(_periodInitialAmountController.text) ?? 0;
    double monthlyWithdrawal = double.tryParse(_periodWithdrawalAmountController.text) ?? 0;
    double annualRate = double.tryParse(_periodRateController.text) ?? 0;
    int years = int.tryParse(_periodYearsController.text) ?? 0;

    if (initialAmount <= 0 || monthlyWithdrawal <= 0 || annualRate < 0 || years <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    double monthlyRate = annualRate / 12 / 100;
    double currentAmount = initialAmount;
    int totalMonths = years * 12;
    double totalWithdrawn = 0;

    // Calculate for the specified period
    for (int month = 0; month < totalMonths; month++) {
      currentAmount = currentAmount * (1 + monthlyRate);
      if (currentAmount >= monthlyWithdrawal) {
        currentAmount -= monthlyWithdrawal;
        totalWithdrawn += monthlyWithdrawal;
      } else {
        // Can't withdraw full amount
        totalWithdrawn += currentAmount;
        currentAmount = 0;
        break;
      }
    }

    setState(() {
      _periodTotalWithdrawn = totalWithdrawn;
      _periodRemainingAmount = currentAmount;
      _periodFinalValue = currentAmount;
      _showPeriodResults = true;
    });
  }

  void _resetRegularSWP() {
    setState(() {
      _swpInitialAmountController.clear();
      _swpWithdrawalAmountController.clear();
      _swpRateController.clear();
      _swpMonthsLasting = 0;
      _swpTotalWithdrawn = 0;
      _swpRemainingAmount = 0;
      _showSwpResults = false;
    });
  }

  void _resetPeriodBasedSWP() {
    setState(() {
      _periodInitialAmountController.clear();
      _periodWithdrawalAmountController.clear();
      _periodRateController.clear();
      _periodYearsController.clear();
      _periodTotalWithdrawn = 0;
      _periodRemainingAmount = 0;
      _periodFinalValue = 0;
      _showPeriodResults = false;
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
    required String value,
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
            value,
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

  String _formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    )}';
  }

  String _formatDuration(double months) {
    int years = (months / 12).floor();
    int remainingMonths = (months % 12).round();

    if (years > 0 && remainingMonths > 0) {
      return '$years years, $remainingMonths months';
    } else if (years > 0) {
      return '$years years';
    } else {
      return '${remainingMonths.round()} months';
    }
  }

  Widget _buildRegularSWPCalculator() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Initial Investment Amount',
            hint: 'Enter your initial investment',
            controller: _swpInitialAmountController,
            prefix: ' ₹ ',
            icon: Icons.account_balance,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Monthly Withdrawal Amount',
            hint: 'Enter monthly withdrawal',
            controller: _swpWithdrawalAmountController,
            prefix: ' ₹ ',
            icon: Icons.money_off,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Expected Annual Return',
            hint: 'Enter expected return rate',
            controller: _swpRateController,
            prefix: ' % ',
            icon: Icons.trending_up,
          ),
          const SizedBox(height: 30),
          _buildActionButtons(
            onCalculate: _calculateRegularSWP,
            onReset: _resetRegularSWP,
          ),
          const SizedBox(height: 30),
          if (_showSwpResults) ...[
            Text(
              'Withdrawal Plan Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildResultCard(
              title: 'Investment Will Last',
              value: _formatDuration(_swpMonthsLasting),
              color: Colors.green[600]!,
              icon: Icons.schedule,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Total Amount Withdrawn',
              value: _formatCurrency(_swpTotalWithdrawn),
              color: Colors.blue[600]!,
              icon: Icons.money_off,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Remaining Amount',
              value: _formatCurrency(_swpRemainingAmount),
              color: Colors.orange[600]!,
              icon: Icons.savings,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPeriodBasedSWPCalculator() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Initial Investment Amount',
            hint: 'Enter your initial investment',
            controller: _periodInitialAmountController,
            prefix: ' ₹ ',
            icon: Icons.account_balance,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Monthly Withdrawal Amount',
            hint: 'Enter monthly withdrawal',
            controller: _periodWithdrawalAmountController,
            prefix: ' ₹ ',
            icon: Icons.money_off,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Expected Annual Return',
            hint: 'Enter expected return rate',
            controller: _periodRateController,
            prefix: ' % ',
            icon: Icons.trending_up,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Withdrawal Period',
            hint: 'Enter number of years',
            controller: _periodYearsController,
            prefix: ' ',
            icon: Icons.calendar_today,
          ),
          const SizedBox(height: 30),
          _buildActionButtons(
            onCalculate: _calculatePeriodBasedSWP,
            onReset: _resetPeriodBasedSWP,
          ),
          const SizedBox(height: 30),
          if (_showPeriodResults) ...[
            Text(
              'Withdrawal Plan Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildResultCard(
              title: 'Total Amount Withdrawn',
              value: _formatCurrency(_periodTotalWithdrawn),
              color: Colors.blue[600]!,
              icon: Icons.money_off,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Final Investment Value',
              value: _formatCurrency(_periodFinalValue),
              color: Colors.green[600]!,
              icon: Icons.trending_up,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Remaining Balance',
              value: _formatCurrency(_periodRemainingAmount),
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
          'SWP Calculator',
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
            Tab(text: 'Regular SWP'),
            Tab(text: 'Period-based'),
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
              _buildRegularSWPCalculator(),
              _buildPeriodBasedSWPCalculator(),
            ],
          ),
        ),
      ),
    );
  }
}