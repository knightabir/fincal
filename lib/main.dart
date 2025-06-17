import 'package:fincal/pages/bankandpostoffice.dart';
import 'package:fincal/pages/bond.dart';
import 'package:fincal/pages/general.dart';
import 'package:fincal/pages/insurance.dart';
import 'package:fincal/pages/mutualFund.dart';
import 'package:fincal/pages/retirement.dart';
import 'package:fincal/pages/tax.dart';
import 'package:flutter/material.dart';
import './pages/bank.dart';
import './pages/postoffice.dart';
import './pages/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MyHomePage(),
    const SettingsPage(),
  ];

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: const Color(0xFF757575),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> _items = [
    {
      'name': 'Bank',
      'icon': Icons.account_balance,
      'gradient': [const Color(0xFF42A5F5), const Color(0xFF1E88E5)],
      'backgroundColor': const Color(0xFFE3F2FD),
      'navigatorBuilder': () => const BankPage(),
    },
    {
      'name': 'Bank and Post Office',
      'icon': Icons.business,
      'gradient': [const Color(0xFF66BB6A), const Color(0xFF388E3C)],
      'backgroundColor': const Color(0xFFE8F5E8),
      'navigatorBuilder': () => const BankAndPostOffice(),
    },
    {
      'name': 'Post Office',
      'icon': Icons.local_post_office,
      'gradient': [const Color(0xFFFF9800), const Color(0xFFE65100)],
      'backgroundColor': const Color(0xFFFFF3E0),
      'navigatorBuilder': () => const PostOfficePage(),
    },
    {
      'name': 'Mutual Funds',
      'icon': Icons.trending_up,
      'gradient': [const Color(0xFFAB47BC), const Color(0xFF7B1FA2)],
      'backgroundColor': const Color(0xFFF3E5F5),
      'navigatorBuilder': () => MutualFundPage(),
    },
    {
      'name': 'Retirement',
      'icon': Icons.elderly,
      'gradient': [const Color(0xFF26A69A), const Color(0xFF00695C)],
      'backgroundColor': const Color(0xFFE0F2F1),
      'navigatorBuilder': () => Retirement(),
    },
    {
      'name': 'TAX',
      'icon': Icons.receipt_long,
      'gradient': [const Color(0xFFEF5350), const Color(0xFFC62828)],
      'backgroundColor': const Color(0xFFFFEBEE),
      'navigatorBuilder':() => Tax(),
    },
    {
      'name': 'Insurance',
      'icon': Icons.security,
      'gradient': [const Color(0xFF5C6BC0), const Color(0xFF3949AB)],
      'backgroundColor': const Color(0xFFE8EAF6),
      'navigatorBuilder': () => Insurance(),
    },
    {
      'name': 'Bonds',
      'icon': Icons.monetization_on,
      'gradient': [const Color(0xFFFFCA28), const Color(0xFFF57F17)],
      'backgroundColor': const Color(0xFFFFFDE7),
      'navigatorBuilder': () => Bond(),
    },
    {
      'name': 'General',
      'icon': Icons.calculate,
      'gradient': [const Color(0xFF26C6DA), const Color(0xFF00838F)],
      'backgroundColor': const Color(0xFFE0F7FA),
      'navigatorBuilder': () => General(),
    },
  ];

  void _navigateToPage(Map<String, dynamic> item) {
    if (item['navigatorBuilder'] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => item['navigatorBuilder'](),
        ),
      );
    } else {
      // Show a snackbar for unimplemented pages
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item['name']} - Coming Soon!'),
          backgroundColor: const Color(0xFFFF9800),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Financial Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: const Color(0xFFE0E0E0),
        foregroundColor: const Color(0xFF424242),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Choose a Financial Tool',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                ),
              ),
              const Text(
                'Select from our comprehensive financial calculators',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF757575),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];

                    return GestureDetector(
                      onTap: () {
                        if (item['navigatorBuilder'] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => item['navigatorBuilder'](),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item['name']} - Coming Soon!'),
                              backgroundColor: const Color(0xFFFF9800),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: item['gradient'],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: (item['gradient'][1] as Color).withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                item['icon'],
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                item['name']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF424242),
                                ),
                              ),
                            ),
                          ],
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