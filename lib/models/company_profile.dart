import 'package:portfolio_monitor/services/nifty_company_profile.dart';

class Company {
  String name;
  String _industry;
  double _openingPrice;
  String _imageUri;
  double buyingPrice = 0;
  double sellingPrice = 0;

  double get change {
    return double.parse((100 *
            (_openingPrice -
                NiftyCompanyProfileAPI.getCurrentPrice(this.name)) /
            _openingPrice)
        .toStringAsPrecision(5));
  }

  String get image => _imageUri;

  void set image(String uri) {
    _imageUri = uri;
  }

  double _currentPrice;

  String get industry => _industry;

  set industry(String value) {
    _industry = value;
  }

  double get openingPrice => _openingPrice;

  set openingPrice(double value) {
    _openingPrice = value;
  }

  double get currentPrice => _currentPrice;

  @override
  String toString() {
    return 'Company{_name: $name, _currentPrice: $_currentPrice}';
  }

  set currentPrice(double value) {
    _currentPrice = value;
  }
}
