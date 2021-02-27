import 'package:portfolio_monitor/models/company_profile.dart';

class CompanyAction {
  Company _C;

  Company get company => _C;

  String action;

  CompanyAction(Company C, String action) {
    _C = C;
    this.action = action;
  }
}
