import 'dart:math';

void main() {
  var bank = Bank();
  bank._calculateSIP();
}

class Bank {
  void _calculateSIP() {
    // Parse inputs
    double monthlyInvestment = 25000;
    double annualRate = 10;
    int years = 10;

    // Calculate monthly rate
    double monthlyRate = annualRate / 12 / 100;
    int totalMonths = years * 12;

    // Corrected SIP formula: M = P × [((1 + i)^n – 1) / i] × (1 + i)
    num powerTerm = pow(1 + monthlyRate, totalMonths);
    double maturityAmount = monthlyInvestment *
        ((powerTerm - 1) / monthlyRate) *
        (1 + monthlyRate);

    // Round to nearest integer to match Groww's display
    maturityAmount = (maturityAmount / 100).round() * 100.0;

    // Calculate total deposit and return
    double totalDeposit = monthlyInvestment * totalMonths;
    double totalReturn = maturityAmount - totalDeposit;

    print({
      'Total Value': maturityAmount,
      'Invested Amount': totalDeposit,
      'Est. Return': totalReturn
    });
  }
}
