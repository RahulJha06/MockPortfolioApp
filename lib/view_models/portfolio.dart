import 'package:flutter/material.dart';
import 'package:portfolio_monitor/models/company_profile.dart';
import 'package:portfolio_monitor/services/nifty_company_profile.dart';

class Portfolio extends ChangeNotifier {
  final List<Company> _portfolio = <Company>[];
  List<Company> get portfolio => _portfolio;

  final int _portfolioLimit = 10;
  int get portfolioLimit => _portfolioLimit;

  int get portfolioSize => _portfolio.length;

  double get portfolioPerformance {
    double value = 0.0;
    _portfolio.forEach((stock) {
      value += (stock.buyingPrice -
          NiftyCompanyProfileAPI.getCurrentPrice(stock.name));
    });
    return value;
  }

  void addToPortfolio(Company C) {
    bool updated = false;
    if (_portfolio.length < 10) {
      _portfolio.forEach((element) {
        if (element.name == C.name) {
          element.currentPrice = C.currentPrice;
          updated = true;
        }
      });
      if (!updated) _portfolio.add(C);
      print(_portfolio.toString());
      notifyListeners();
    }
  }

  void removeFromPortfolio(Company C) {
    _portfolio.removeWhere((element) => element.name == C.name);
    notifyListeners();
  }
}
