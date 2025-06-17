import 'package:flutter/material.dart';

class Insurance extends StatelessWidget {
  const Insurance({super.key});


  static final List<Map<String, dynamic>> calculators = [
    {
      'name': 'Postal Life Insurance',
      'description': 'Estimate premiums and policy benefits for Postal Life Insurance plans.',
      'icon': Icons.security, // More representative of insurance/protection
      'gradient': [const Color(0xFF6A11CB), const Color(0xFF2575FC)], // Violet-blue
      'navigatorBuilder': null
    },
    {
      'name': 'Rural Postal Life Insurance',
      'description': 'Access tools to calculate and understand rural life insurance options.',
      'icon': Icons.nature_people, // Reflects rural/community tone
      'gradient': [const Color(0xFF56ab2f), const Color(0xFFA8E063)], // Green shades for rural context
      'navigatorBuilder': null
    },
    {
      'name': 'PM Jeevan Jyoti Bima',
      'description': 'Check eligibility and coverage details for PMJJBY (Life Insurance Scheme).',
      'icon': Icons.favorite, // Symbolizes life and care
      'gradient': [const Color(0xFFFF416C), const Color(0xFFFF4B2B)], // Red-pink for life and energy
      'navigatorBuilder': null
    },
    {
      'name': 'PM Suraksha Bima',
      'description': 'View accident coverage and premium details under PMSBY scheme.',
      'icon': Icons.health_and_safety, // Indicates safety and protection
      'gradient': [const Color(0xFF11998e), const Color(0xFF38ef7d)], // Teal-green for protection
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
                        colors: [const Color(0xFF5C6BC0), const Color(0xFF3949AB)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3949AB).withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.security,
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