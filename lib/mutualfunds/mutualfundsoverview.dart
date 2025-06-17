import 'package:flutter/material.dart';

class MutualFundOverview extends StatefulWidget {
  const MutualFundOverview({super.key});

  @override
  _MutualFundOverviewState createState() => _MutualFundOverviewState();
}

class _MutualFundOverviewState extends State<MutualFundOverview> {
  final List<bool> _isExpanded = [];

  final List<Map<String, String>> _faqData = [
    {
      'question': 'What are Mutual Funds?',
      'answer': 'Mutual funds are investment vehicles that pool money from multiple investors to purchase a diversified portfolio of stocks, bonds, or other securities. They are managed by professional fund managers who make investment decisions on behalf of the investors.'
    },
    {
      'question': 'How do Mutual Funds work?',
      'answer': 'When you invest in a mutual fund, you buy shares of the fund. The fund uses your money along with money from other investors to buy various securities. The value of your investment goes up or down based on the performance of these securities.'
    },
    {
      'question': 'What are the types of Mutual Funds?',
      'answer': 'There are several types: Equity funds (invest in stocks), Debt funds (invest in bonds), Hybrid funds (mix of stocks and bonds), Index funds (track market indices), and Sector funds (focus on specific industries).'
    },
    {
      'question': 'What is SIP in Mutual Funds?',
      'answer': 'SIP (Systematic Investment Plan) allows you to invest a fixed amount regularly (monthly, quarterly) in mutual funds. It helps in rupee cost averaging and disciplined investing, making it easier to build wealth over time.'
    },
    {
      'question': 'What are the benefits of investing in Mutual Funds?',
      'answer': 'Key benefits include professional management, diversification, liquidity, affordability (low minimum investment), tax benefits (in ELSS funds), and the potential for higher returns compared to traditional savings.'
    },
    {
      'question': 'What are the risks involved?',
      'answer': 'Mutual funds carry market risk, meaning the value can fluctuate. Other risks include credit risk (for debt funds), liquidity risk, and manager risk. However, diversification helps reduce overall risk compared to individual stocks.'
    },
    {
      'question': 'How are Mutual Funds taxed?',
      'answer': 'Equity funds: Long-term gains (>1 year) above ₹1 lakh are taxed at 10%. Short-term gains are taxed at 15%. Debt funds: Gains are taxed as per your income tax slab. ELSS funds offer tax deduction under Section 80C.'
    },
    {
      'question': 'What is NAV in Mutual Funds?',
      'answer': 'NAV (Net Asset Value) is the price per unit of a mutual fund. It\'s calculated by dividing the total value of all securities in the fund by the number of outstanding units. NAV is updated daily after market hours.'
    },
    {
      'question': 'What is the minimum investment amount?',
      'answer': 'Most mutual funds have a minimum investment of ₹500-₹1,000 for lump sum and ₹100-₹500 for SIP investments. Some funds may have higher minimums, but generally, mutual funds are accessible to small investors.'
    },
    {
      'question': 'How to choose the right Mutual Fund?',
      'answer': 'Consider your financial goals, risk tolerance, investment horizon, fund performance history, expense ratio, fund manager\'s track record, and asset allocation. It\'s advisable to consult with a financial advisor for personalized advice.'
    }
  ];

  @override
  void initState() {
    super.initState();
    _isExpanded.addAll(List.generate(_faqData.length, (index) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mutual Funds',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Section
              Card(
                elevation: 4,
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Mutual Funds Overview',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Mutual funds are a great way to invest in the stock market without having to pick individual stocks. They offer professional management, diversification, and the potential for good returns over the long term.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // FAQ Section Header
              Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),

              SizedBox(height: 16),

              // FAQ Cards
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _faqData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      elevation: 2,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          backgroundColor: Colors.white,
                          collapsedBackgroundColor: Colors.white,
                          iconColor: Colors.blue[600],
                          collapsedIconColor: Colors.grey[600],
                          title: Text(
                            _faqData[index]['question']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.grey[800],
                            ),
                          ),
                          trailing: Icon(
                            _isExpanded[index]
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: _isExpanded[index]
                                ? Colors.blue[600]
                                : Colors.grey[600],
                          ),
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _isExpanded[index] = expanded;
                            });
                          },
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _faqData[index]['answer']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 20),

              // Bottom Info Card
              Card(
                elevation: 4,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.orange[600], size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Investment Tip',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start investing early and regularly through SIP to benefit from the power of compounding. Diversify your portfolio across different types of mutual funds based on your risk appetite and financial goals.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}