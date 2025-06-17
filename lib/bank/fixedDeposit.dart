import 'package:flutter/material.dart';
import 'dart:math';

class FixedDeposit extends StatefulWidget {
  const FixedDeposit({super.key});

  @override
  State<FixedDeposit> createState() => _FixedDepositState();
}

class _FixedDepositState extends State<FixedDeposit> {
  // Controllers
  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();

  // Dropdown value for tenure type
  String _tenureType = 'Years';

  // Results
  double _simpleInterestTotalValue = 0;
  double _simpleInterestInvestmentAmount = 0;
  double _simpleInterestEstimatedReturn = 0;
  double _compoundInterestTotalValue = 0;
  double _compoundInterestInvestmentAmount = 0;
  double _compoundInterestEstimatedReturn = 0;

  // Result visibility flag
  bool _showResults = false;

  @override
  void dispose() {
    _investmentController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  void _calculateFD() {
    // Validate input fields
    if (_investmentController.text.isEmpty ||
        _rateController.text.isEmpty ||
        _tenureController.text.isEmpty) {
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
    double principal = double.tryParse(_investmentController.text) ?? 0;
    double annualRate = double.tryParse(_rateController.text) ?? 0;
    double tenure = double.tryParse(_tenureController.text) ?? 0;

    // Validate positive values and minimum tenure
    if (principal <= 0 || annualRate <= 0) {
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
    if (_tenureType == 'Years' && tenure < 0.0833) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tenure must be at least 1 month (0.0833 years)'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    if (_tenureType == 'Months' && tenure < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tenure must be at least 1 month'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Convert tenure to years if in months
    double tenureInYears = _tenureType == 'Months' ? tenure / 12 : tenure;

    // Simple Interest: M = P + (P × r × t / 100)
    double simpleInterestTotalValue = principal + (principal * annualRate * tenureInYears / 100);
    double simpleInterestEstimatedReturn = simpleInterestTotalValue - principal;

    // Compound Interest: M = P × (1 + i/100)^t
    double compoundInterestTotalValue = principal * pow(1 + (annualRate / 100), tenureInYears);
    double compoundInterestEstimatedReturn = compoundInterestTotalValue - principal;

    // Update state with results
    setState(() {
      _simpleInterestTotalValue = simpleInterestTotalValue.roundToDouble();
      _simpleInterestInvestmentAmount = principal;
      _simpleInterestEstimatedReturn = simpleInterestEstimatedReturn.roundToDouble();
      _compoundInterestTotalValue = compoundInterestTotalValue.roundToDouble();
      _compoundInterestInvestmentAmount = principal;
      _compoundInterestEstimatedReturn = compoundInterestEstimatedReturn.roundToDouble();
      _showResults = true;
    });
  }

  void _resetFD() {
    setState(() {
      _investmentController.clear();
      _rateController.clear();
      _tenureController.clear();
      _tenureType = 'Years';
      _simpleInterestTotalValue = 0;
      _simpleInterestInvestmentAmount = 0;
      _simpleInterestEstimatedReturn = 0;
      _compoundInterestTotalValue = 0;
      _compoundInterestInvestmentAmount = 0;
      _compoundInterestEstimatedReturn = 0;
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

  Widget _buildTenureTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tenure Type',
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
          child: DropdownButtonFormField<String>(
            value: _tenureType,
            onChanged: (String? newValue) {
              setState(() {
                _tenureType = newValue!;
              });
            },
            items: <String>['Years', 'Months']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.timer,
                color: Colors.grey[600],
                size: 20,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fixed Deposit Calculator',
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
                  label: 'Total Investment',
                  hint: 'Enter investment amount',
                  controller: _investmentController,
                  prefix: ' ₹ ',
                  icon: Icons.monetization_on_outlined,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  label: 'Rate of Interest (p.a.)',
                  hint: 'Enter annual interest rate',
                  controller: _rateController,
                  prefix: ' % ',
                  icon: Icons.trending_up,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  label: 'Time Period',
                  hint: 'Enter tenure',
                  controller: _tenureController,
                  prefix: ' ',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 20),
                _buildTenureTypeDropdown(),
                const SizedBox(height: 30),
                _buildActionButtons(
                  onCalculate: _calculateFD,
                  onReset: _resetFD,
                ),
                const SizedBox(height: 30),
                if (_showResults) ...[
                  Text(
                    'Simple Interest FD Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildResultCard(
                    title: 'Total Value',
                    amount: _simpleInterestTotalValue,
                    color: Colors.green[600]!,
                    icon: Icons.trending_up,
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard(
                    title: 'Investment Amount',
                    amount: _simpleInterestInvestmentAmount,
                    color: Colors.blue[600]!,
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard(
                    title: 'Estimated Return',
                    amount: _simpleInterestEstimatedReturn,
                    color: Colors.orange[600]!,
                    icon: Icons.savings,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Compound Interest FD Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildResultCard(
                    title: 'Total Value',
                    amount: _compoundInterestTotalValue,
                    color: Colors.green[600]!,
                    icon: Icons.trending_up,
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard(
                    title: 'Investment Amount',
                    amount: _compoundInterestInvestmentAmount,
                    color: Colors.blue[600]!,
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard(
                    title: 'Estimated Return',
                    amount: _compoundInterestEstimatedReturn,
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