import 'package:flutter/material.dart';

class Bond extends StatelessWidget {
  const Bond({super.key});

  static final List<Map<String, dynamic>> calculators = [
    {
      'name': 'Bonds Overview',
      'description': 'Understand the basics of bonds, their features, and classifications.',
      'icon': Icons.library_books, // More educational/informational
      'gradient': [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)], // Deep gradient for foundational knowledge
      'navigatorBuilder': null
    },
    {
      'name': 'Floating Rate Savings Bonds',
      'description': 'Explore government-issued bonds with interest rates that adjust over time.',
      'icon': Icons.show_chart, // Reflects fluctuation and financial tracking
      'gradient': [const Color(0xFF36D1DC), const Color(0xFF5B86E5)], // Light blue tones for variable/rate-based financials
      'navigatorBuilder': null
    },
    {
      'name': 'Sovereign Gold Bond Scheme',
      'description': 'Invest in gold digitally through government-backed bond schemes.',
      'icon': Icons.account_balance_wallet, // Symbolizes investment and savings
      'gradient': [const Color(0xFFFFD200), const Color(0xFFFFA700)], // Gold/yellow gradient to reflect gold bonds
      'navigatorBuilder': null
    },
    {
      'name': '54EC Bonds',
      'description': 'Learn how to save capital gains tax by investing in 54EC bonds.',
      'icon': Icons.monetization_on, // Financial/savings emphasis
      'gradient': [const Color(0xFF4ECDC4), const Color(0xFF556270)], // Mint to slate tone suggesting secure tax savings
      'navigatorBuilder': null
    }

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bank Calculators',
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
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [const Color(0xFFFFCA28), const Color(0xFFF57F17)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF57F17).withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.monetization_on,
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
                          'Banking Tools',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          'Professional financial calculators for banking',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
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