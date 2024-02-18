import 'package:flutter/material.dart';

class DataModel extends ChangeNotifier {
  Map<String, double> totalInterestMap = {};
  Map<String, double> totalAmountMap = {};

  void updateTotals(String farmerId, double interest, double amount) {
    totalInterestMap[farmerId] = interest;
    totalAmountMap[farmerId] = amount;
    // Defer the call to notifyListeners() using Future.microtask
    Future.microtask(() => notifyListeners());
  }
}
