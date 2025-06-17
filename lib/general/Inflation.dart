import 'package:flutter/material.dart';
import 'dart:math';

class Inflation extends StatefulWidget {
  const Inflation({super.key});

  @override
  State<Inflation> createState() => _InflationState();
}

class _InflationState extends State<Inflation> {
  // Controllers
  final TextEditingController _currentCostController = TextEditingController();
  final TextEditingController _inflationRateController = TextEditingController();
  final TextEditingController _termController = TextEditingController();

  // Results
  double _futureCost = 0;
  double _currentCost = 0;
  double _inflationIncrease = 0;

  // Result visibility flag
  bool _showResults = false;

  @override
  void dispose() {
    _currentCostController.dispose();
    _inflationRateController.dispose();
    _termController.dispose();
    super.dispose();
  }

  void _calculateInflation() {
    // Validate input fields
    if (_currentCostController.text.isEmpty ||
        _inflationRateController.text.isEmpty ||
        _termController.text.isEmpty) {
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
    double currentCost = double.tryParse(_currentCostController.text) ?? 0;
    double inflationRate = double.tryParse(_inflationRateController.text) ?? 0;
    double term = double.tryParse(_termController.text) ?? 0;

    // Validate positive values and minimum term
    if (currentCost <= 0 || inflationRate <= 0) {
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
    if (term < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Term must be at least 1 year'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Calculate Future Cost: FC = CC × (1 + R/100)^T
    double futureCost = currentCost * pow(1 + (inflationRate / 100), term);
    double inflationIncrease = futureCost - currentCost;

    // Update state with results
    setState(() {
      _futureCost = futureCost.roundToDouble();
      _currentCost = currentCost;
      _inflationIncrease = inflationIncrease.roundToDouble();
      _showResults = true;
    });
  }

  void _resetInflation() {
    setState(() {
      _currentCostController.clear();
      _inflationRateController.clear();
      _termController.clear();
      _futureCost = 0;
      _currentCost = 0;
      _inflationIncrease = 0;
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
          'Inflation Calculator',
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
                  label: 'Current Cost',
                  hint: 'Enter current cost of item',
                  controller: _currentCostController,
                  prefix: ' ₹ ',
                  icon: Icons.monetization_on_outlined,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  label: 'Expected Annual Inflation Rate',
                  hint: 'Enter inflation rate',
                  controller: _inflationRateController,
                  prefix: ' % ',
                  icon: Icons.trending_up,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  label: 'Term (in years)',
                  hint: 'Enter term',
                  controller: _termController,
                  prefix: ' ',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 30),
                _buildActionButtons(
                  onCalculate: _calculateInflation,
                  onReset: _resetInflation,
                ),
                const SizedBox(height: 30),
                if (_showResults) ...[
                  Text(
                    'Inflation Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildResultCard(
                    title: 'Future Cost',
                    amount: _futureCost,
                    color: Colors.green[600]!,
                    icon: Icons.trending_up,
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard(
                    title: 'Current Cost',
                    amount: _currentCost,
                    color: Colors.blue[600]!,
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard(
                    title: 'Inflation Increase',
                    amount: _inflationIncrease,
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