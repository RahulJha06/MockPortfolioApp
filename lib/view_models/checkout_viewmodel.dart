import 'package:flutter/cupertino.dart';
import 'package:portfolio_monitor/models/company_action.dart';
import 'package:portfolio_monitor/models/company_profile.dart';

class ShortList extends ChangeNotifier {
  final List<CompanyAction> _shortList = <CompanyAction>[];

  List<CompanyAction> get shortList => _shortList;

  void addToList(Company C, String action) {
    bool _update = false;
    _shortList.forEach((element) {
      if (element.company.name == C.name) {
        element.action = action;
        _update = true;
      }
    });
    if (!_update) _shortList.add(new CompanyAction(C, action));
    print(_shortList);
  }

  void removeFromList(Company C) {
    _shortList.removeWhere((element) => element.company.name == C.name);
    notifyListeners();
  }
}
