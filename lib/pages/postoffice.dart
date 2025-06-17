import 'package:fincal/bank/recurringdeposit.dart';
import 'package:fincal/postoffice/monthlyIncomeScheme.dart';
import 'package:fincal/postoffice/nationalSavingsCertificate.dart';
import 'package:fincal/postoffice/recurringDeposit.dart';
import 'package:fincal/postoffice/timeDeposit.dart';
import 'package:flutter/material.dart';

class PostOfficePage extends StatelessWidget {
  const PostOfficePage({super.key});

  static final List<Map<String, dynamic>> calculators = [
    {
      'name': 'Monthly Income Scheme',
      'description': 'Calculate expected monthly payouts from the Post Office MIS investment.',
      'icon': Icons.payments, // Monthly payout representation
      'gradient': [Color(0xFF42A5F5), Color(0xFF1E88E5)], // Calm and structured blue tones
      'navigatorBuilder': () => MonthlyIncomeScheme(),
    },
    {
      'name': 'Recurring Deposit',
      'description': 'Estimate maturity amount and interest for your RD contributions.',
      'icon': Icons.autorenew, // Recurring nature of deposits
      'gradient': [Color(0xFF26A69A), Color(0xFF00695C)], // Green for growth and consistency
      'navigatorBuilder': () => RecurringDepositPost(),
    },
    {
      'name': 'Time Deposit',
      'description': 'Calculate interest and maturity value for fixed-term deposits.',
      'icon': Icons.access_time, // Reflects the time-bound nature
      'gradient': [Color(0xFF7E57C2), Color(0xFF512DA8)], // Purple for trust and planning
      'navigatorBuilder': () => TimeDeposit(),
    },
    {
      'name': 'National Savings Certificate',
      'description': 'Compute returns and maturity value for NSC investments.',
      'icon': Icons.sticky_note_2, // Certificate/document icon
      'gradient': [Color(0xFF5C6BC0), Color(0xFF3949AB)], // Formal and financial tone
      'navigatorBuilder': () => NationalSavingsCertificate(),
    },
    {
      'name': 'Interest Rates',
      'description': 'Check current interest rates for savings and investment schemes.',
      'icon': Icons.bar_chart, // Shows variable trends like rates
      'gradient': [Color(0xFF66BB6A), Color(0xFF388E3C)], // Green for financial stability and insights
      'navigatorBuilder': null,
    }

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bank & Post Office',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.grey[300],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [Color(0xFFFF9800), Color(0xFFE65100)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF9800).withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.local_post_office,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Post Office',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Calculate your basic loan EMI payments',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemCount: calculators.length,
                  itemBuilder: (context, index) {
                    final item = calculators[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          if (item['navigatorBuilder'] != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => item['navigatorBuilder'](),
                              ),
                            );
                          } else {
                            // Show a snackbar for unimplemented calculators
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item['name']} - Coming Soon!'),
                                backgroundColor: Colors.orange[600],
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: item['gradient'],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (item['gradient'][1] as Color).withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    item['icon'],
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['description'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
