import 'dart:math';
import 'package:flutter/material.dart';

class EmiCalculatorPage extends StatefulWidget {
  @override
  _EmiCalculatorPageState createState() => _EmiCalculatorPageState();
}

class _EmiCalculatorPageState extends State<EmiCalculatorPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String _timeType = 'months';

  double? _emi;
  double? _totalPaid;
  double? _interestPaid;
  double? _principal;

  void _calculate() {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Parse input values with null checks
        double? principal = double.tryParse(_principalController.text.trim());
        double? rate = double.tryParse(_rateController.text.trim());
        int? time = int.tryParse(_timeController.text.trim());

        if (principal == null || rate == null || time == null) {
          _showErrorMessage('Please enter valid numbers for all fields');
          return;
        }

        if (principal <= 0 || rate <= 0 || time <= 0) {
          _showErrorMessage('All values must be positive numbers');
          return;
        }

        double emi = calculateEmi(principal, rate, time, _timeType);
        int totalMonths = _timeType == 'months' ? time : time * 12;
        double totalPaid = emi * totalMonths;
        double interestPaid = totalPaid - principal;

        setState(() {
          _principal = principal;
          _emi = emi;
          _totalPaid = double.parse(totalPaid.toStringAsFixed(2));
          _interestPaid = double.parse(interestPaid.toStringAsFixed(2));
        });
      } catch (e) {
        _showErrorMessage('Error calculating EMI: ${e.toString()}');
      }
    } else {
      _showErrorMessage('Please fill all required fields correctly');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  double calculateEmi(double principal, double rate, int time, String type) {
    if (principal <= 0 || rate <= 0 || time <= 0) {
      throw ArgumentError('All values must be positive numbers.');
    }

    if (type != 'months' && type != 'years') {
      throw ArgumentError('Time type must be either "months" or "years".');
    }

    double monthlyRate = rate / 12 / 100;
    int months = type == 'months' ? time : time * 12;

    double emi = principal * monthlyRate * pow(1 + monthlyRate, months) /
        (pow(1 + monthlyRate, months) - 1);

    return double.parse(emi.toStringAsFixed(2));
  }

  void _reset() {
    setState(() {
      _principalController.clear();
      _rateController.clear();
      _timeController.clear();
      _timeType = 'months';
      _emi = null;
      _totalPaid = null;
      _interestPaid = null;
      _principal = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'EMI Calculator',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[300],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Card
              Card(
                elevation: 8,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loan Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Principal Amount
                      _buildInputField(
                        controller: _principalController,
                        label: 'Principal Amount',
                        hint: 'Enter loan amount',
                        icon: Icons.currency_rupee,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Principal amount is required';
                          }
                          double? amount = double.tryParse(value.trim());
                          if (amount == null) {
                            return 'Enter a valid number';
                          }
                          if (amount <= 0) {
                            return 'Amount must be greater than 0';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Interest Rate
                      _buildInputField(
                        controller: _rateController,
                        label: 'Annual Interest Rate (%)',
                        hint: 'Enter interest rate',
                        icon: Icons.percent,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Interest rate is required';
                          }
                          double? rate = double.tryParse(value.trim());
                          if (rate == null) {
                            return 'Enter a valid number';
                          }
                          if (rate <= 0) {
                            return 'Rate must be greater than 0';
                          }
                          if (rate > 100) {
                            return 'Rate seems too high';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Loan Duration
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildInputField(
                              controller: _timeController,
                              label: 'Loan Duration',
                              hint: 'Enter duration',
                              icon: Icons.schedule,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Duration is required';
                                }
                                int? time = int.tryParse(value.trim());
                                if (time == null) {
                                  return 'Enter a valid number';
                                }
                                if (time <= 0) {
                                  return 'Duration must be greater than 0';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _timeType,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  labelText: 'Type',
                                  labelStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                style: TextStyle(color: Colors.black87, fontSize: 14),
                                items: [
                                  DropdownMenuItem(value: 'months', child: Text('Months')),
                                  DropdownMenuItem(value: 'years', child: Text('Years')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _timeType = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _calculate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calculate, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Calculate EMI',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _reset();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Icon(Icons.refresh, size: 20),
                  ),
                ],
              ),

              // Results Card
              if (_emi != null && _principal != null && _totalPaid != null && _interestPaid != null) ...[
                SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue[600]!, Colors.blue[800]!],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.analytics, color: Colors.white, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'EMI Breakdown',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          _buildResultItem(
                            'Monthly EMI',
                            '₹${_emi!.toStringAsFixed(2)}',
                            Icons.payments,
                            isHighlight: true,
                          ),
                          _buildResultItem(
                            'Principal Amount',
                            '₹${_principal!.toStringAsFixed(2)}',
                            Icons.account_balance_wallet,
                          ),
                          _buildResultItem(
                            'Total Interest',
                            '₹${_interestPaid!.toStringAsFixed(2)}',
                            Icons.trending_up,
                          ),
                          _buildResultItem(
                            'Total Payment',
                            '₹${_totalPaid!.toStringAsFixed(2)}',
                            Icons.receipt_long,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blue[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: Colors.grey[600]),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        validator: validator,
      ),
    );
  }

  Widget _buildResultItem(String label, String value, IconData icon, {bool isHighlight = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: isHighlight ? Border.all(color: Colors.white.withOpacity(0.3)) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isHighlight ? 18 : 16,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}