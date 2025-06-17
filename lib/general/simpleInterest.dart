import 'package:flutter/material.dart';

class SimpleInterest extends StatefulWidget {
  const SimpleInterest({super.key});

  @override
  State<SimpleInterest> createState() => _SimpleInterestState();
}

class _SimpleInterestState extends State<SimpleInterest> {
  // Controllers
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Dropdown value for time type
  String _timeType = 'Years';

  // Results
  double _totalAmount = 0;
  double _principalAmount = 0;
  double _simpleInterest = 0;

  // Result visibility flag
  bool _showResults = false;

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _calculateSimpleInterest() {
    // Validate input fields
    if (_principalController.text.isEmpty ||
        _rateController.text.isEmpty ||
        _timeController.text.isEmpty) {
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
    double principal = double.tryParse(_principalController.text) ?? 0;
    double annualRate = double.tryParse(_rateController.text) ?? 0;
    double time = double.tryParse(_timeController.text) ?? 0;

    // Validate positive values and minimum time
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
    if (_timeType == 'Years' && time < 0.0833) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Time period must be at least 1 month (0.0833 years)'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    if (_timeType == 'Months' && time < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Time period must be at least 1 month'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Convert time to years if in months
    double timeInYears = _timeType == 'Months' ? time / 12 : time;

    // Calculate Simple Interest: SI = (P × R × T) / 100
    double simpleInterest = (principal * annualRate * timeInYears) / 100;
    double totalAmount = principal + simpleInterest;

    // Update state with results
    setState(() {
      _totalAmount = totalAmount.roundToDouble();
      _principalAmount = principal;
      _simpleInterest = simpleInterest.roundToDouble();
      _showResults = true;
    });
  }

  void _resetSimpleInterest() {
    setState(() {
      _principalController.clear();
      _rateController.clear();
      _timeController.clear();
      _timeType = 'Years';
      _totalAmount = 0;
      _principalAmount = 0;
      _simpleInterest = 0;
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

  Widget _buildTenureTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Type',
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
            value: _timeType,
            onChanged: (String? newValue) {
              setState(() {
                _timeType = newValue!;
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
          'Simple Interest Calculator',
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
                  label: 'Principal Amount',
                  hint: 'Enter principal amount',
                  controller: _principalController,
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
                  hint: 'Enter time period',
                  controller: _timeController,
                  prefix: ' ',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 20),
                _buildTenureTypeDropdown(),
                const SizedBox(height: 30),
                _buildActionButtons(
                  onCalculate: _calculateSimpleInterest,
                  onReset: _resetSimpleInterest,
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
                    title: 'Total Amount',
                    amount: _totalAmount,
                    color: Colors.green[600]!,
                    icon: Icons.trending_up,
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard(
                    title: 'Principal Amount',
                    amount: _principalAmount,
                    color: Colors.blue[600]!,
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 12),
                  _buildResultCard(
                    title: 'Simple Interest',
                    amount: _simpleInterest,
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